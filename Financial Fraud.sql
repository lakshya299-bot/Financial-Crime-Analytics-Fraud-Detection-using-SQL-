CREATE TABLE transactions (
    currency VARCHAR(3) NOT NULL,
    amount BIGINT NOT NULL,
    state VARCHAR(25) NOT NULL,
    created_date DATETIME NOT NULL,
    merchant_category VARCHAR(100),
    merchant_country VARCHAR(3),
    entry_method VARCHAR(10) NOT NULL,
    user_id CHAR(36) NOT NULL,
    type VARCHAR(20) NOT NULL,
    source VARCHAR(20) NOT NULL,
    id CHAR(36) PRIMARY KEY
);

CREATE TABLE users (
    serial_number INT AUTO_INCREMENT PRIMARY KEY,
    id CHAR(36) UNIQUE,
    has_email BOOLEAN NOT NULL,
    phone_country VARCHAR(300),
    terms_version VARCHAR(20),
    created_date DATETIME NOT NULL,
    state VARCHAR(25) NOT NULL,
    country VARCHAR(2),
    birth_year INTEGER,
    kyc VARCHAR(20),
    failed_sign_in_attempts INTEGER
);


CREATE TABLE fx_rates (
    base_ccy VARCHAR(3),
    ccy VARCHAR(10),
    rate DOUBLE
);

CREATE TABLE currency_details (
    ccy CHAR(10),
    iso_code INTEGER,
    exponent INTEGER,
    is_crypto VARCHAR(10),
    serial_number INT AUTO_INCREMENT PRIMARY KEY
);

CREATE TABLE fraudsters (
    user_id CHAR(36) PRIMARY KEY
);

CREATE TABLE countries (
    code VARCHAR(2),
    name VARCHAR(100),
    code3 VARCHAR(3),
    numcode INTEGER,
    phonecode INTEGER
);

SELECT DISTINCT source FROM transactions;
SELECT
    t.user_id AS customer_id,
    u.country AS customer_country,
    (t.amount / POW(10, cd.exponent)) / fx.rate AS transaction_amount_usd
FROM transactions t
JOIN users u ON t.user_id = u.id
JOIN currency_details cd ON t.currency = cd.ccy
JOIN fx_rates fx ON t.currency = fx.ccy
WHERE LOWER(t.source) = 'gaia'
  AND fx.rate IS NOT NULL;
  
WITH ranked_tx AS (
    SELECT
        t.user_id,
        t.created_date,
        (t.amount / POW(10, cd.exponent)) / fx.rate AS amount_usd,
        ROW_NUMBER() OVER (PARTITION BY t.user_id ORDER BY t.created_date) AS row_num
    FROM transactions t
    JOIN currency_details cd ON t.currency = cd.ccy
    JOIN fx_rates fx ON t.currency = fx.ccy
    WHERE t.type = 'CARD_PAYMENT'
)
SELECT
    ROUND(100.0 * COUNT(CASE WHEN amount_usd > 10 AND row_num = 1 THEN 1 END) / (SELECT COUNT(*) FROM users), 2) AS transaction_success_rate_pct
FROM ranked_tx;


SELECT
    t.user_id,
    COUNT(*) AS tx_count,
    ROUND(AVG(t.amount / POW(10, cd.exponent) / fx.rate), 2) AS avg_tx_usd,
    MAX(t.amount / POW(10, cd.exponent) / fx.rate) AS max_tx_usd,
    STDDEV(t.amount / POW(10, cd.exponent) / fx.rate) AS std_tx_usd
FROM transactions t
JOIN currency_details cd ON t.currency = cd.ccy
JOIN fx_rates fx ON t.currency = fx.ccy
LEFT JOIN fraudsters f ON t.user_id = f.user_id
WHERE f.user_id IS NULL
GROUP BY t.user_id
ORDER BY max_tx_usd DESC
LIMIT 5;


SELECT * FROM transactions LIMIT 10;
SELECT * FROM users LIMIT 10;
SELECT * FROM fx_rates LIMIT 10;
SELECT * FROM currency_details LIMIT 10;
SELECT * FROM fraudsters LIMIT 10;
SELECT * FROM countries LIMIT 10;
