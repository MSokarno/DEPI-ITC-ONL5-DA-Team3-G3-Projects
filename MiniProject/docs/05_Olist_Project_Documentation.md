# Olist E-Commerce Data Analysis Mini Project

## 1. Project Overview

This project uses the **Brazilian E-Commerce Public Dataset by Olist** to build a structured online-store database and a Power BI report for exploring sales, customers, product categories, and delivery performance.

The project covers the data workflow from source-data discovery and preparation to database design, SQL implementation, Power BI measures, dashboard development, and business recommendations.

## 2. Dataset Source

- **Dataset:** Brazilian E-Commerce Public Dataset by Olist
- **Source:** [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **Coverage shown in the dashboard:** January 2017 to August 2018
- **Data type:** Historical e-commerce marketplace data. The dataset does not provide real customer or product names for all entities; IDs and descriptive attributes are used instead.

## 3. Data Inventory and Scope

The original dataset contains nine source tables. The project’s final database is organized into four core tables:

| Final table | Purpose |
|---|---|
| `customers` | Customer identifiers and customer-related attributes |
| `orders` | Order-level details, statuses, timestamps, and selected order attributes |
| `order_items` | Products associated with each order, including quantities, prices, and freight |
| `products` | Product identifiers and product attributes |

The core relationship is:

`Customers → Orders → Order Items → Products`

The source dataset also contains seller, payment, review, geolocation, and product-category translation data. The draft inventory marks these source tables as outside the implemented scope.


## 4. Local Data Setup

The data files are excluded from Git to avoid making the repository unnecessarily large.

1. Download the project data from the [team’s shared Google Drive.](https://drive.google.com/drive/folders/1ZsMqVRvRY7Zun0ae-I2Kq6L0AAAjH34K?usp=sharing)
2. Place the downloaded folders under `MiniProject/data/`.
3. Follow the repository’s existing folder structure and file naming conventions.

The prepared workbook is described as containing four sheets:

- **Customers:** Customer information and postal-code attributes.
- **Orders:** Order details, payment-related fields, and timestamps.
- **Order Items:** Products in each order, quantities, prices, and freight costs.
- **Products:** Product details, dimensions, weight, and other attributes.


## 5. Team Workflow and Contributions

### 5.1 Dataset Selection and Database Creation
**Contributor: Mohamed Sokarno**

- Identified the Olist Brazilian E-Commerce Public Dataset on Kaggle.
- Helped transform the source data into four target entities: Customers, Orders, Order Items, and Products.
- Designed and created the SQL database, schemas, and tables.
- Loaded data from the source files using SQL and joins.
- Investigated and corrected text-encoding issues by converting data to UTF-8.
- Considered normalization, denormalization, and redundancy when shaping the target tables.

One design trade-off involved simplifying payment-related information. The original notes say that `payment_installments` was converted from a numeric installment count to a Boolean value to reduce redundancy. This changes the meaning of the field and loses the exact installment count. Confirm the final implementation and explain the business reason before describing this as a settled design decision. Of the 9 tables available in the dataset, 8 were included in the analysis. The remaining table was excluded because it contained seller-related information that fell outside the scope of the project.

Because the dataset is historical and does not contain real names for every customer or product, analysis relies on identifiers such as customer and product IDs, along with available attributes such as product category and customer-related information.

### 5.2 Source-Dataset ERD and Data Dictionary
**Contributor: Mahmoud Al-Nabawi**

- Created an Entity Relationship Diagram (ERD) for the original dataset.
- Helped explain the structure of the source data and support the dataset-selection discussion.
- Contributed to the data dictionary.

The source ERD should be distinguished from the final four-table database ERD if both are included in the presentation.

### 5.3 Data Cleaning and Preparation
**Contributor: Mohamed El-Gml**

Used Python to clean and prepare the e-commerce data and created a notebook documenting the workflow. The reported cleaning steps included:

- Removing empty rows and duplicate records.
- Standardizing column names and text values.
- Handling missing values.
- Correcting data types, including dates and prices.
- Checking for unusual values, such as negative prices, duplicate IDs, and inconsistent delivery dates.
- Checking relationships between tables, such as whether every order references an existing customer and whether every order item references an existing product.
- Flagging suspicious records in a separate report rather than deleting them automatically.

**Why this matters:** Data quality is not only about individual cells. Referential-integrity issues and conflicting timestamps can distort sales calculations, customer analysis, and delivery-performance measures. Preserving flagged records also allows the team to investigate unusual values instead of assuming every outlier is invalid.

### 5.4 Power BI Measures and Calendar Table
**Contributor: Mahmoud Saqr**

Created measures in Power BI and added a Calendar table to support date-based analysis.

#### Financial measures

- **Total Sales:** Quantity multiplied by unit price for delivered orders.
- **Freight Value:** Freight charges associated with the included delivered orders, according to the implemented measure.
- **Total Revenue:** Total Sales plus Freight Value.
- **Average Order Value:** Total Sales divided by the number of delivered orders.
- **Sales % of Total:** The selected product or category’s share of overall sales.

#### Volume measures

- **Delivered Orders:** Count of distinct delivered orders.
- **Units Sold:** Total item quantity in delivered orders.
- **Products Sold:** Count of distinct products sold, subject to the implemented measure’s filter context.

#### Customer measures

- **Unique Customers:** Counts `customer_unique_id` rather than `customer_id`, because one person may be represented by more than one customer record.
- **Repeat Customers %:** The proportion of included customers who placed more than one delivered order.

#### Time-based measures

- **Sales YTD:** Cumulative sales from the beginning of the year.
- **Sales Last Month:** Sales for the preceding month.
- **Sales MoM %:** Percentage change compared with the previous month. According to the notes, the measure is shown only when a single month is selected, a prior month exists, and prior-month sales are at least 1,000.

#### Delivery and service measures

- **Average Delivery Days:** Average time from purchase to delivery for delivered orders that meet the implemented date and status checks.
- **On-Time Delivery %:** Share of eligible orders delivered on or before the estimated date, ignoring time of day.
- **Cancellation Rate:** Cancelled orders divided by all orders, according to the measure’s implemented filter logic.

The initial report page included 12 KPI cards, a bar chart of sales by product category, a monthly sales line chart, a Year-Month table with sales/YTD/MoM values, and a Year slicer.

### 5.5 Power BI Dashboard
**Contributor: Mostafa Salem**

Developed a four-page Power BI report covering the Olist marketplace from January 2017 to August 2018.

#### Page 1: Home
A navigation page with buttons linking to the other report pages.

#### Page 2: Executive Overview
Includes Total Revenue, Total Sales, Freight, Delivered Orders, Average Order Value, and Unique Customers. It also presents monthly revenue, revenue by state and city, revenue by payment method, and slicers for year, category, and state.

#### Page 3: Products & Customers
Includes Units Sold, Categories Count, Revenue per Customer, Repeat Customers %, and Top Category Share. Supporting visuals include the top 10 categories, category revenue-share table, customers by city, and monthly sales with YTD and MoM values.

#### Page 4: Operations & Delivery
Includes Average Delivery Days, Late Delivery Rate, Late Orders, On-Time Rate, and Orders. Supporting visuals include a “Slowest 10” location chart and a decomposition tree for exploring late-delivery rates by state, category, and payment type.

Additional implementation notes:

- Uses `customer_unique_id` for unique-customer counts.
- Includes a Customer Type classification for One-time vs. Repeat customers, driven by a `SWITCH` measure.
- Uses a guarded month-over-month measure to avoid extreme percentages based on very small prior-month values.
- Includes time-intelligence measures such as YTD, MoM, YoY, Revenue Peak, and Revenue Low.
- Uses a late/on-time classification based on delivered and estimated delivery dates.
- Filters or excludes records according to the implemented delivery-status and date-quality rules.

### 5.6 Project Review, Coordination, and Presentation

**Contributor: Mohamed Sokarno**

- Reviewed the ERD, cleaning pipline, Power BI measures, and dashboard to help maintain consistency between the database design, analytical definitions, and final report.
- Created the repository’s schema folder and coordinated the alignment and delivery of project components.
- Took responsibility for organizing project documentation and explaining how the work fits together.

## 6. Reported Findings

The following figures and interpretations were recorded in the project draft.

### 6.1 Reported Scale

For the period January 2017 to August 2018, the draft reports:

- **96.5K** delivered orders.
- **93.4K** unique customers.
- **15.4M** total revenue, consisting of **13.2M** product sales and **2.2M** freight.
- Average order value of approximately **137**.
- Revenue per customer of approximately **165**.
- Approximately **110K** units sold, or **1.14 items per delivered order**.
- Freight representing approximately **14% of total revenue**.


### 6.2 Sales Trend

The draft reports monthly sales rising from approximately **112K in January 2017 to 607K in September 2017**, with year-to-date sales of 3.6M at that point. **It describes strong early growth followed by month-to-month fluctuations**, with monthly revenue reaching around 1M or more during later periods.


### 6.3 Geographic and Category Distribution

The draft reports:

- São Paulo state (SP): approximately 5.8M, or 38% of revenue.
- Rio de Janeiro (RJ): approximately 2.1M.
- Minas Gerais (MG): approximately 1.8M.
- The three leading states together account for approximately 63% of revenue.
- The São Paulo city figure is approximately 2.1M.
- The dataset contains 74 product categories; the five largest categories reportedly account for around 39% of revenue.
- Health & Beauty is reported as the leading category at approximately 9.16%.
- Payment mix is reported as 78.4% credit card, 18% boleto, and 2.3% voucher.

Confirm that these values use consistent revenue definitions and the intended filters.

### 6.4 Customer and Delivery Performance

The draft reports:

- Repeat-customer rate: approximately **3.0%**.
- Average delivery time: approximately **12.6 days**.
- Late-delivery rate: approximately **8.1%**, or **7.8K orders**.
- On-time delivery rate: approximately **91.9%**.

**The low repeat-customer rate may indicate that the marketplace relies heavily on acquiring new buyers. However, this is an interpretation of the observed dataset, not proof of the underlying business cause.**

### 6.5 Delivery Analysis: Limitations to Address

The notes identify several important limitations in the current visuals:

- Some locations in the “Slowest 10” chart may have very few orders, making their delivery-time averages unstable.
- Some 50% late-rate values in the decomposition tree may be based on very small samples after filtering.
- Two charts are reportedly labeled as showing states while plotting cities.
- A late delivery relative to the estimated date may reflect either operational delays or an inaccurate estimated date. The dashboard alone does not establish which cause is responsible.

## 7. Potential Business Recommendations

These are hypotheses and recommendations suggested by the analysis, not outcomes proven by the dataset.

1. **Investigate delivery performance in the Northeast and the interior of Rio de Janeiro.** Review carrier coverage, delivery estimates, and last-mile operations before deciding whether to add carriers or local hubs.
2. **Investigate repeat purchasing.** Test post-delivery offers, re-engagement campaigns, and relevant cross-sell strategies. Evaluate their impact rather than assuming a campaign will increase retention.
3. **Evaluate geographic concentration.** São Paulo accounts for a substantial share of reported revenue. Explore whether other regions offer viable growth opportunities while accounting for demand and logistics costs.
4. **Review category performance.** Use the spread of revenue across categories to test category-specific promotions and investigate the long tail of smaller categories.
5. **Analyze payment behavior.** Compare cancellation and completion rates across payment methods before changing payment incentives.
6. **Evaluate freight economics.** Test shipping thresholds or promotions against margin and delivery costs rather than assuming free shipping will be beneficial.


## 8. DEPI and ITC Acknowledgements

- **Team Leader:** Mohamed Sokarno
- **Mentor and Lecturer:** Eman Ghanem
- **ITC_ONL5_Dat3_G3 Operator:** Esraa Yahia
- **ITC CEO:** Mahmoud Raslan

# Thank You