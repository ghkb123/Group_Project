app.post('/compliance/ask_user', function (request, response) {
console.log("request ask user", request.body.sender);
var sender = JSON.parse(request.body.sender)
console.log("sender", sender);


client.query('SELECT * from sanction where domain = $1', [sender.domain], (error, results) => {
if (error) {
console.log("ask user error message", error);
response.status(403).end("FI not sanctioned");
}
if (results) {
console.log("ask user query result", query);
if (results.rows[0].kyc == true) {
response.status(200).end();
}
else {
response.status(403).end("KYC request denied");
}
}
console.log("ask user request -- the end");
})
});