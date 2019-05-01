import URL from "url-parse";

import { join } from "path";

function getBase(){
    return window.__SYSTEM_SETTINGS_BASENAME__;
}

export function apiPath(path) {
    let parsedBase = new URL(getBase());
    let nextPathname = join(parsedBase.pathname, 'api', path);
    parsedBase.set('pathname', nextPathname);
    return parsedBase.href;
}
