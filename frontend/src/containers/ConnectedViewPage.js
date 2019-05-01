import { connect } from 'react-redux';
import { ViewPage } from '../components/ViewPage';
import { fetchSetting } from "../actions/setting";

const mapStateToProps = ((store) => {
    return {
        attributes: store["setting"].attributes,
        fetching: store["setting"].fetching,
        fetchSuccessful: store["setting"].fetchSuccessful,
        fetchErrorMessage: store["setting"].fetchErrorMessage,
    }
});

const mapDispatchToProps = (dispatch, ownProps) => {
    return {
        fetch: (id) => {
            return fetchSetting(id)(dispatch)
        }

    }
};

export const ConnectedViewPage = connect(mapStateToProps, mapDispatchToProps)(ViewPage);