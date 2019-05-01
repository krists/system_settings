import React, { Component } from 'react';

import styles from "./NotFoundPage.module.css"

export class NotFoundPage extends Component {
    render() {
        return (
            <div className={styles["container"]}>
                Page not found
            </div>
        );
    }
}

