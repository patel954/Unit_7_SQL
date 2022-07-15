-- How can you isolate (or group) the transactions of each cardholder?
-- DROP VIEW cardholder_transactions;

SELECT h.id, h.name, c.card, t.date, t.amount AS "amount", m.name AS "merchant", g.name AS "category" 
FROM card_holder h
	LEFT JOIN credit_card c
	ON h.id = c.cardholder_id
		LEFT JOIN transaction t
		ON c.card = t.card
			RIGHT JOIN merchant m
			ON t.id_merchant = m.id
				Right JOIN merchant_category g
				ON m.id_merchant_category = g.id
GROUP BY h.id, h.name, c.card, t.date, t.amount, m.name, g.name
ORDER BY h.id;

-- View transactions ranking by amounts from the highest to the lowest
create view cardholder_trans as
SELECT h.id, h.name, c.card, t.date, t.amount  AS "amount", m.name AS "merchant", g.name AS "category" 
FROM card_holder h
	LEFT JOIN credit_card c
	ON h.id = c.cardholder_id
		LEFT JOIN transaction t
		ON c.card = t.card
			RIGHT JOIN merchant m
			ON t.id_merchant = m.id
				Right JOIN merchant_category g
				ON m.id_merchant_category = g.id
GROUP BY h.id, h.name, c.card, t.date, t.amount, m.name, g.name
ORDER BY t.amount DESC;

-- Consider the time period 7:00 a.m. to 9:00 a.m.
-- What are the top 100 highest transactions made between 7:00 am and 9:00 am?
SELECT *, round(ct.amount,2) as amount
    FROM cardholder_trans ct
    WHERE EXTRACT(HOUR FROM ct.date) BETWEEN 7 AND 8
    ORDER BY round(ct.amount,2) desc
	limit 100;

-- Some fraudsters hack a credit card by making several small payments (generally less than $2.00), which are typically ignored by cardholders. 
-- Count the transactions that are less than $2.00 per cardholder. Is there any evidence to suggest that a credit card has been hacked? Explain your rationale.
create view less_than_2 as
SELECT ct.id, ct.name, ct.card, ct.date, round(ct.amount,2)  AS "amount", ct.name AS "merchant", ct.name AS "category" 
FROM cardholder_trans ct	
          WHERE round(ct.amount,2) <= 2.00
ORDER BY ct.amount DESC;

CREATE VIEW small_transactions AS
SELECT s.id, s.name, COUNT(s.id) AS "small_transactions" 
FROM less_than_2 s
GROUP BY s.id, s.name
ORDER BY "small_transactions" DESC;

-- What are the top 5 merchants prone to being hacked using small transactions?
DROP VIEW vulnerable_merchants;
CREATE VIEW top_5_merchants AS
SELECT s.merchant, s.category, COUNT(s.merchant) AS "top_5_merchants"
FROM less_than_2 s
GROUP BY s.merchant, s.category
ORDER BY "top_5_merchants" DESC;