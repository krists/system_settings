import {
    LIST_FETCH_IN_PROGRESS,
    LIST_FETCH_SUCCESSFUL,
    LIST_FETCH_FAILED
} from "../actions/list";

const initialState = {
    fetching: true,
    fetchErrorMessage: null,
    fetchSuccessful: null,
    page: 0,
    items: [],
    totalCount: 0
};

export default function(state = initialState, action) {
    switch(action.type){
        case LIST_FETCH_IN_PROGRESS:
            return { ...state, fetching: true };
        case LIST_FETCH_SUCCESSFUL:
            return { ...state, fetching: false, fetchSuccessful: true, items: action.data["items"].map((attrs) => {
                return { id: attrs.id, type: attrs.type, name: attrs.name, value: attrs.value, description: attrs.description }
            }), page: action.page, totalCount: action.data["total_count"] };
        case LIST_FETCH_FAILED:
            return { ...state, fetching: false, fetchSuccessful: false, items: [], fetchErrorMessage: action.errorMessage, page: action.page };
        default:
            return state;
    }
}
