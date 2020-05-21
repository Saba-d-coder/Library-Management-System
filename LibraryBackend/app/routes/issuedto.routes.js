module.exports = app => {
    const issuedto = require("../controllers/issuedto.controller.js");

    //to add a new issuance details into the db
    app.post("/issuedto", issuedto.issue);
    
    //to update the issuance details(when renewed)
    app.put("/issuedto/uid/:uid/bid/:bid", issuedto.update);

    //to get the history of all the books taken by the user
    app.get("/issuedto/:uid", issuedto.getAllByUID);

    //to get if the book has been issued
    app.get("/issuedto/uid/:uid/bid/:bid", issuedto.getIfIssued);

    //to get all the reviews of a particular book
    app.get("/reviews/:bid", issuedto.getAllByBID);

    //to get book ratings
    app.get("/ratings", issuedto.getRating);

    //to update rating and reviews
    app.put("/reviews/uid/:uid/bid/:bid", issuedto.updateRating);
};