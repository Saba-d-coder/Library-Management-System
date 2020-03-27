//to handle all the operations on reviews db

const Reviews = require("../models/reviews.model.js");

exports.getAllByBID = (req, res) => {
    Reviews.getAllByBID(req.params.bid, (err, data) => {
        if(err) {
            res.send({msg: err.msg});
        }
        else {
            res.send(data);
        }
    });
};

exports.add = (req, res) => {
    const review = new Reviews({
        uid: req.body.uid,
        bid: req.body.bid,
        rating: req.body.rating,
        reviews: req.body.reviews
    });

    Reviews.add(review, (err, data) => {
        if(err) {
            res.send({msg: err.msg});
        }
        else {
            res.send(data);
        }
    });
};