//include db connection file
const sql = require("./db.js");
const rev = require("../review.js");

//constructor function
const Reviews = function(review) {
    this.uid = review.uid,
    this.bid = review.bid,
    this.rating = review.rating,
    this.reviews = review.reviews
};

//to get all the reviews of a particular book
Reviews.getAllByBID = (bid, result) => {
    sql.query(`SELECT * FROM reviews WHERE bid = ${bid}`, (err, res) => {
        if(err) {
            console.log("error: ",err);
            result(null, err);
            return;
        }
        if(res.length) {
            console.log("Reviews: ", res);
            result(null, res);
            console.log(rev.data.getReview(res));
            return;
        }
        result("not found", null);
    });
};

//to add a review
Reviews.add = (review) => {
    sql.query("INSERT INTO reviews SET ?", review, (err, res) => {
        if(err) {
            console.log("error: ", err);
            result(err, null);
            return;
        }
        console.log("added review: ", {...review});
    });
};

module.exports = Reviews;