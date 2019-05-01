import { combineReducers } from 'redux';
import { reducer as form } from 'redux-form'
import list from './list'
import setting from './setting'

export default combineReducers({
    list,
    setting,
    form
});
