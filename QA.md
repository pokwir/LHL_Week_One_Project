What are your risk areas? Identify and describe them.

1. Duplicates — The data set especially the All_sessions table had quite a number of duplicates.
2. Missing data that skews the analysis - the all_sessions table had fields in country and city that were "not available in demo dataset" or "(not set)"


QA Process:
Describe your QA process and include the SQL queries used to execute it.

1. Assertion. Checking if the primary key field values contain null values. In the all_sessions table, I checked the visit fullVisitorID for null values.

```

select
	fullVisitorID  as id,
	country as cnty

from all_sessions
where fullVisitorID  is null

```
2. Checking field values. Here I checked for fullVisitorID, Country, and City.

```
select
	fullVisitorID  as id,
	country as cnty,
	city as cty

from all_sessions
where fullVisitorID  is null
	and
		country is null
	and city is null
```

3. Checking unique fields - In the products table, the primary key "SKU" must be unique since each product can only contain a single SKU.

  This query should also be able to point out 'Null' SKU.

```

select
		sku,
		count(sku) as Dist
from products
group by sku
Having count(sku) >1

```

4. Cleaning the Tables.
The steps/ queries outlined in the cleaning data portion of the is then run.

  _See Part 2: Data Cleaning_

  1. Deleting Duplicates
  2. Removing redundant Columns
  3. Correcting data types for analysis. 
