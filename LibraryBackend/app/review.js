var methods = {};
methods.getReview = function(dat) {
    var spawn = require('child_process').spawn,
    py    = spawn('python', ['app/review.py']),
    data = dat,
    dataString = '';
    console.log(data);
    py.stdout.on('data', function(data){
        dataString += data.toString();
    });
    py.stdout.on('end', function(){
        console.log('Sum of numbers=',dataString);
    });
    py.stdin.write(JSON.stringify(data));
    py.stdin.end();
    console.log(dataString);
    return dataString;
}

exports.data = methods;