import { connect } from 'react-redux';
import ListPage from '../components/ListPage';
import { fetchList } from "../actions/list"

const LIST_STORE = "list";

const mapStateToProps = ((store) => {
    return {
        page: store[LIST_STORE].page,
        list: store[LIST_STORE].items,
        fetching: store[LIST_STORE].fetching,
        fetchSuccessful: store[LIST_STORE].fetchSuccessful,
        fetchErrorMessage: store[LIST_STORE].fetchErrorMessage,
    }
});

const mapDispatchToProps = (dispatch) => {
    return {
        fetch: (page) => {
            fetchList(page)(dispatch).catch(() => {})
        }
    }
};

export const ConnectedListPage = connect(mapStateToProps, mapDispatchToProps)(ListPage);
