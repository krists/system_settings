import React from 'react';
import styles from "./ButtonBar.module.scss";

export class ButtonBar extends React.Component {
    render(){
        let { children } = this.props;
        return <div className={styles["container"]}>{children}</div>
    }
}
