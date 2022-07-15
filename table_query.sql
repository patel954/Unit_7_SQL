DROP TABLE IF EXISTS card_holder CASCADE;
DROP TABLE IF EXISTS credit_card CASCADE;
DROP TABLE IF EXISTS merchant_category CASCADE;
DROP TABLE IF EXISTS merchant CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;


-- Create a table of card holders
CREATE TABLE card_holder (
  id INTEGER primary key not null,
  name VARCHAR   NOT NULL
);
select * from card_holder

-- Create a table of credit card
CREATE TABLE credit_card (
    card VARCHAR NOT NULL PRIMARY KEY,
    cardholder_id INTEGER NOT NULL,
    FOREIGN KEY (cardholder_id) REFERENCES card_holder(id)
);
select * from credit_card

-- Create a table of merchant
CREATE TABLE merchant_category (
    id INTEGER   NOT NULL PRIMARY KEY,
    name VARCHAR   NOT NULL
);

--Create a table of merchant category
CREATE TABLE merchant (
  id INT PRIMARY KEY,
  name VARCHAR NOT NULL,
  id_merchant_category INT NOT NULL,
  FOREIGN KEY (id_merchant_category) REFERENCES merchant_category(id)
);

--Create a table of transaction
CREATE TABLE transaction(
  id INT PRIMARY KEY,
  date timestamp NOT NULL,
  amount varchar NOT NULL,
  card varchar not null,
  id_merchant int not null,
  FOREIGN KEY (id_merchant) REFERENCES merchant(id),
  FOREIGN KEY (card) REFERENCES credit_card(card)
);


