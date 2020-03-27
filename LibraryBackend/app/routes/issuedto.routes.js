module.exports = app => {
    const issuedto = require("../controllers/issuedto.controller.js");

    //to add a new issuance details into the db
    app.post("/issuedto", issuedto.issue);
    
    //to update the issuance details(when renewed)
    app.put("/issuedto/:uid", issuedto.update);

    //to update the fine
    app.put("/issuedto/:uid/bid/:bid/fine/:fine", issuedto.updateFine);

    //to get the history of all the books taken by the user
    app.get("/issuedto/:uid", issuedto.getAllByUID);

    //to get the currently issued books by the user
    app.get("/issuedto/currently/:uid", issuedto.getCurIssByUID);
};