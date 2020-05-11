module.exports = app => {
    const review = require("../controllers/reviews.controller.js");

    //to get all the reviews of a particular book
    app.get("/reviews/:bid", review.getAllByBID);

    //to add a book review
    app.post("/reviews", review.add);

    //to get book ratings
    app.get("/ratings", review.getRating);

}