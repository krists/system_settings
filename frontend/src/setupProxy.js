const proxy = require('http-proxy-middleware');

const port = parseInt(process.env.PORT || 3000);
const portStep = parseInt(process.env.OVERMIND_PORT_STEP || 10);

module.exports = function(app) {
    app.use(proxy('/system_settings/api', { target: `http://localhost:${port + portStep}/` }));
};
