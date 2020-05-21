//include the db connection file
const sql = require("./db.js");

//constructor function
const IssuedTo = function(issuedto) {
    this.uid = issuedto.uid,
    this.bid = issuedto.bid,
    this.issuedDate = issuedto.issuedDate,
    this.dueDate = issuedto.dueDate,
    this.status = issuedto.status,
    this.fine = issuedto.fine,
    this.noOfRenews = issuedto.noOfRenews,
    this.totNoOfTimes = issuedto.totNoOfTimes,
    this.rating = issuedto.rating,
    this.reviews = issuedto.reviews
};

//to add a new issuance
IssuedTo.issue = (newIssue, result) => {
    sql.query("INSERT INTO issuedto SET ?", newIssue, (err, res)=> {
        if(err) {
            console.log("error: ",err);
            result(err, null);
            return;
        }
        console.log("Issued: ", {...newIssue});
        result(null, {...newIssue});
    });
};

//to update the issuance details(renewal)
IssuedTo.update = (uid, bid, issuedto, result) => {
    sql.query("UPDATE issuedto SET issuedDate = ?, dueDate = ?, status = ?, fine = ?, noOfRenews = ?, totNoOfTimes = ? WHERE uid = ? and bid = ?",
    [issuedto.issuedDate, issuedto.dueDate, issuedto.status, issuedto.fine, issuedto.noOfRenews, issuedto.totNoOfTimes, uid, bid],
    (err, res) => {
        if(err) {
            console.log("error: ", err);
            result(null, err);
            return;
        }
        if(res.affectedRows == 0) {
            result("not found", null);
            return;
        }
        console.log("Updated issued details: ", {...issuedto});
        result(null, {...issuedto});
    });
};

//to get all the books taken by the user up to date(history)
IssuedTo.getAllByUID = (uid,result) => {
    sql.query(`SELECT * FROM issuedTo WHERE uid = '${uid}' order by issuedDate desc`, (err, res) => {
        if(err) {
            console.log("error: ", err);
            result(null, err);
            return;
        }
        if(res.length) {
            console.log("found book: ", res);
            result(null, res);
            return;
        }
        result("not found", null);
    });
};

//to get if the book has been issued 
IssuedTo.getIfIssued = (uid,bid,result) => {
    sql.query(`SELECT * FROM issuedTo WHERE uid = '${uid}' and bid = ${bid}`, (err, res) => {
        if(err) {
            console.log("error: ", err);
            result(null, err);
            return;
        }
        if(res.length) {
            console.log("found book: ", res);
            result(null, res[0]);
            return;
        }
        result("not found", null);
    });
};

//to get all the reviews of a particular book
IssuedTo.getAllByBID = (bid, result) => {
    sql.query(`SELECT name, rating, reviews FROM user, issuedto WHERE bid = ${bid} and user.uid = issuedto.uid`, (err, res) => {
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

//to get rating of every book
IssuedTo.getRating = (result) => {
    sql.query("SELECT bid, ROUND(AVG(rating)) rating FROM issuedto group by bid", (err, res) => {
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

IssuedTo.updateRating = (uid, bid, issuedto, result) => {
    sql.query("UPDATE issuedto SET rating = ?, reviews = ? WHERE uid = ? and bid = ?",
    [issuedto.rating, issuedto.reviews, uid, bid],
    (err, res) => {
        if(err) {
            console.log("error: ", err);
            result(null, err);
            return;
        }
        if(res.affectedRows == 0) {
            result("not found", null);
            return;
        }
        console.log("updated successfully: ",{...issuedto});
        result(null);
    });
};

module.exports = IssuedTo;