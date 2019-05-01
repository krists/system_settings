import React, { Component } from 'react';
import PropTypes from 'prop-types'
import {formatValue, humanReadableType} from "../utils/secrets";
import {Attribute} from "./Attribute";
import {Link} from "react-router-dom";
import { PageLoadError } from "./PageLoadError";
import styles from "./ViewPage.module.scss"
import { ButtonBar } from "./ButtonBar";
import { start as progressBarStart, done as progressBarDone } from "../progress_bar";

export class ViewPage extends Component {

    componentDidMount() {
        let { id } = this.props.match.params;
        progressBarStart();
        this.props.fetch(id);
    }

    componentDidUpdate(prevProps, prevState, snapshot) {
        if(!this.props.fetching && prevProps.fetching){
            progressBarDone()
        }
    }

    render() {
        let { fetching, fetchSuccessful, fetchErrorMessage, attributes: {id, name, type, description, value} } = this.props;
        if(fetching){
            return null;
        } else if (fetchSuccessful) {
            return <div className={styles["wrap"]}>
                <Attribute name="Name"><span className="sysname">{name}</span></Attribute>
                <Attribute name="Type" children={humanReadableType(type)}/>
                <Attribute name="Description" children={description}/>
                <Attribute name="Value" children={formatValue(type, value)}/>
                <ButtonBar>
                    <Link className="button primary" to={`/settings/${id}/edit`}>Edit</Link>
                    <Link className="button" to={`/`}>Back</Link>
                </ButtonBar>
            </div>
        } else {
            return <PageLoadError description={fetchErrorMessage} />
        }
    }
}

ViewPage.propTypes = {
    match: PropTypes.object.isRequired,
    attributes: PropTypes.shape({
        id: PropTypes.number,
        type: PropTypes.string,
        name: PropTypes.string,
        value: PropTypes.any,
        description: PropTypes.string
    }),
    fetch: PropTypes.func.isRequired,
    fetching: PropTypes.bool.isRequired,
    fetchSuccessful: PropTypes.bool,
    fetchErrorMessage: PropTypes.string,
};