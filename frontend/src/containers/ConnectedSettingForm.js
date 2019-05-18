import { connect } from 'react-redux';
import { SettingForm } from '../components/SettingForm';
import { reduxForm } from 'redux-form';
import { saveSetting } from "../actions/setting"
import {formatValueForForm} from "../utils/secrets";

const mapStateToProps = ((store) => {
    let {fetchSuccessful, attributes} = store["setting"];
    return {
        initialValues: {
            ...attributes,
            value: fetchSuccessful ? formatValueForForm(attributes.type, attributes.value) : attributes.value
        }
    }
});

const mapDispatchToProps = (dispatch, ownProps) => {
    return {
        myHandleSubmit: (values) => {
            return saveSetting(ownProps.id, ownProps.authenticityToken, {value: values.value})(dispatch)
        }
    }
};

export default connect(mapStateToProps, mapDispatchToProps)(reduxForm({form: "edit-setting"})(SettingForm))
