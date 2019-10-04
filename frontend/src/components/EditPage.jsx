import React, { Component } from 'react';
import PropTypes from 'prop-types'
import SettingForm from "../containers/ConnectedSettingForm"
import {Attribute} from "./Attribute";
import {humanReadableType} from "../utils/secrets";
import { start as progressBarStart, done as progressBarDone } from "../progress_bar";
import { PageLoadError } from "./PageLoadError";
import {ROOT_PATH} from "../routes/frontend";

export class EditPage extends Component {

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

    hint(type){
        switch (type) {
            case "SystemSettings::StringListSetting":
            case "SystemSettings::IntegerListSetting":
                return <>Separate values by <code>;</code> character.</>;
            default:
                return null
        }
    }

    valueInputType(type){
        switch (type) {
            case "SystemSettings::BooleanSetting":
                return "checkbox";
            default:
                return "text";
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
        let { fetching, fetchSuccessful, fetchErrorMessage, authenticityToken, attributes: {id, name, description, type} } = this.props;
        if(fetching){
            return null;
        } else if (fetchSuccessful) {
            return <div>
                <Attribute name="Name"><span className="sysname">{name}</span></Attribute>
                <Attribute name="Type">{humanReadableType(type)}</Attribute>
                <Attribute name="Description">{description}</Attribute>
                <SettingForm id={id} authenticityToken={authenticityToken} hint={this.hint(type)} valueInputType={this.valueInputType(type)} backFn={this.goBack} />
            </div>
        } else {
            return <PageLoadError description={fetchErrorMessage} />
        }
    }
}

EditPage.propTypes = {
    match: PropTypes.object.isRequired,
    attributes: PropTypes.shape({
        id: PropTypes.number,
        type: PropTypes.string,
        name: PropTypes.string,
        description: PropTypes.string
    }),
    authenticityToken: PropTypes.string,
    fetch: PropTypes.func.isRequired,
    fetching: PropTypes.bool.isRequired,
    fetchSuccessful: PropTypes.bool,
    fetchErrorMessage: PropTypes.string,
};