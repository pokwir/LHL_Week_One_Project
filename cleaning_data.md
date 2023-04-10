# What issues will you address by cleaning the data?

Often data sources contain missing rows, contain duplicates, columns that has no observations and invalid data.
During the ETL process, I will address
* Unwanted or redundant columns
* Ensuring accurate data types
* Missing values
* fill in missing values
* Transform units units to common human comprehensible format eg time stamps and dates that are in epoch.




# Queries:
Below, provide the SQL queries you used to clean your data.


---
---
## 1. All sessions table

### a. Redundant Columns

Check multiple columns to see if they dont contain any data
  ```

          select
           		*
          from
          all_sessions
          where
                  (
                	productrefundamount,
                	itemQuantity,
                	itemRevenue,
                	searchKeyword
                  )
          is not null


  ```

 Remove redundant Columns where there's no data

  ```


          ALTER TABLE all_sessions
          DROP COLUMN productrefundamount,
          DROP COLUMN itemQuantity,
          DROP COLUMN itemRevenue,
          DROP COLUMN searchKeyword



```
### b. Removing duplicates

  Check for duplicates
  ```

          select
                fullvisitorid,
        		date,
        		time,
        		visitid,
        		country,
        		pageviews,
        		channelgrouping,
        		v2productname,
        		count(fullvisitorid) as c
        from all_sessions
                      group by
                                fullvisitorid,
                    			date,
                    			time,
                    			visitid,
                    			country,
                    			pageviews,
                    			channelgrouping,
                    			v2productname
                                      	having count(fullvisitorid) >1
                                      	order by fullvisitorid



  ```

  Remove duplicates
  ```


          DELETE FROM
              all_sessions
          WHERE fullvisitorid IN
              (SELECT fullvisitorid
              FROM
                  (SELECT fullvisitorid,
                   ROW_NUMBER() OVER( PARTITION BY
          						   date,
          						   time,
          						   visitid,
          						   country,
          						   pageviews,
          						   channelgrouping
                  ORDER BY fullvisitorid) AS row_num
                  FROM all_sessions ) t
                  WHERE t.row_num > 1 );



  ```
### c. Correct inaccurate data types.
The _visitStartTime_ is text, convert to timestamp

  ```


        ALTER TABLE all_sessions
        ALTER COLUMN time
        TYPE timetz
        USING cast(time as timetz)



```
---

## 2. Analytics Table

### a. Remove redundant Columns
Redundant column here is _UserId_
Checked using the following syntax
```

          select
                *
                  from analytics
                      where userid is not null



  ```

Delete userId column

```

        ALTER TABLE
              analytics
        	         DROP COLUMN
                              userid



```


### b. Removing duplicates
Check multiple columns to see if they dont contain any data

```


          select
          		visitid,
          		visitnumber,
          		visitstarttime,
          		date
          		fullvisitorid,
          		channelgrouping,
          		socialengagementtype,
          		units_sold,
          		pageviews,
          		timeonsite,
          		bounces,
          		revenue,
          		unit_price,
          		count(visitid) as count
          from analytics
          		group by
          			visitid,
          			visitnumber,
          			visitstarttime,
          			date,
          			fullvisitorid,
          			channelgrouping,
          			socialengagementtype,
          			units_sold,
          			pageviews,
          			timeonsite,
          			bounces,
          			revenue,
          			unit_price
          					having count(visitid) >1
          					order by unit_price



```
Delete duplicates

```

        DELETE FROM analytics
        WHERE visitid IN
            (
        		SELECT visitid
            	FROM
                (
        			SELECT visitid,
                 	ROW_NUMBER() OVER( PARTITION BY
        				visitid,
        				visitnumber,
        				visitstarttime,
        				date,visitnumber,
        				fullvisitorid,
        				channelgrouping,
        				socialengagementtype,
        				units_sold,
        				pageviews,
        				timeonsite,
        				bounces,
        				revenue,
        				unit_price
                	ORDER BY visitid) AS row_num
                	FROM analytics
        		) t
               WHERE t.row_num > 1



```
### c. Transform _unit_price_ column to human comprehensible format
The maximum value in the column is 476 Million. The column was divided by 1 Million so that the data is easy to understand. First changes were made to the data type
```
UPDATE
    analytics
      set unit_price = (unit_price / 1000000)

```

### c. Transform _revenue_ column to human comprehensible format
The column was divided by 1 Million so that the data is easy to understand. First changes were made to the data type to reflect double precision.
```
UPDATE
    analytics
      set revenue = (revenue / 1000000)

```

---
## 3. Products Table

### a. check for duplicates
_There were no duplicate_
```
        select sku,
        		name,
        		orderedquantity,
        		stocklevel,
        		restockingleadtime,
        		sentimentscore,
        		sentimentmagnitude,
        		count(sku) as count
        from products
        group by sku,
        		name,
        		orderedquantity,
        		stocklevel,
        		restockingleadtime,
        		sentimentscore,
        		sentimentmagnitude
        	having count(sku) >1
        	order by name


```
### b. Check for redundant Columns
_There were no redundant Columns_

---

## 4. Sales By SKU Table
No data cleaning/ transformation necessary. Everything looks okay.

---

## 4. Sales Report Table
No data cleaning/ transformation necessary. Everything looks okay.
