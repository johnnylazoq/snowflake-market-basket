USE DATABASE retail_vault;
USE SCHEMA information_mart;

CREATE OR REPLACE VIEW vw_market_basket_pairs AS
WITH order_items AS (
    SELECT DISTINCT
        ho.order_id,
        hp.product_id
    FROM raw_vault.link_order_product lop
    JOIN raw_vault.hub_order ho ON lop.hk_order = ho.hk_order
    JOIN raw_vault.hub_product hp ON lop.hk_product = hp.hk_product
)
SELECT
    a.product_id AS product_a,
    b.product_id AS product_b,
    COUNT(DISTINCT a.order_id) AS co_occurrence_count
FROM order_items a
JOIN order_items b
  ON a.order_id = b.order_id
 AND a.product_id < b.product_id
GROUP BY 1, 2;
