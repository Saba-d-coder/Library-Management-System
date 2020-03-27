//include the required files
const mysql = require('mysql');
const dbConfig = require("../config/db.config.js");

//create a connections to the database
const conn = mysql.createConnection({
    host: dbConfig.HOST,
    user: dbConfig.USER,
    password: dbConfig.PASSWORD,
    database: dbConfig.DB
});

//connect to the database
conn.connect((err)=>{
    if(err) throw err;
    console.log('Successfully connected to the database..');
});

module.exports = conn;