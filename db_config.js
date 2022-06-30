const Promise = require('bluebird');
const pgp = require('pg-promise')({promiseLib: Promise});

if (!global.db) {
	const PGDB_HOST = process.env.PGDB_HOST || "localhost";
	const PGDB_PORT = process.env.PGDB_PORT || "5432";
	const PGDB_USER = process.env.PGDB_USER || "ali_agmr";
	const PGDB_PASSWORD = process.env.PGDB_PASSWORD || "PPpp@@88";
	const PGDB_DATABASE = process.env.PGDB_DATABASE || "Torob";
	const db = pgp({host: PGDB_HOST, port: PGDB_PORT, user: PGDB_USER, password: PGDB_PASSWORD, database: PGDB_DATABASE, ssl: false, poolSize: 200});
	global.db = db;
	process.once("SIGTERM", function (sig) {
		db.disconnect();
	});
}

module.exports = {db: global.db};
