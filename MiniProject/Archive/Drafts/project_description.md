# Olist Data Inventory

## Source

Dataset: Brazilian E-Commerce Public Dataset by Olist 

Source: [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) 

Original dataset: Olist Brazilian E-Commerce Public Dataset  

## Tables

This is only an example not the final or actual dictionary table 

| Source Table | Used? | Purpose |
|---|---|---|
| customers | Yes | Customer information |
| orders | Yes | Order information |
| order_items | Yes | Products purchased in each order |
| products | Yes | Product information |
| sellers | No | Seller information, outside project scope |
| order_payments | No | Payment information, outside project scope |
| order_reviews | No | Customer reviews, outside project scope |
| geolocation | No | Geographic reference data, outside project scope |
| product_category_name_translation | No | Category translation, not required for current scope |

## Scope

This project uses **8 of the 9 available source tables** to implement the required online-store database. The remaining table, which contains seller-related data, is excluded from the current implementation to maintain the defined project scope.

The selected 8 tables will be transformed through appropriate **normalization and denormalization** techniques to create an efficient database structure. This process also addresses data redundancy across the source tables. For example, customer location information may be repeated across multiple tables within the original dataset.

The main relationship between the core entities can be represented as:

`Customers → Orders → Order Items → Products`

The excluded seller-related table is **preserved and documented for reference** but is not included in the current database implementation.


## Project Data Setup
Data files are excluded from Git to prevent repository bloat. 
1. Download the contents of our [Shared Google Drive Link Here].
2. Place the folders directly into your local directory at:
   `MiniProject/data/`


The Excel file contains four sheets:
- Customers: Customer information and postal codes.
- Orders: Order details, payment information, and timestamps.
- Order_items: Products included in each order, quantities, prices, and shipping costs.
- Products: Product details, dimensions, weight, and other attributes.


## How we worked? who did what? what we achived and learned?

Dataset Creation
Mohamed Sokarno: from 9 tables he created 4
since this is a real data set, we dont have the real names of the customers or the products the nearest thing to that is the customer_id and the product_id, but other data such as product category and customer demogrhic data is still going to help create 
   Found the Dataset on kaggle called Brazilian E-Commerce Public Dataset by Olist which is a real dataset for a brazillian e-commerce store.
   The data had 9 tables orignally but through doing proper joins and denormalizing and normalizing specific tables so we end up with only 4 targeted tables (Customers, Orders, ORder Items, Products)
   Wass that the best approch, yes and no
   to be able to merge and denormazlie some tables such as payment table with payment table, we had to change the data type in the column payment_installments from a numerical number that tells you how many installment to only true of false the reason for it is to get rid of redundancy.

   The challenge I faced was also issues with encoding so had to fix encoding to UTF-8

   Created the database, schemas, and tables in SQL
   started filling them from the raw CSV files using joins

ERD
Mahmoud Al-Nabawi: Created ERD for the orignal Dataset 
so we can explain how and why we choosed this dataset

Also worked on creating a data disctinary

Data Cleaning & Preparing
Mohamed El-Gml: Cleaned the data and created the notebook
used Python to clean and prepare an e-commerce dataset containing customers, orders, and products. First, I removed empty rows and duplicates, standardized column names and text and missing values, and corrected data types like dates and prices. Then I checked for unusual values, such as negative prices, duplicate IDs, and incorrect delivery dates.
The most interesting part was checking the relationships between the tables. For example, I checked whether every order belonged to an existing customer and whether every product in an order actually existed in the products table. Instead of deleting suspicious records, I flagged them in a separate report so they could be reviewed without losing potentially useful data.

the most interesting finding?
The most interesting aspect is that the code checks whether the tables agree with each other, not just whether individual cells are clean.
For example, an order might contain a correctly formatted customer ID, but that customer might not exist in the Customers sheet. Similarly, an order item might refer to a product that is missing from the Products sheet.
These problems can be more serious than inconsistent capitalization or extra spaces because they can affect sales calculations, customer analysis, and product performance reports.
The date checks are also important. If the recorded delivery date is earlier than the carrier delivery date, calculations of delivery time could become inaccurate.
One important distinction: these are the kinds of problems the code is designed to discover. We cannot claim that it actually found a particular number of errors or a specific business insight without examining the generated quality report.


 What does this achieve for the business?
