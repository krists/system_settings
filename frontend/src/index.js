import React from 'react';
import { render } from 'react-dom';
import { createStore } from 'redux'
import { createBrowserHistory } from 'history';
import { Provider } from 'react-redux';
import reducers from './reducers';
import App from './components/App';
import './index.scss';
import "./progress_bar"

const store = createStore(reducers);

const rootEl = document.getElementById('root');
if(!window.__SYSTEM_SETTINGS_BASENAME__){
    window.__SYSTEM_SETTINGS_BASENAME__ = process.env.PUBLIC_URL || "/system_settings";
}

const history = createBrowserHistory({
    basename: window.__SYSTEM_SETTINGS_BASENAME__
});

history.listen((location, action) => {
    console.log(
        `The current URL is ${location.pathname}${location.search}${location.hash}`
    );
    console.log(`The last navigation action was ${action}`);
});


render((
    <Provider store={store}>
        <App history={history}/>
    </Provider>
), rootEl);