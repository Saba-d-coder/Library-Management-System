//include database connection file
const sql = require("./db.js");

//constructor function
const User = function(user) {
    this.uid = user.uid,
    this.name = user.name,
    this.emailID = user.emailID,
    this.phoneNo = user.phoneNo,
    this.password = user.password,
    this.noOfBooks = user.noOfBooks,
    this.wishlist = user.list
}

//to create a new user
User.create = (newUser, result) => {
    sql.query("INSERT INTO user SET ?", newUser, 
    (err,res) => {
        if(err) {
            console.log("error: ", err);
            result(err, null);
            return;
        }
        console.log("Created new user: ", {...newUser});
        result(null, {...newUser});
    });
};

//to get a user by id
User.findByID = (uid, result) => {
    sql.query(`SELECT * FROM user WHERE uid = '${uid}'`, 
    (err, res) => {
        if(err) {
            console.log("error: ", err);
            result(err, null);
            return;
        }
        if(res.length) {
            console.log("Found user: ", res[0]);
            result(null, res[0]);
            return;
        }
        result("not found", null);
    });
};

//to update user details
User.updateByID =(uid, user, result) => {
    sql.query("UPDATE user SET name = ?, emailID = ?, phoneNo = ?, password = ? WHERE uid = ?",
    [user.name, user.emailID, user.phoneNo, user.password, uid],
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
        console.log("updated user: ",{...user});
        result(null, {...user});
    });
};

//to update the no. of books taken by the user
User.updateNoOfBooks = (uid, noOfBooks, user, result) => {
    sql.query(`UPDATE user SET noOfBooks = ${noOfBooks} WHERE uid = '${uid}'`,
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
        console.log("updated noOfBooks taken by user: ",{...user});
        result(null, {...user});
    });
};

//to update the wishlist of the user
User.updateWishList = (uid, list, result) => {
    sql.query(`UPDATE user SET wishlist = '${list}' WHERE uid = '${uid}'`,
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
        console.log("updated wishlist: ",list);
        result(null);
    });
};

module.exports = User;