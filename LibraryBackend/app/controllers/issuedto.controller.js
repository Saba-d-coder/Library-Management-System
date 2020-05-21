//to handle all the operations on issuedto db

const IssuedTo = require("../models/issuedto.model.js");

exports.issue = (req, res) => {
    const issuedto = new IssuedTo({
        uid: req.body.uid,
        bid: req.body.bid,
        issuedDate: req.body.issuedDate,
        dueDate: req.body.dueDate,
        status: req.body.status,
        fine: req.body.fine,
        noOfRenews: req.body.noOfRenews,
        totNoOfTimes: req.body.totNoOfTimes,
        rating: req.body.rating,
        reviews: req.body.reviews
    });

    IssuedTo.issue(issuedto, (err, data) => {
        if(err) {
            res.send({msg: err.msg});
        }
        else {
            res.send(data);
        }
    })
};

exports.update = (req, res) => {
    IssuedTo.update(req.params.uid, req.body.bid,
        new IssuedTo(req.body),
        (err, data) => {
            if(err) {
                res.send({msg: err.msg});
            }
            else {
                res.send(data);
            }
        });
};

exports.getAllByUID = (req, res) => {
    IssuedTo.getAllByUID(req.params.uid,(err, data) => {
        if(err) {
            res.send({msg: err.msg});
        }
        else {
            res.send(data);
        }
    });
};

exports.getIfIssued = (req, res) => {
    IssuedTo.getIfIssued(req.params.uid, req.params.bid, (err, data) => {
        if(err) {
            res.send({msg: err.msg});
        }
        else {
            res.send(data);
        }
    });
};

exports.getAllByBID = (req, res) => {
    IssuedTo.getAllByBID(req.params.bid, (err, data) => {
        if(err) {
            res.send({msg: err.msg});
        }
        else {
            res.send(data);
        }
    });
};

exports.getRating = (req, res) => {
    IssuedTo.getRating((err, data) => {
        if(err) {
            res.send({msg: err.msg});
        }
        else {
            res.send(data);
        }
    });
};

exports.updateRating = (req, res) => {
    IssuedTo.updateRating(req.params.uid, req.params.bid,
        new IssuedTo(req.body),
        (err, data) => {
            if(err) {
                res.send({msg: err.msg});
            }
            else {
                res.send(data);
            }
        });
};