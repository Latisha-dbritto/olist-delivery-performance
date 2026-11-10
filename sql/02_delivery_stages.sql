-- Question: which stage of delivery takes how much time, and is it comparatively different for late orders?
-- Stages: approval, handling (seller), transit (carrier).

--Average time in each part

--Approval: purchase to approval (payment and platform)
select avg(datediff(hour, order_purchase_timestamp, order_approved_at)/24.0) as avg_approval from orders
where order_status = 'delivered' and order_delivered_customer_date is not null

--Handling: approval to carrier pickup (the seller packs and ships)
select avg(datediff(hour, order_approved_at, order_delivered_carrier_date)/24.0) as avg_handling from orders
where order_status = 'delivered' and order_delivered_customer_date is not null and order_delivered_carrier_date >= order_approved_at

--Transit: carrier pickup to delivery to the customer 
select avg(datediff(hour, order_delivered_carrier_date, order_delivered_customer_date)/24.0) as avg_transit from orders
where order_status = 'delivered' and order_delivered_customer_date is not null and order_delivered_customer_date >= order_delivered_carrier_date

--late vs on-time: approval stage
select 
    case when order_estimated_delivery_date < order_delivered_customer_date then 'late' else 'on_time' end as delivery_status,
    AVG(DATEDIFF(hour, order_purchase_timestamp, order_approved_at) / 24.0) AS avg_approval
    from orders
where order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL
group by case when order_estimated_delivery_date < order_delivered_customer_date then 'late' else 'on_time' end 

--late vs on-time: handling stage
select 
    case when order_estimated_delivery_date < order_delivered_customer_date then 'late' else 'on_time' end as delivery_status,
    avg(datediff(hour, order_approved_at, order_delivered_carrier_date)/24.0) as avg_handling
    from orders
where order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL and order_delivered_carrier_date >= order_approved_at
group by case when order_estimated_delivery_date < order_delivered_customer_date then 'late' else 'on_time' end 

--late vs on-time: transit stage
select 
    case when order_estimated_delivery_date < order_delivered_customer_date then 'late' else 'on_time' end as delivery_status,
    avg(datediff(hour, order_delivered_carrier_date, order_delivered_customer_date)/24.0) as avg_transit
    from orders
where order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL and order_delivered_customer_date >= order_delivered_carrier_date
group by case when order_estimated_delivery_date < order_delivered_customer_date then 'late' else 'on_time' end
