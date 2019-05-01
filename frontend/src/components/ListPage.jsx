import React, { Component } from 'react';
import PropTypes from 'prop-types'
import {formatValue} from "../utils/secrets";
import { Link } from "react-router-dom";
import styles from "./ListPage.module.scss"
import { PageLoadError } from "./PageLoadError";
import { start as progressBarStart, done as progressBarDone } from "../progress_bar"

class ListPage extends Component {

    componentDidMount() {
        this.props.fetch(1);
        progressBarStart()
    }

    componentDidUpdate(prevProps, prevState, snapshot) {
        if(!this.props.fetching && prevProps.fetching){
            progressBarDone()
        }
    }

    columnCount = 4;

    render() {
        let { fetching, fetchSuccessful, fetchErrorMessage, list } = this.props;
        if(fetching){
            return null;
        } else if (fetchSuccessful) {
            return <table className={styles["table"]}>
                <thead>
                <tr>
                    <th className={styles["name"]}>Name</th>
                    <th className={styles["description"]}>Description</th>
                    <th className={styles["value"]}>Value</th>
                    <th className={styles["actions"]}/>
                </tr>
                </thead>
                <tbody>
                {list.length === 0 && <tr className={styles["empty-tr"]}><td colSpan={this.columnCount}>No settings</td></tr>}
                {list.length > 0 && list.map((attrs) => {
                    return <tr key={attrs.id}>
                        <td className={styles["name"]}><Link className="sysname" to={`/settings/${attrs.id}`}>{attrs.name}</Link></td>
                        <td className={styles["description"]}>{attrs.description}</td>
                        <td className={styles["value"]}>{formatValue(attrs.type, attrs.value)}</td>
                        <td className={styles["actions"]}><Link className={styles["primary-action"]} to={`/settings/${attrs.id}/edit`}>Edit</Link></td>
                    </tr>
                })}
                </tbody>
            </table>
        } else {
            return <PageLoadError description={fetchErrorMessage} />
        }
    }
}

export default ListPage;

ListPage.propTypes = {
    page: PropTypes.number.isRequired,
    fetch: PropTypes.func.isRequired,
    fetching: PropTypes.bool.isRequired,
    fetchSuccessful: PropTypes.bool,
    fetchErrorMessage: PropTypes.string,
    list: PropTypes.arrayOf(PropTypes.shape({
        id: PropTypes.number.isRequired,
        type: PropTypes.string.isRequired,
        name: PropTypes.string.isRequired,
        description: PropTypes.string,
    }))
};