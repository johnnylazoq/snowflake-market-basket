USE DATABASE retail_vault;
USE SCHEMA raw_vault;

CREATE TABLE IF NOT EXISTS hub_order (
    hk_order VARCHAR(64) PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    load_dts TIMESTAMP_NTZ NOT NULL,
    record_source VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS hub_product (
    hk_product VARCHAR(64) PRIMARY KEY,
    product_id VARCHAR(50) NOT NULL,
    load_dts TIMESTAMP_NTZ NOT NULL,
    record_source VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS link_order_product (
    hk_link_order_product VARCHAR(64) PRIMARY KEY,
    hk_order VARCHAR(64) REFERENCES hub_order(hk_order),
    hk_product VARCHAR(64) REFERENCES hub_product(hk_product),
    load_dts TIMESTAMP_NTZ NOT NULL,
    record_source VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS sat_order_product (
    hk_link_order_product VARCHAR(64) REFERENCES link_order_product(hk_link_order_product),
    load_dts TIMESTAMP_NTZ NOT NULL,
    hash_diff VARCHAR(64) NOT NULL,
    quantity INT,
    unit_price NUMBER(10,2),
    record_source VARCHAR(100) NOT NULL,
    PRIMARY KEY (hk_link_order_product, load_dts)
);
