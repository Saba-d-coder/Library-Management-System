//include the db connection file
const sql = require("./db.js");

//constructor function
const IssuedTo = function(issuedto) {
    this.uid = issuedto.uid,
    this.bid = issuedto.bid,
    this.issuedDate = issuedto.issuedDate,
    this.dueDate = issuedto.dueDate,
    this.noOfRenews = issuedto.noOfRenews,
    this.fine = issuedto.fine
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
IssuedTo.update = (uid, bid, issuedDate, dueDate, noOfRenews, issuedto, result) => {
    sql.query(`UPDATE issuedto SET issuedDate = '${issuedDate}', dueDate = '${dueDate}', noOfRenews = ${noOfRenews} WHERE uid = '${uid}' and bid = ${bid}`,
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

//to update fines based on user id and book id
IssuedTo.updateFine = (uid, bid, fine, issuedto, result) => {
    sql.query(`UPDATE issuedto SET fine = ${fine} WHERE uid = '${uid}' and bid = ${bid}`,
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
    sql.query(`SELECT * FROM issuedTo WHERE uid = '${uid}'`, (err, res) => {
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

//to get all the books currently taken by the user
IssuedTo.getCurIssByUID = (uid, result) => {
    sql.query(`SELECT user.uid, book.bid, issuedDate, dueDate, noOfRenews, fine
     FROM issuedto,book,user 
     WHERE issuedto.uid = user.uid
     AND issuedto.bid = book.bid AND
     status = 'Issued' AND
     issuedto.uid = '${uid}'`,
     (err, res) => {
         if(err) {
            console.log("Currently issued details: ", res);
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

module.exports = IssuedTo;