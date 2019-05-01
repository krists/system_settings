import ky from 'ky';

import {apiPath} from "../routes/backend";
import { slowdown } from "../utils/slowdown";
import { SubmissionError } from 'redux-form';

export const SETTING_FETCH_IN_PROGRESS = "SETTING_FETCH_IN_PROGRESS";
export const SETTING_FETCH_SUCCESSFUL = "SETTING_FETCH_SUCCESSFUL";
export const SETTING_FETCH_FAILED = "SETTING_FETCH_FAILED";

export const SETTING_SAVE_IN_PROGRESS = "SETTING_SAVE_IN_PROGRESS";
export const SETTING_SAVE_SUCCESSFUL = "SETTING_SAVE_SUCCESSFUL";
export const SETTING_SAVE_FAILED = "SETTING_SAVE_FAILED";

export function fetchSetting(id) {
    return async function (dispatch) {
        const path = apiPath(`settings/${id}`);
        try {
            dispatch({type: SETTING_FETCH_IN_PROGRESS});
            const response = await slowdown(50, ky.get(path));
            if(!response.ok){
                throw new Error(response.statusText)
            }
            const token = response.headers.get("Authenticity-Token");
            const json = await response.json();
            dispatch({type: SETTING_FETCH_SUCCESSFUL, authenticityToken: token, attributes: json});
        } catch(error) {

            let message = (error.name === "HTTPError") ? `Network request status: ${error.response.status} ${error.message}` : error.message;

            dispatch({type: SETTING_FETCH_FAILED, errorMessage: message});
            throw error;
        }
    }
}

function addAuthenticityToken(token) {
    return (options) => options.headers.set("X-CSRF-Token", token);
}

export function saveSetting(id, csrfToken, attributes) {
    return async function (dispatch) {
        const path = apiPath(`settings/${id}`);
        dispatch({type: SETTING_SAVE_IN_PROGRESS});
        try {
            const response = await slowdown(300, ky.put(path, {
                json: attributes,
                hooks: {
                    beforeRequest: [addAuthenticityToken(csrfToken)]
                }
            }));

            const parsed = await response.json();

            dispatch({type: SETTING_SAVE_SUCCESSFUL, attributes: parsed});
        } catch (error) {
            dispatch({type: SETTING_SAVE_FAILED, errorMessage: error.name});

            if(error.name === "HTTPError") {
                if (error.response.status === 422){
                    try {
                        const json = await error.response.json();
                        throw new SubmissionError(json.errors);
                    } catch (jsonParseError) {
                        throw new SubmissionError({_error: error.message});
                    }

                } else {
                    let message = `${error.response.status} ${error.message}`;
                    throw new SubmissionError({_error: message});
                }
            } else {
                throw new SubmissionError({_error: error.message});
            }
        }
    }
}
