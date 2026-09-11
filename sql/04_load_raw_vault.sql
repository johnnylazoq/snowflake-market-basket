USE DATABASE retail_vault;

-- Populera Hub Order
INSERT INTO raw_vault.hub_order (hk_order, order_id, load_dts, record_source)
SELECT DISTINCT
    SHA2_HEX(order_id), order_id, CURRENT_TIMESTAMP(), 'POS_SYSTEM'
FROM stage_transactions st
WHERE NOT EXISTS (
    SELECT 1 FROM raw_vault.hub_order ho WHERE ho.hk_order = SHA2_HEX(st.order_id)
);

-- Populera Hub Product
INSERT INTO raw_vault.hub_product (hk_product, product_id, load_dts, record_source)
SELECT DISTINCT
    SHA2_HEX(product_id), product_id, CURRENT_TIMESTAMP(), 'POS_SYSTEM'
FROM stage_transactions st
WHERE NOT EXISTS (
    SELECT 1 FROM raw_vault.hub_product hp WHERE hp.hk_product = SHA2_HEX(st.product_id)
);

-- Populera Link
INSERT INTO raw_vault.link_order_product (hk_link_order_product, hk_order, hk_product, load_dts, record_source)
SELECT DISTINCT
    SHA2_HEX(CONCAT(order_id, '||', product_id)),
    SHA2_HEX(order_id),
    SHA2_HEX(product_id),
    CURRENT_TIMESTAMP(),
    'POS_SYSTEM'
FROM stage_transactions st
WHERE NOT EXISTS (
    SELECT 1 FROM raw_vault.link_order_product lop
    WHERE lop.hk_link_order_product = SHA2_HEX(CONCAT(st.order_id, '||', st.product_id))
);
