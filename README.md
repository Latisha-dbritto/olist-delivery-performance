# Olist Delivery Performance and Customer Impact

I wanted to find out where delivery goes wrong on an online marketplace, and whether late delivery affects what customers think. I looked at four questions:

How long does an order take, and which stage takes the longest?
What is different about late orders?
Is lateness the same everywhere in Brazil?
Do late orders get lower review scores?

## Data

[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), from Kaggle (about 99,000 orders, 2016 to 2018). The raw files are large, so they are not in this repo. You can download them from Kaggle and run the SQL yourself.

## Tables used:  orders, customers, order_reviews.

## Manner of thing defined 
Delivery time is split into three stages:
Approval: purchase to payment approval
Handling: approval to the seller handing the parcel to the carrier (seller side)
Transit: carrier pickup to delivery at the customer (carrier side)
Late means the order reached the customer after the estimated delivery date. The estimate is set by the platform, so "late" here means late compared with what the customer was promised.
Only delivered orders with a delivery date are included (96,470 orders).
About 1.5% of orders had inconsistent timestamps (for example, the carrier pickup recorded before approval, or delivery before pickup). I left them out of the stage averages.

## Process
SQL Server: worked out the time taken in each stage, labelled each order as late or on time with a CASE WHEN, and compared the two groups with GROUP BY.
Calculated the late percentage for each state by joining orders to customers.
Joined order_reviews to compare review scores of late and on-time orders.

(Add here: Excel seller scorecard, dashboard, slides, once they are done.)

## Findings
8.1% of delivered orders were late (7,826 of 96,478).
Most of the extra time is in transit. Late orders spent about 25.7 days in transit, against 7.9 days for on-time orders. Of the roughly 20.6 extra days late orders take overall, about 17.8 (about 86%) are in transit. Handling is about twice as long for late orders (5.3 days against 2.6), and approval is almost the same.
The north-east had the highest late rates. Alagoas 23.9%, Maranhão 19.7%, Piauí 16.0%, Ceará 15.3% and Sergipe 15.2%, against 8.1% overall. The Amazon states (Amazonas, Acre, Rondônia) had low late rates.
São Paulo and Rio de Janeiro have the most late orders in total (2,387 and 1,664), about half of all late orders together, because they have the most orders. São Paulo's rate is low (5.9%) and Rio's is higher (13.5%).
Late orders had lower review scores: 2.57 on average, against 4.29 for on-time orders (a gap of about 1.7 points).

## Limitations
This shows where the time is lost, not why. A long transit time could be the carrier, the distance, or the region. I have not tested these.
The low late rate in the Amazon states may be because the platform gives longer estimates there, so lateness is measured against a more generous promise. I have not checked this.
Some states have very few orders (Roraima 41, Amapá 67, Acre 80), so their percentages move a lot with a few orders.
The review comparison only covers orders that have a review. Customers who are unhappy may be more likely to leave one.
This is an association between late delivery and lower scores. It does not prove that lateness caused the lower scores.
There is no cost data, so I have not measured the money impact.

## Files
sql/: the SQL queries
outputs/: result tables
(Add dashboard and slides folders when they are done.)
