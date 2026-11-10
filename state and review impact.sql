-- Questions: is lateness the same in every state, and do late orders get lower review scores?

--lateness spread across Brazil
select count(o.order_id) as 'total_orders', 
    sum(case when o.order_estimated_delivery_date < o.order_delivered_customer_date then 1.0 else 0 end) as 'late_orders',
    round((sum(case when o.order_estimated_delivery_date < o.order_delivered_customer_date then 1.0 else 0 end)/count(o.order_id))*100,2) as 'late_percent',
    c.customer_state
from customers c left outer join orders o
on c.customer_id = o.customer_id
where order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL
group by customer_state
order by late_percent desc

--customer impact
select 
    case when o.order_delivered_customer_date > o.order_estimated_delivery_date then 'late' else 'on time' end as 'delivery status',
    avg(cast(r.review_score as float)) as 'total_avg_review_score',
    count(o.order_id) as 'total_orders'
from orders o inner join order_reviews r
on o.order_id = r.order_id
where order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL
group by (case when o.order_delivered_customer_date > o.order_estimated_delivery_date then 'late' else 'on time' end)