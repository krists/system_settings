import React, {Component} from 'react';
import PropTypes from 'prop-types'
import {Router, Route, Switch, Link, Redirect} from "react-router-dom";
import {generatePath} from "react-router"
import styles from "./App.module.css"
import {NotFoundPage} from "./NotFoundPage";
import {ConnectedListPage as ListPage} from "../containers/ConnectedListPage";
import {ConnectedViewPage as ViewPage} from "../containers/ConnectedViewPage";
import {ConnectedEditPage as EditPage} from "../containers/ConnectedEditPage";
import {ROOT_PATH, LIST_PATH, SETTING_PATH, EDIT_SETTING_PATH} from "../routes/frontend";
class App extends Component {
    render() {
        return (
            <Router history={this.props.history}>
                <div className={styles["container"]}>
                    <div className={styles["header-wrap"]}>
                        <div className={styles["header"]}>
                            <Link to={ROOT_PATH} className={styles["header-name"]}>{this.props.name}</Link>
                        </div>
                    </div>
                    <div className={styles["header-spacer"]}/>
                    <div className={styles["content-wrap"]}>
                        <div className={styles["content"]}>
                            <Switch>
                                <Route exact path={ROOT_PATH}>
                                    <Redirect to={generatePath(LIST_PATH, {page: 1})} />
                                </Route>
                                <Route path={LIST_PATH} component={ListPage}/>
                                <Route path={EDIT_SETTING_PATH} component={EditPage}/>
                                <Route path={SETTING_PATH} component={ViewPage}/>
                                <Route component={NotFoundPage}/>
                            </Switch>
                        </div>
                    </div>
                </div>
            </Router>
        );
    }
}

App.defaultProps = {
    name: "System Settings"
};

App.propTypes = {
    name: PropTypes.string.isRequired,
    history: PropTypes.object.isRequired
};

export default App;
