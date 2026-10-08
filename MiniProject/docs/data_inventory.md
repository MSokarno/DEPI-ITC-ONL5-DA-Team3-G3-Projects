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
