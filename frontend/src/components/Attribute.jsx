import React, { PureComponent } from 'react';
import PropTypes from 'prop-types'
import styles from './Attribute.module.scss';

export class Attribute extends PureComponent {
    render() {
        let {name, children} = this.props;
        return <div className={styles["wrap"]}>
            <div className={styles["name"]}>{name}</div>
            <div className={styles["value"]}>{children}</div>
        </div>
    }
}

export const AttributeProps = {
    name: PropTypes.string.isRequired,
    value: PropTypes.any
};

Attribute.propTypes = AttributeProps;