The cleaning process helps make the dataset more trustworthy before moving to the actual analysis.
For example, it can help prevent:
- Incorrect sales totals caused by duplicated records.
- Incomplete customer analysis caused by broken relationships.
- Misleading delivery-time calculations caused by inconsistent timestamps.
- Errors in averages and other statistics caused by incorrectly formatted numeric values.
It also preserves suspicious records for investigation instead of deleting them automatically. This is useful because an unusual value is not necessarily an incorrect value.


Creating Measures
Mahmoud Saqr: Created measures in Power BI
created a new table called calender to track order date
The measures, in everyday language

Money

Total Sales: quantity × unit price for all delivered orders. Canceled or in-progress orders don’t count.
Freight Value: the same, but for shipping cost.
Total Revenue: Total Sales + Freight.
Avg Order Value: Total Sales ÷ number of delivered orders.
Sales % of Total: how big a slice of the overall sales the selected product (or category) is.

Volume

Delivered Orders: how many distinct orders were delivered.
Units Sold: total items sold in delivered orders.
Products Sold: how many different products were sold.

Customers

Unique Customers: distinct real people (using customer_unique_id, since the same person can have multiple customer_ids), counting only those with delivered orders.
Repeat Customers %: the share of those customers who placed more than one delivered order.

Time comparisons

Sales YTD: running total of sales since Jan 1 of the year.
Sales Last Month: sales from the previous month.
Sales MoM %: percentage change vs. last month. It only shows when one month is selected, there’s a previous month, and last month’s sales were at least 1,000. That avoids silly huge percentages from tiny bases.

Delivery and service

Avg Delivery Days: average days from purchase to delivery, for delivered orders with no status conflict and a real delivery date.
On-Time Delivery %: of those same orders, the share delivered on or before the estimated date (time of day ignored).
Cancellation Rate: canceled orders ÷ all orders.

What’s on the report page

12 KPI cards: Total Sales, Total Revenue, Freight Value, Avg Order Value, Delivered Orders, Units Sold, Products Sold, Unique Customers, Repeat Customers %, Cancellation Rate, On-Time Delivery %, Avg Delivery Days
A bar chart of Total Sales by product category
A line chart of Total Sales by Year-Month
A table by Year and Month showing Total Sales, Sales YTD, and MoM %
A Year slicer to filter everything

Things worth knowing

Almost every sales measure only counts “delivered” orders, so numbers will be lower than total ordered.
Several measures are stored on the customers and Calendar tables, but that’s only for organization; they work across the whole model.

Dashboard
Mostafa Salem: Created the Dashboard in Power BI

Using the already created measures, also added few more columns such as is_late column compares delivered date with estimated date and feeds a Late/On-time label. A decomposition tree lets you drill into where lateness comes from.
It’s a 4-page report on the Olist Brazilian e-commerce marketplace, Jan 2017 to Aug 2018

Home: a navigation page with buttons to the other three.
Executive Overview: Total Revenue, Total Sales, Freight, Delivered Orders, Avg Order Value, Unique Customers. It also has monthly revenue, revenue by state, by city and by payment method, and slicers for year, category and state.
Products & Customers: Units Sold, Categories Count, Revenue per Customer, Repeat Customers %, Top Category Share. It also has Top 10 categories, a category revenue-share table, customers by city, and a monthly sales table with YTD and MoM.
Operations & Delivery: Avg Delivery Days, Late Delivery Rate, Late Orders, On-time Rate, Orders. It also has the slowest 10 states and a decomposition tree of late rate by state, category and payment type.

Customer identity handled properly: it counts customer_unique_id, not customer_id, which would overcount people in this dataset. It adds a small “Customer Type” table (One-time vs Repeat) driven by a SWITCH measure.
Guarded MoM %: it only shows when last month was at least 1,000, so tiny bases don’t produce absurd percentages.
Time intelligence: YTD, MoM, YoY, plus Revenue Peak and Revenue Low measures that highlight the best and worst months.
Data hygiene: it filters to delivered orders, excludes orders with status conflicts, and works from a cleaned Excel file.
Author’s own finding: a chart title says São Paulo (SP) brings in about 38% of revenue.

Descriptive: what happened

Scale (Jan 2017 to Aug 2018)

