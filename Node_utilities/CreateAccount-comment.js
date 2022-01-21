
const StellarSdk = require('stellar-sdk');


// a new instance of the stellar-sdk that points to local Horizon instance
const server = new StellarSdk.Server('http://127.0.0.1:8000', { allowHttp: true });
const passphrase = 'Standalone Network ; February 2017'


// the root account that all the lumens are credited to when a new Stellar network is created
const MasterKey = StellarSdk.Keypair.master(passphrase)
const MasterSecret = MasterKey.secret();
const MasterPublicKey = MasterKey.publicKey();
console.log('Master Account', MasterSecret, MasterPublicKey);


// generate 3e random ed25519 key pairs that will act as our accounts: 
// - 1st account: to issue the USD asset; 
// - 2nd account: for Bank A 
// - 3rd account: for Bank B 

/*
const pair1 = StellarSdk.Keypair.random(passphrase);
const pair2 = StellarSdk.Keypair.random(passphrase);
const pair3 = StellarSdk.Keypair.random(passphrase);
*/
const pair1 = StellarSdk.Keypair.fromSecret('SAEEE4UUP3DRYTEFHNFKCVB4ZCQT2W2KPFW7FLE6VLE7QABAAZATFZFD');;
const pair2 = StellarSdk.Keypair.fromSecret('SDSQ5MJALF7VWDFEFETPGGWJK2UEQ5HU6HJBKMT5M5YDJ3WYKMC5RC3O');
const pair3 = StellarSdk.Keypair.fromSecret('SB6HTLWBKVY6KOGKFZE2EKH3ZFSIYHYXJOORGKIOHSMPHBCX4SS4PU6G');

var SecretKey1 = pair1.secret();
var PublicKey1 = pair1.publicKey();
console.log('Account1', SecretKey1, PublicKey1);

var SecretKey2 = pair2.secret();
var PublicKey2 = pair2.publicKey();
console.log('Account2', SecretKey2, PublicKey2);

var SecretKey3 = pair3.secret();
var PublicKey3 = pair3.publicKey();
console.log('Account3', SecretKey3, PublicKey3);


// create and fund the accounts
(async function main() {

    // fetches the current sequence number of the Stellar account
    const account = await server.loadAccount(MasterPublicKey);
    // fetches the minimum fee
    const fee = await server.fetchBaseFee();

    // create and fund accounts with 100,000 lumens
    const transaction = new StellarSdk.TransactionBuilder(account, { fee, networkPassphrase: passphrase })
        .addOperation(StellarSdk.Operation.createAccount({
            source: MasterPublicKey,
            destination: PublicKey1,
            startingBalance: "100000"
        }))
        .addOperation(StellarSdk.Operation.createAccount({
            source: MasterPublicKey,
            destination: PublicKey2,
            startingBalance: "100000"
        }))
        .addOperation(StellarSdk.Operation.createAccount({
            source: MasterPublicKey,
            destination: PublicKey3,
            startingBalance: "100000"
        }))
        .setTimeout(30)
        .build();


    // sign and post tx to the transaction endpoint of the Horizon server
    transaction.sign(MasterKey);
    try {
        const transactionResult = await server.submitTransaction(transaction);
        console.log(transactionResult);

    } catch (err) {
        console.error(err);
    }
})()


