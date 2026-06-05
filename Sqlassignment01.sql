# SQL Practice Questions with Simple Queries

1. New Customers Signed Up in June 2023

Business Question:** How many new customers signed up during June 2023?


SELECT
    p.PARTY_ID,
    p.FIRST_NAME,
    p.LAST_NAME
FROM person p
JOIN party_role pr
    ON p.PARTY_ID = pr.PARTY_ID
WHERE pr.ROLE_TYPE_ID = 'CUSTOMER'
  AND p.CREATED_STAMP >= '2023-06-01'
  AND p.CREATED_STAMP < '2023-07-01';




 2. Physical Products

Business Question:** Retrieve all physical products for the merchandising team.


SELECT
    p.PRODUCT_ID,
    p.PRODUCT_TYPE_ID,
    p.INTERNAL_NAME
FROM product p
JOIN product_type pt
    ON p.PRODUCT_TYPE_ID = pt.PRODUCT_TYPE_ID
WHERE pt.IS_PHYSICAL = 'Y';




3. Products Missing NetSuite (ERP) ID

Business Question:** Find products that do not have an ERP/NetSuite ID.

SELECT
    p.PRODUCT_ID,
    p.INTERNAL_NAME,
    p.PRODUCT_TYPE_ID
FROM product p
LEFT JOIN good_identification gi
    ON p.PRODUCT_ID = gi.PRODUCT_ID
    AND gi.GOOD_IDENTIFICATION_TYPE_ID = 'ERP_ID'
WHERE gi.ID_VALUE IS NULL;




 4. Product IDs Across Systems

Business Question:** Retrieve HotWax, Shopify, and ERP IDs for products.


SELECT
    p.PRODUCT_ID AS HOTWAX_ID,
    erp.ID_VALUE AS ERP_ID,
    shopify.ID_VALUE AS SHOPIFY_ID
FROM product p
LEFT JOIN good_identification erp
    ON p.PRODUCT_ID = erp.PRODUCT_ID
    AND erp.GOOD_IDENTIFICATION_TYPE_ID = 'ERP_ID'
LEFT JOIN good_identification shopify
    ON p.PRODUCT_ID = shopify.PRODUCT_ID
    AND shopify.GOOD_IDENTIFICATION_TYPE_ID = 'SHOPIFY_PROD_ID';




 5. Completed Orders in August 2023

Business Question:** Retrieve all completed orders from August 2023.


SELECT
    oi.PRODUCT_ID,
    p.PRODUCT_TYPE_ID,
    oh.PRODUCT_STORE_ID,
    oi.QUANTITY,
    oi.ORDER_ID,
    oi.ORDER_ITEM_SEQ_ID,
    oisg.FACILITY_ID,
    oisg.SHIP_GROUP_SEQ_ID
FROM order_header oh
JOIN order_status os
    ON oh.ORDER_ID = os.ORDER_ID
JOIN order_item oi
    ON oh.ORDER_ID = oi.ORDER_ID
JOIN order_item_ship_group oisg
    ON oi.ORDER_ID = oisg.ORDER_ID
    AND oi.SHIP_GROUP_SEQ_ID = oisg.SHIP_GROUP_SEQ_ID
JOIN product p
    ON oi.PRODUCT_ID = p.PRODUCT_ID
WHERE os.STATUS_ID = 'ORDER_COMPLETED'
  AND os.STATUS_DATETIME >= '2023-08-01'
  AND os.STATUS_DATETIME < '2023-09-01';




 6. Newly Created Orders and Payment Methods

Business Question:** Retrieve orders along with their payment methods.


SELECT
    oh.ORDER_ID,
    oh.GRAND_TOTAL,
    opp.PAYMENT_METHOD_ID,
    oh.ORDER_NAME
FROM order_header oh
JOIN order_payment_preference opp
    ON oh.ORDER_ID = opp.ORDER_ID;



 7. Payment Captured but Not Shipped

Business Question:** Find orders whose payment is received but shipment is not completed.


SELECT
    oh.ORDER_ID,
    oh.STATUS_ID AS ORDER_STATUS,
    opp.STATUS_ID AS PAYMENT_STATUS,
    s.STATUS_ID AS SHIPMENT_STATUS
FROM order_header oh
JOIN order_payment_preference opp
    ON oh.ORDER_ID = opp.ORDER_ID
JOIN shipment s
    ON oh.ORDER_ID = s.PRIMARY_ORDER_ID
WHERE opp.STATUS_ID = 'PAYMENT_RECEIVED'
  AND s.STATUS_ID <> 'SHIPMENT_SHIPPED';




8. Orders Completed Hourly

Business Question:** Count completed orders by hour.


SELECT
    HOUR(STATUS_DATETIME) AS HOUR,
    COUNT(*) AS TOTAL_ORDERS
FROM order_status
WHERE STATUS_ID = 'ORDER_COMPLETED'
  AND DATE(STATUS_DATETIME) = '2021-08-18'
GROUP BY HOUR(STATUS_DATETIME)
ORDER BY HOUR;




9. BOPIS Orders Revenue

Business Question:** Calculate total orders and revenue from BOPIS orders.


SELECT
    COUNT(*) AS TOTAL_ORDERS,
    SUM(oh.GRAND_TOTAL) AS TOTAL_REVENUE
FROM order_header oh
JOIN shipment s
    ON oh.ORDER_ID = s.PRIMARY_ORDER_ID
WHERE s.SHIPMENT_METHOD_TYPE_ID = 'STOREPICKUP'
  AND oh.ORDER_DATE >= '2023-01-01'
  AND oh.ORDER_DATE < '2024-01-01';




10. Cancelled Orders and Reasons

Business Question:** Find cancelled orders and their cancellation reasons.


SELECT
    CHANGE_REASON,
    COUNT(*) AS TOTAL_ORDERS
FROM order_status
WHERE STATUS_ID = 'ORDER_CANCELLED'
GROUP BY CHANGE_REASON;

