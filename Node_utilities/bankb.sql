CREATE TABLE users (
    name VARCHAR, address VARCHAR, dob INTEGER, friendlyid VARCHAR PRIMARY KEY, sanction BOOLEAN, balance INTEGER, domain VARCHAR);

INSERT INTO
    users(name, address, dob, friendlyid, sanction, balance, domain)
VALUES
    ('Jane Smith', 'cityB', '31031991', 'janesmith', true, 2000, 'bankb.com');

CREATE TABLE sanction (
    domain VARCHAR, bankname VARCHAR, sanction BOOLEAN);

INSERT INTO
    sanction(domain, bankname, sanction)
VALUES
    ('banka.com', 'Bank A', true);

CREATE TABLE transactions (
    txid VARCHAR, sender VARCHAR, receiver VARCHAR, amount INTEGER, currency VARCHAR, kyc_info VARCHAR);