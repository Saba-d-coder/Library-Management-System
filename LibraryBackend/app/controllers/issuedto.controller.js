//to handle all the operations on issuedto db

const IssuedTo = require("../models/issuedto.model.js");

exports.issue = (req, res) => {
    const issuedto = new IssuedTo({
        uid: req.body.uid,
        bid: req.body.bid,
        issuedDate: req.body.issuedDate,
        dueDate: req.body.dueDate,
        noOfRenews: req.body.noOfRenews,
        fine: req.body.fine
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
    IssuedTo.update(req.params.uid, req.body.bid, req.body.issuedDate, req.body.dueDate, req.body.noOfRenews,
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

exports.updateFine = (req, res) => {
    IssuedTo.updateFine(req.params.uid, req.params.bid, req.params.fine,
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

exports.getCurIssByUID = (req, res) => {
    IssuedTo.getCurIssByUID(req.params.uid, (err, data) => {
        if(err) {
            res.send({msg: err.msg});
        }
        else {
            res.send(data);
        }
    });
};