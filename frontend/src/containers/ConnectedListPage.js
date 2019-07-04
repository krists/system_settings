import { connect } from 'react-redux';
import ListPage from '../components/ListPage';
import { fetchList } from "../actions/list"

const LIST_STORE = "list";

const mapStateToProps = ((store) => {
    return {
        page: store[LIST_STORE].page,
        items: store[LIST_STORE].items,
        itemsCount: store[LIST_STORE].totalCount,
        fetching: store[LIST_STORE].fetching,
        fetchSuccessful: store[LIST_STORE].fetchSuccessful,
        fetchErrorMessage: store[LIST_STORE].fetchErrorMessage,
    }
});

const mapDispatchToProps = (dispatch) => {
    return {
        fetch: (page, per_page) => {
            fetchList(page, per_page)(dispatch).catch(() => {})
        }
    }
};

export const ConnectedListPage = connect(mapStateToProps, mapDispatchToProps)(ListPage);
