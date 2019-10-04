import React, { Component } from 'react';
import PropTypes from 'prop-types'
import {humanReadableType} from "../utils/secrets";
import {Attribute} from "./Attribute";
import {Link} from "react-router-dom";
import { PageLoadError } from "./PageLoadError";
import styles from "./ViewPage.module.scss"
import { ButtonBar } from "./ButtonBar";
import { start as progressBarStart, done as progressBarDone } from "../progress_bar";
import {Value} from "./Value";
import {ROOT_PATH} from "../routes/frontend";

export class ViewPage extends Component {

    constructor(props){
        super(props);
        this.goBack = this.goBack.bind(this);
    }

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

    goBack(){
        let { history } = this.props;
        if(history.action === "POP") {
            history.push(ROOT_PATH);
        } else {
            history.goBack();
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
                <Attribute name="Value"><Value type={type} value={value}/></Attribute>
                <ButtonBar>
                    <Link className="button primary" to={`/settings/${id}/edit`}>Edit</Link>
                    <button className="link" onClick={this.goBack}>Back</button>
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