CREATE TABLE users (
    name VARCHAR, address VARCHAR, dob INTEGER, friendlyid VARCHAR PRIMARY KEY, sanction BOOLEAN, balance INTEGER, domain VARCHAR);

INSERT INTO
    users(name, address, dob, friendlyid, sanction, balance, domain)
VALUES
    ('John Doe', 'cityA', '01011988', 'johndoe',  true,  1000,  'banka.com');

CREATE TABLE sanction (
    domain VARCHAR, bankname VARCHAR, sanction BOOLEAN);

INSERT INTO
    sanction(domain, bankname, sanction)
VALUES
    ('bankb.com', 'Bank B', true);

CREATE TABLE transactions (
    txid VARCHAR, sender VARCHAR, receiver VARCHAR, amount INTEGER, currency VARCHAR, kyc_info VARCHAR);