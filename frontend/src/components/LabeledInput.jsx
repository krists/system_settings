import React from 'react'
import PropTypes from 'prop-types'
import { fieldPropTypes } from "redux-form"
import styles from "./LabeledInput.module.scss"

export class LabeledInput extends React.Component {
    render(){
        let {id, type, label, hint, placeholder, input, meta: { touched, error } } = this.props;
        let errorMessage = Array.isArray(error) ? error.join("; ") : error;

        return <div className={styles["wrap"]}>
            <label className={styles["label"]} htmlFor={id}>{label}</label>
            <div className={styles["input-and-error-wrap"]}>
                <input id={id} type={type} placeholder={placeholder} {...input} className={styles["input"]} style={{width: `${input.value.length}ch`}} />
                {touched && errorMessage && <span className={styles["error"]}>{errorMessage}</span>}
            </div>
            {hint && <div className={styles["hint"]}>{hint}</div>}
        </div>
    }
}

LabeledInput.defaultProps = {
  type: "text"
};

export const LabeledInputProps = {
    ...fieldPropTypes,
    id: PropTypes.string.isRequired,
    type: PropTypes.string.isRequired,
    label: PropTypes.string.isRequired,
    hint: PropTypes.oneOfType([
        PropTypes.string,
        PropTypes.element
    ]),
    placeholder: PropTypes.string,
};

LabeledInput.propTypes = LabeledInputProps;
