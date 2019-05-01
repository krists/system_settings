import React, { Component } from 'react';
import PropTypes from 'prop-types'
import { BrowserRouter as Router, Route, Switch, Link } from "react-router-dom";

import styles from "./App.module.css"

import { NotFoundPage } from "./NotFoundPage";
import { ConnectedListPage as ListPage } from "../containers/ConnectedListPage";
import { ConnectedViewPage as ViewPage } from "../containers/ConnectedViewPage";
import { ConnectedEditPage as EditPage } from "../containers/ConnectedEditPage";

class App extends Component {
  render() {
    let basename = window.__SYSTEM_SETTINGS_BASENAME__;

    return (
        <Router basename={basename}>
      <div className={styles["container"]}>
          <div className={styles["header-wrap"]}>
              <div className={styles["header"]}>
                  <Link to={"/"} className={styles["header-name"]}>{this.props.name}</Link>
              </div>
          </div>
          <div className={styles["header-spacer"]}/>
          <div className={styles["content-wrap"]}>
              <div className={styles["content"]}>

                      <Switch>
                          <Route exact path="/" component={ListPage} />
                          <Route path="/settings/:id/edit" component={EditPage} />
                          <Route path="/settings/:id" component={ViewPage} />
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
    name: PropTypes.string.isRequired
};

export default App;
