import React, { Component } from 'react';
import StellarSdk from 'stellar-sdk';
import Nav from './Components/Nav';
import Description from './Components/Description';
import Container from './Components/Container';
import USD from './Components/USD';
var concat = require('concat-stream');
const requestObj = require('request');
const DBServer = 'localhost:3600';




class App extends Component {
    constructor() {
        super();
        this.appName = 'Remittance App';
        this.onInputChangeUpdateField = this.onInputChangeUpdateField.bind(this);
        this.USDasset = USD;
        this.USD = new StellarSdk.Asset(this.USDasset.code, this.USDasset.issuer);

        this.state = {

            network: 'Private Testnet',
            account: null,
            balance: 0,
            name: '',

            fields: {
                friendlyid: null,
                receiver: null,
                amount: null,
                sellprice: null,
                sellamount: null,
            }
        }
    }



    setAccount = () => {

        var account = this.state.fields.friendlyid;
        let app = this;
        var url = 'http://' + DBServer + '/userdet';

        fetch(url, {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                friendlyid: account
            })
        }).then(function (response, error) {
            if (response) {
                return response.json();
            }
            else {
                console.log(error);
            }
        }).then(function (data) {

            app.setState({
                account,
                name: data.name,
                balance: data.balance
            });
        })
    }


    setBalance = () => {
        let app = this;
        var account = this.state.account;
        var url = 'http://' + DBServer + '/userbal';
        fetch(url, {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                friendlyid: account
            })
        }).then(function (response, error) {
            if (response) {
                return response.json();
            }
            else {
                console.log(error);
            }
        }).then(function (data) {

            app.setState({
                balance: data.balance
            });
        })
    }


    setBank = () => {

        let app = this;
        var url = 'http://' + DBServer + '/bankuser';
        fetch(url).then(function (response, error) {
            if (response) {
                return response.json();
            }
            else {
                console.log(error);
            }
        }).then(function (data) {

            app.setState({
                receivedtx: data.tx
            });

        })
    }


    payment = () => {

        let app = this;
        var url = 'http://' + DBServer + '/payment';

        fetch(url, {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                receiver: this.state.fields.receiver,
                amount: this.state.fields.amount,
                account: this.state.account
            })
        }).then(function (response, error) {
            if (response) {
                return response.json();
            }
            else {
                console.log(error);
            }
        }).then(function (data) {
            if (data.msg == "SUCCESS!") {
                var disObj = JSON.parse(data.result);
                app.setState({
                    txstatus: 'Transaction Successful',
                    txid: disObj.hash
                });
                app.setBalance();
            }
            else {
                console.log("Error", data);
                app.setState({
                    txstatus: 'Transaction Failed',
                });
            }
        });
    }