96.5K delivered orders, 93.4K unique customers, 15.4M total revenue (13.2M product sales and 2.2M freight).
Avg order value is 137, revenue per customer is 165, and there are about 1.14 items per order (110K units).
Freight is about 14% of revenue, or about 17% on top of product sales.

Growth

Monthly sales went from 112K in Jan 2017 to 607K by Sep 2017, with a 3.6M YTD at that point.
The early months show big jumps (+110% Feb, +53% Mar), then choppy months (-5% Apr, -14% Jun) before steadier +9% to +15% growth.
Monthly revenue reaches roughly 1M or more through late 2017 and 2018.

Where the money comes from

Geography: SP state brings 5.8M (about 38%), RJ 2.1M, MG 1.8M, so the top 3 states are about 63% of revenue. The city of São Paulo alone is 2.1M, and it also has the most customers (15.5K, then Rio at 6.9K).
Categories: 74 categories, but the top 5 (health_beauty, watches_gifts, bed_bath_table, sports_leisure, computers_accessories) make up about 39% of revenue. The leader, health_beauty, is only 9.16%, so there’s no single dominant category.
Payments: credit card is 78.4%, boleto 18%, voucher 2.3%.

Customers and service

Repeat customers are only 3.00%.
Avg delivery is 12.6 days, late rate is 8.1% (7.8K orders), and on-time is 91.9%.
Diagnostic: why it looks this way
Very low repeat: about 97% of customers buy once, which fits the numbers (96.5K orders from 93.4K people). Revenue is driven by constantly acquiring new buyers, not by loyalty.
Concentration follows population and logistics: the southeast (SP, RJ, MG) is where the buyers, sellers and warehouses are, so it dominates.
Delivery problems are regional:
The state breakdown shows the Northeast with the worst late rates: AL 23.9%, MA 19.7%, PI 16.0%, CE 15.3%, SE 15.2%, BA 14.0%.
RJ is also bad at 13.5%, and the city list is full of RJ interior towns (Niterói, São Gonçalo, Cabo Frio, Nova Friburgo, Volta Redonda, Macaé and others). That points to a last-mile problem in RJ beyond its main city.
Since the late measure is against the estimated date, some of this may be optimistic estimates and not just slow carriers. That’s an inference I’d test.
Small-sample traps in the report (important):
The “Slowest 10” chart shows tiny municipalities (Novo Brasil, 148 days) that probably have only one or a few orders. They are not real hotspots.
The decomposition tree’s 50% late rates for voucher and for categories like pc_gamer and pet_shop come from very few orders after filtering to AL.
Both charts are labeled “state” but plot city.
Prescriptive: what to do
Target the Northeast and RJ interior for logistics: add carrier options or a local hub, and check how estimated dates are set there. AL, MA and PI are the priorities.
Fix the metrics before acting: show states (not cities) on the slowest and late-rate charts, and add a minimum-order filter (for example 30+ orders) so tiny towns don’t dominate.
Attack the 3% repeat rate: a lift from 3% to 5% means about 2K more returning customers without extra acquisition cost. Use post-delivery coupons, email re-engagement, and cross-sell from the large categories like health_beauty and bed_bath_table, which have natural reorder cycles.
Reduce SP dependence: SP at 38% is both an opportunity and a risk. Test growth campaigns in RS, PR and SC, which are already the next tier, and where delivery is likely better than the Northeast.
Use the spread across categories: with no category above 9.2%, you can run category promotions with low concentration risk. Review the long tail among the 74 categories for consolidation.
Payment strategy: credit card at 78% suggests offering installment promos. Look at whether boleto (18%) carries more cancellations or abandoned orders and nudge those buyers toward cards or Pix-style instant payment.
Cap freight impact: at about 14% of revenue, test free-shipping thresholds in the high-volume southeast, where delivery is cheapest and fastest.


Work Review & Leadership
Mohamed Sokarno: Reviewed ERD, Measures, And Dashboard
Made sure things are aligned

Presentaion & Documentaion & Explaining
Mohamed Sokarno: He is the one who created the folder sschema for the repo and makes sure everything is aligned and delivered well. to make his team achive the number 1 position in between all teams


DEPI & ITC Mangment (Others)
Mentor & lecturer: Eman Ghanem
ITC_ONL5_Dat3_G3 operator: Esraa Yahia
ITC CEO: Mahmoud Raslan
