import React from 'react'
import PropTypes from 'prop-types'
import { Field } from 'redux-form'
import {LabeledInput} from "./LabeledInput";
import styles from "./SettingForm.module.css"
import {ButtonBar} from "./ButtonBar";
import {Link} from "react-router-dom";
import ClassicSpinner from "./ClassicSpinner";

export class SettingForm extends React.Component {
    render(){
        let {
            hint,
            handleSubmit,
            myHandleSubmit,
            error,
            pristine,
            submitting,
            valueInputType
        } =  this.props;
        return <form onSubmit={handleSubmit(myHandleSubmit)}>
            <div className={styles["fields"]}>
                <Field name="value" label="Value" id="secret_value" type={valueInputType} component={LabeledInput} hint={hint} />
            </div>
            {error && <div className={styles["error-wrap"]}>
                <div className={styles["error-message"]}>
                    <div>An error occurred while saving the data</div>
                    <div className={styles["error-small"]}>Network request status: {error}</div>
                </div>
            </div>}
            <ButtonBar>
                <button className={"primary"} type="submit" disabled={pristine || submitting}>
                    <span className="button-wrap">
                        <span className="button-text">Save</span>
                        {submitting && <ClassicSpinner wrapperStyle={{marginLeft: "5px"}} size={"1.5em"}/>}
                    </span>
                </button>
                <Link className="button" to={`/`}>Back</Link>
            </ButtonBar>
        </form>;
    }
}

SettingForm.defaultProps = {
};

export const SettingFormProps = {
    id: PropTypes.number.isRequired,
    authenticityToken: PropTypes.string.isRequired,
    description: PropTypes.string,
    hint: PropTypes.oneOfType([
        PropTypes.string,
        PropTypes.element
    ]),
    valueInputType: PropTypes.string.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    myHandleSubmit: PropTypes.func.isRequired,
    pristine: PropTypes.bool,
    submitting: PropTypes.bool,
    error: PropTypes.string,
    extraClassNames: PropTypes.object,
    submitText: PropTypes.string,
};

SettingForm.propTypes = SettingFormProps;
