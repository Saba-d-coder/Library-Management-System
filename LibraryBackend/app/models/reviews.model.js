//include db connection file
const sql = require("./db.js");

//constructor function
const Reviews = function(review) {
    this.uid = review.uid,
    this.bid = review.bid,
    this.rating = review.rating,
    this.reviews = review.reviews
};

//to get all the reviews of a particular book
Reviews.getAllByBID = (bid, result) => {
    sql.query(`SELECT name, rating, reviews FROM user, reviews WHERE bid = ${bid} and user.uid = reviews.uid`, (err, res) => {
        if(err) {
            console.log("error: ",err);
            result(null, err);
            return;
        }
        if(res.length) {
            console.log("Reviews: ", res);
            result(null, res);
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

//to get rating of every book
Reviews.getRating = (result) => {
    sql.query("SELECT bid, ROUND(AVG(rating)) rating FROM reviews group by bid", (err, res) => {
        if(err) {
            console.log("error: ",err);
            result(null, err);
            return;
        }
        if(res.length) {
            console.log("Reviews: ", res);
            result(null, res);
            return;
        }
    });
};

module.exports = Reviews;