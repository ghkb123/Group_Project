app.post('/compliance/ask_user', function (request, response) {
console.log("request",request.body.sender);
var sender = JSON.parse(request.body.sender)
console.log("sender",sender);


client.query('SELECT * from sanction where domain = $1', [sender.domain], (error, results) => {
if (error) {
response.status(403).end("FI not sanctioned");
}
if (results)
{

if(results.rows[0].kyc == true)
{
response.status(200).end();
}
else
{
response.status(403).end("KYC request denied");
}
}
})
});