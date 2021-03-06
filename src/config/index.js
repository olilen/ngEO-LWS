let process = require('process');

class Configuration {
	constructor() {
		// FIXME : just only in dev mode
		//if this is not set then targeting some feed catalog doesnot work because rejected
		process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";
		console.log(`NODE_ENV: ${process.env.NODE_ENV}`);
		switch (process.env.NODE_ENV) {
			case 'development':
				Object.assign(this, require('./development'));
				break;
			case 'test':
				Object.assign(this, require('./test'));
				break;
			case 'production':
				Object.assign(this, require('./production'));
				break;
			default:
				console.error(`Unrecognized NODE_ENV: ${process.env.NODE_ENV} using development configuration by default`);
				Object.assign(this, require('./development.json'));
		}
		// commons.json configuration files
		Object.assign(this, require('./commons'));
	}
}

module.exports = new Configuration();