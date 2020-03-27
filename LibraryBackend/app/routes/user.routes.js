module.exports = app => {
    const users = require("../controllers/user.controller.js");

    //to register a new user
    app.post("/users", users.create);

    //to get the details of an existing user
    app.get("/users/:uid", users.findByID);

    //to update the details of an existing user
    app.put("/users/:uid", users.updateByID);

    //to update the no. of books taken by the user
    app.put("/users/:uid/noOfBooks/:noOfBooks", users.updateNoOfBooks);
};