module.exports = app => {
    const books = require("../controllers/book.controller.js");
    
    //to get all the books
    app.get("/books", books.getAll);

    //to get a book based on its id
    app.get("/books/:bid", books.findByID);

    //to get a book based on its code
    app.get("/books/code/:code", books.findByCode);

    //to update the status and shelfNo of the book based on its id
    app.put("/books/:bid/status/:status/shelfNo/:shelfNo", books.updateStatusByID);
    
    //to get book recommendation
    app.get("/books/rec/:bid", books.getRec);
};