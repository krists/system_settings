import { connect } from 'react-redux';
import { EditPage } from '../components/EditPage';
import { fetchSetting } from "../actions/setting";

const mapStateToProps = ((store) => {
    return {
        attributes: store["setting"].attributes,
        authenticityToken: store["setting"].authenticityToken,
        fetching: store["setting"].fetching,
        fetchSuccessful: store["setting"].fetchSuccessful,
        fetchErrorMessage: store["setting"].fetchErrorMessage,
    }
});

const mapDispatchToProps = (dispatch) => {
    return {
        fetch: (id) => {
            fetchSetting(id)(dispatch).catch(() => {})
        }
    }
};

export const ConnectedEditPage = connect(mapStateToProps, mapDispatchToProps)(EditPage);