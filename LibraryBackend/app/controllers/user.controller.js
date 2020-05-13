//to handle all the operations on user db

const User = require("../models/user.model.js");

exports.create = (req, res) => {
    const user = new User({
        uid: req.body.uid,
        name: req.body.name,
        emailID: req.body.emailID,
        phoneNo: req.body.phoneNo,
        password: req.body.password,
        noOfBooks: req.body.noOfBooks
    });

    User.create(user, (err, data) => {
        if(err) {
            res.send({msg: err.msg});
        }
        else {
            res.send(data);
        }
    });
};

exports.findByID = (req, res) => {
    User.findByID(req.params.uid, (err, data) => {
        if(err) {
            res.send({msg: err.msg});
        }
        else {
            res.send(data);
        }
    });
};

exports.updateByID = (req, res) => {
    User.updateByID(req.params.uid, new User(req.body), (err, data) => {
        if(err) {
            res.send({msg: err.msg});
        }
        else {
            res.send(data);
        }
    });
};

exports.updateNoOfBooks = (req, res) => {
    User.updateNoOfBooks(req.params.uid, req.params.noOfBooks,
        new User(req.body),
        (err, data) => {
            if(err) {
                res.send({msg: err.msg});
            }
            else {
                res.send(data);
            }
        });
};

exports.updateWishList = (req, res) => {
    User.updateWishList(req.params.uid, req.params.list,
        (err, data) => {
            if(err) {
                res.send({msg: err.msg});
            }
            else {
                res.send(data);
            }
        });
};