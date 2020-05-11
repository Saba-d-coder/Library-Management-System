//include db connection file
const sql = require("./db.js");

//constructor function
const Book = function(book) {
    this.bid = book.bid;
    this.bname = book.bname,
    this.author = book.author,
    this.publisher = book.publisher,
    this.code = book.code,
    this.shelfNo = book.shelfNo,
    this.status = book.status,
    this.noOfBooks = book.noOfBooks,
    this.description = book.description
};

//to retrieve all the books
Book.getAll = result => {
    sql.query("SELECT * FROM book", (err, res) => {
        if(err) {
            console.log("error: ",err);
            result(null, err);
            return;
        }
        console.log("books: ", res);
        result(null, res);
    });
};

//to retrieve a particular book based on its id
Book.findByID = (bid, result) => {
    sql.query(`SELECT * FROM book WHERE bid = ${bid}`, (err, res) => {
        if(err) {
            console.log("error: ", err);
            result(err, null);
            return;
        }
        if(res.length) {
            console.log("found book: ", res[0]);
            result(null, res[0]);
            return;
        }
        result("not found", null);
    });
};

//to retrieve a particular book based on its code
Book.findByCode = (code, result) => {
    sql.query(`SELECT * FROM book WHERE code = ${code}`, (err, res) => {
        if(err) {
            console.log("error: ", err);
            result(err, null);
            return;
        }
        if(res.length) {
            console.log("found book: ", res[0]);
            result(null, res[0]);
            return;
        }
        result("not found", null);
    });
};

//to update a book's status- available, issued etc
Book.updateStatusById = (bid, status, shelfNo, book, result) => {
    sql.query(`UPDATE book SET status = '${status}', shelfNo='${shelfNo}' WHERE bid = ${bid}`, 
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
        console.log("updated book status: ", {...book});
        result(null, {...book});
    });
};

//to get recommended books
Book.getRec = (bid, result) => {
    sql.query("SELECT * FROM book", (err, res) => {
        if(err) {
            console.log("error: ",err);
            result(null, err);
            return;
        }
        if(res.length) {
            console.log("Reviews: ", res);
            var spawn = require('child_process').spawn,
            py    = spawn('python', ['app/recommender.py', bid]),
            data = res,
            dataString = '';
            py.stdout.on('data', function(data){
                dataString += data.toString();
            });
            py.stdout.on('end', function(){
                result(null, dataString);
            });
            py.stdin.write(JSON.stringify(data));
            py.stdin.end();
            
            return;
        }
        result("not found", null);
    });
};

module.exports = Book;