import React from 'react';
import styles from "./PageLoadError.module.scss";
import PropTypes from 'prop-types'

export class PageLoadError extends React.Component {

    render(){
        let { description } = this.props;
        return <div className={styles["wrap"]}>
            <div className={styles["container"]}>
                <div className={styles["error-large"]}>An error occurred while loading the page</div>
                <div className={styles["error-small"]}>{description}</div>
            </div>
        </div>
    }
}

PageLoadError.propTypes = {
    description: PropTypes.string.isRequired
};