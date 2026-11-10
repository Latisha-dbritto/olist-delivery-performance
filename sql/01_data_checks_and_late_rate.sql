-- Question: how many delivered orders were late, and can the dates be trusted?
-- "Late" = delivered after the estimated delivery date.

select count(*) as delivered_orders from orders  
where order_status = 'delivered' and order_delivered_customer_date is not null

select count(*) as late_orders from orders
where order_status = 'delivered' and order_delivered_customer_date is not null
and order_delivered_customer_date > order_estimated_delivery_date

--Late percentage
SELECT 
    COUNT(*) AS total,
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS late,
    round(
        (SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1.0 ELSE 0 END) /count(*))*100,2) as late_percent
FROM orders
WHERE order_status = 'delivered' 
  AND order_delivered_customer_date IS NOT NULL;

--carrier pickup date missing
select count(*) as dates_missing from orders
where  order_status = 'delivered'and order_delivered_carrier_date is null 

--approval date missing
select count(*) as dates_missing from orders
where  order_status = 'delivered'and order_delivered_carrier_date is null 

--carrier pickup before approval
select count(*) as carrier_before_approval from orders
where order_status = 'delivered' and order_delivered_carrier_date < order_approved_at 

--delivery to the customer before carrier pickup
select count(*) as delivery_before_pickup from orders
where order_status = 'delivered' and order_delivered_carrier_date > order_delivered_customer_date 
