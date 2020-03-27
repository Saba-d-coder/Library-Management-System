//inclusion of different files
const express = require('express');
const bodyParser = require('body-parser');
const ip = require('ip');
const app = express();
const hostname = ip.address();
const port = 3000;

app.use(bodyParser.json());

app.use((req,res,next)=>{
  res.setHeader("Access-Control-Allow-Origin","*")
  res.setHeader("Access-Control-Allow-Methods","GET,POST,PUT,DELETE")
  res.setHeader("Access-Control-Allow-Headers","x-Requested-With, Content-Type")
  res.setHeader("Access-Control-Allow-Credentials",true)
  next()
});

require("./app/routes/book.routes.js")(app);
require("./app/routes/user.routes.js")(app);
require("./app/routes/issuedto.routes.js")(app);
require("./app/routes/reviews.routes.js")(app);

app.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});