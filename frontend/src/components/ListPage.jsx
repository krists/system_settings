import React, { Component } from 'react';
import PropTypes from 'prop-types'
import { Link } from "react-router-dom";
import styles from "./ListPage.module.scss"
import paginationStyles from "./Pagination.module.scss"
import { PageLoadError } from "./PageLoadError";
import { start as progressBarStart, done as progressBarDone } from "../progress_bar"
import {Value} from "./Value";
import Pagination from "react-js-pagination";

import { generatePath } from "react-router"

const PER_PAGE = 25;
const PAGE_RANGE_DISPLAYED = 5;

class ListPage extends Component {

    componentDidMount() {
        this.initFetch()
    }

    initFetch(){
        this.props.fetch(this.activePage(), PER_PAGE);
        progressBarStart()
    }

    activePage(){
        return parseInt(this.props.match.params["page"]);
    }

    componentDidUpdate(prevProps, prevState, snapshot) {
        if(this.props.location !== prevProps.location){
            this.initFetch()
        }
        if(!this.props.fetching && prevProps.fetching){
            progressBarDone()
        }
    }

    columnCount = 4;

    handlePageChange(page){
        let nextPath = generatePath(this.props.match.path, {page});
        this.props.history.push(nextPath);
    }

    pagination(){
        let { itemsCount } = this.props;
        if(itemsCount <= PER_PAGE) { return; }
        return <Pagination
            key="pagination"
            innerClass={paginationStyles["pagination"]}
            itemClass={paginationStyles["item"]}
            disabledClass={paginationStyles["item--disabled"]}
            activeClass={paginationStyles["item--active"]}
            linkClass={paginationStyles["link"]}
            hideFirstLastPages={true}
            activePage={this.activePage()}
            itemsCountPerPage={PER_PAGE}
            totalItemsCount={itemsCount}
            pageRangeDisplayed={PAGE_RANGE_DISPLAYED}
            onChange={this.handlePageChange.bind(this)}
        />
    }

    render() {
        let { fetching, fetchSuccessful, fetchErrorMessage, items } = this.props;
        if(fetching){
            return null;
        } else if (fetchSuccessful) {
            return [<table key="table" className={styles["table"]}>
                <thead>
                <tr>
                    <th className={styles["name"]}>Name</th>
                    <th className={styles["description"]}>Description</th>
                    <th className={styles["value"]}>Value</th>
                    <th className={styles["actions"]}/>
                </tr>
                </thead>
                <tbody>
                {items.length === 0 && <tr className={styles["empty-tr"]}><td colSpan={this.columnCount}>No settings</td></tr>}
                {items.length > 0 && items.map((attrs) => {
                    return <tr key={attrs.id}>
                        <td className={styles["name"]}><Link className="sysname" to={`/settings/${attrs.id}`}>{attrs.name}</Link></td>
                        <td className={styles["description"]}>{attrs.description}</td>
                        <td className={styles["value"]}><Value type={attrs.type} value={attrs.value}/></td>
                        <td className={styles["actions"]}><Link className={styles["primary-action"]} to={`/settings/${attrs.id}/edit`}>Edit</Link></td>
                    </tr>
                })}
                </tbody>
            </table>, this.pagination()]
        } else {
            return <PageLoadError description={fetchErrorMessage} />
        }
    }
}

export default ListPage;

ListPage.propTypes = {
    page: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
    fetch: PropTypes.func.isRequired,
    fetching: PropTypes.bool.isRequired,
    fetchSuccessful: PropTypes.bool,
    fetchErrorMessage: PropTypes.string,
    itemsCount: PropTypes.number.isRequired,
    items: PropTypes.arrayOf(PropTypes.shape({
        id: PropTypes.number.isRequired,
        type: PropTypes.string.isRequired,
        name: PropTypes.string.isRequired,
        description: PropTypes.string,
    }))
};