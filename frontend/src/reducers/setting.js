import {
    SETTING_FETCH_IN_PROGRESS,
    SETTING_FETCH_SUCCESSFUL,
    SETTING_FETCH_FAILED,
    SETTING_SAVE_IN_PROGRESS,
    SETTING_SAVE_SUCCESSFUL,
    SETTING_SAVE_FAILED
} from "../actions/setting";

const initialState = {
    attributes: {},
    authenticityToken: null,
    fetching: true,
    fetchErrorMessage: null,
    fetchSuccessful: null,
    saving: false,
    lastSaveSuccessful: null,
    saveErrorMessage: null
};

export default function(state = initialState, action) {
    switch(action.type){
        case SETTING_FETCH_IN_PROGRESS:
            return { ...state, fetching: true, fetchSuccessful: null, fetchErrorMessage: null };
        case SETTING_FETCH_SUCCESSFUL:
            return { ...state, fetching: false, fetchSuccessful: true, attributes: action.attributes, authenticityToken: action.authenticityToken};
        case SETTING_FETCH_FAILED:
            return { ...state, fetching: false, fetchSuccessful: false, fetchErrorMessage: action.errorMessage};
        case SETTING_SAVE_IN_PROGRESS:
            return { ...state, saving: true, lastSaveSuccessful: null, saveErrorMessage: null };
        case SETTING_SAVE_SUCCESSFUL:
            return { ...state, saving: false, lastSaveSuccessful: true };
        case SETTING_SAVE_FAILED:
            return { ...state, saving: false, lastSaveSuccessful: false, saveErrorMessage: action.errorMessage};
        default:
            return state;
    }
}
