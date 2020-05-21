//to handle all the operations on book db

const Book = require("../models/book.model.js");

exports.getAll = (req, res) => {
    Book.getAll((err, data) => {
        if(err) {
            res.send({msg: err.msg});
        }
        else {
            res.send(data);
        }
    });
};

exports.findByID = (req, res) => {
    Book.findByID(req.params.bid, (err, data) => {
        if(err) {
            res.send({msg: err.msg});
        }
        else {
            res.send(data);
        }
    });
};

exports.findByCode = (req, res) => {
    Book.findByCode(req.params.code, (err, data) => {
        if(err) {
            res.send({msg: err.msg});
        }
        else {
            res.send(data);
        }
    })
};

exports.updateNoOfBooks = (req, res) => {
    Book.updateNoOfBooks(req.params.bid, req.params.noOfBooks,
        new Book(req.body),
        (err, data) => {
            if(err) {
                res.send({msg: err.msg});
            }
            else {
                res.send(data);
            }
        });
};

exports.getRec = (req, res) => {
    Book.getRec(req.params.bid, (err, data) => {
        if(err) {
            res.send({msg: err.msg});
        }
        else {
            res.send(data);
        }
    });
};