import React from 'react'
import PropTypes from 'prop-types'
import styles from "./Value.module.scss"

export class Value extends React.Component {
    formattedValue(){
        let { type, value } = this.props;
        switch(type) {
            case "SystemSettings::StringListSetting":
            case "SystemSettings::IntegerListSetting":
                if(value){
                    return value.map((v, i) => <span key={i} className={styles["section"]}>{v}</span>)
                } else {
                    return null;
                }
            default:
                return <span className={styles["section"]}>{value}</span>;
        }
    }
    render(){
        return <span className={styles["wrap"]}>
            {this.formattedValue()}
        </span>
    }
}

export const ValueProps = {
    type: PropTypes.string.isRequired,
    value: PropTypes.any.isRequired
};

Value.propTypes = ValueProps;
