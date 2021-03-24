const Pool = require('pg').Pool;

const pool = new Pool({
  user: "postgres",
  password: "huuanh",
  host: "localhost",
  port: 5432,
  database: "sysdb"
});

module.exports = pool;