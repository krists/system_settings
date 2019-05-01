import ky from 'ky';
import {apiPath} from "../routes/backend";
import { slowdown } from "../utils/slowdown";

export const LIST_FETCH_IN_PROGRESS = "LIST_FETCH_IN_PROGRESS";
export const LIST_FETCH_SUCCESSFUL = "LIST_FETCH_SUCCESSFUL";
export const LIST_FETCH_FAILED = "LIST_FETCH_FAILED";

export const PER_PAGE = 5;

export function fetchList(page) {
    return async function (dispatch) {
        const path = apiPath("settings");
        try {
            dispatch({type: LIST_FETCH_IN_PROGRESS});
            const json = await slowdown(50, ky.get(path, {searchParams: {page: page, per: PER_PAGE}}).json());
            dispatch({type: LIST_FETCH_SUCCESSFUL, data: json, page: page});
        } catch(error) {

            let message = (error.name === "HTTPError") ? `Network request status: ${error.response.status} ${error.message}` : error.message;

            dispatch({type: LIST_FETCH_FAILED, errorMessage: message, page: page});
            throw error;
        }
    }
}