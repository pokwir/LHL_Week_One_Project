Answer the following questions and provide the SQL queries used to find the answer.

## Question 1: Which cities and countries have the highest level of transaction revenues on the site?

SQL Queries:
```

			SELECT
				cnty as Country,
				cty as City
			from
				(
				select
					cnty,
					cty,
					cat,
					qtn,
					Revenue,
					rank() over (partition by cty order by qtn desc)
				from
						(		
						select  
									RPT.name as cat,
									ALLS.country as Cnty,
									ALLS.city as Cty,
									sum((RPT.total_ordered)) as Qtn,
									SUM (ANA.unit_price * RPT.total_ordered) as Revenue
							from
									analytics ANA
							join
									All_sessions ALLS
							on
									ALLS.visitid = ANA.visitid
							join
									sales_report RPT
							on
									ALLS.productsku = RPT.productsku
											where RPT.total_ordered >0
											and ALLS.city NOT IN ('not available in demo dataset','(not set)')
											and ALLS.v2productcategory not in ('not available in demo dataset','(not set)')
							group by
									Cnty,
									Cty,
									cat
							ORDER by
									Cnty,
									Cty desc,
									Cat,
									Qtn
							) as Temp
				) as temp2
			where rank =1
			order by Country, city
```

Answer:


![](/Users/patrick/Desktop/Lighthouse_labs/LHL_Week_One_Project/Files/CitiesCountriesHighestTransRev.png)


## Question 2: What is the average number of products ordered from visitors in each city and country?

SQL Queries:
```
Select
	cty as City,
	cnty as Country,
	qtn as AvgQuantity
		FROM
			(select
				cnty,
			 	cty,
				qtn,
			 	rank() over (partition by cty order by qtn desc) as Ranking
				from
				  (		
					select  
						  all_sessions.country as Cnty,
						  all_sessions.city as Cty,
						  avg((RPT.total_ordered)) as Qtn
					  from
						  all_sessions
					  join
						  sales_report RPT
					  on
						  all_sessions.productsku = RPT.productsku
							  where RPT.total_ordered >0
							  and all_sessions.city NOT IN ('not available in demo dataset','(not set)')
							  and all_sessions.v2productcategory not in ('not available in demo dataset','(not set)')
					  group by
						  Cnty,
						  Cty

					  ORDER by
						  Cnty,
						  Cty,
						  Qtn
						) as Temporary
				order by cnty) as Temp2
order by Avgquantity desc
```

Answer:
![](/Users/patrick/Desktop/Lighthouse_labs/LHL_Week_One_Project/Files/AvgPrdtsVisitorsCityCountry.png)

## Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?

Most ordered product categories  by country appear to be coming from metropolitan cities .

![](/Users/patrick/Desktop/Lighthouse_labs/LHL_Week_One_Project/Files/PatternPrdtCategory.png)

SQL Queries:

```
Select * FROM
			(select
				cat,
				cnty,
			 	cty,
				qtn,
			 	rank() over (partition by cty order by qtn desc) as Ranking
				from
				  (		
					select  
						  count (DISTINCT all_sessions.v2productcategory) as Cat,
						  all_sessions.country as Cnty,
						  all_sessions.city as Cty,
						  sum((RPT.total_ordered)) as Qtn
					  from
						  all_sessions
					  join
						  sales_report RPT
					  on
						  all_sessions.productsku = RPT.productsku
							  where RPT.total_ordered >0
							  and all_sessions.city NOT IN ('not available in demo dataset','(not set)')
							  and all_sessions.v2productcategory not in ('not available in demo dataset','(not set)')
					  group by
						  Cnty,
						  Cty

					  ORDER by
						  Cnty,
						  Cty,
						  Cat,
						  Qtn
						) as Temporary
				order by cnty) as Temp2
where ranking =1
```

## Question 4: What is the top-selling product from each city/country? Can we find any pattern worthy of noting in the products sold?

SQL Queries:
```

				SELECT
				cnty as Country,
				cty as City,
				cat as Product,
				qtn as Quantity_sold,
				Revenue as Rev
			from
				(
				select
					cnty,
					cty,
					cat,
					qtn,
					Revenue,
					rank() over (partition by cty order by qtn desc)
				from
						(		
						select  
									RPT.name as cat,
									ALLS.country as Cnty,
									ALLS.city as Cty,
									sum((RPT.total_ordered)) as Qtn,
									SUM (ANA.unit_price * RPT.total_ordered) as Revenue
							from
									analytics ANA
							join
									All_sessions ALLS
							on
									ALLS.visitid = ANA.visitid
							join
									sales_report RPT
							on
									ALLS.productsku = RPT.productsku
											where RPT.total_ordered >0
											and ALLS.city NOT IN ('not available in demo dataset','(not set)')
											and ALLS.v2productcategory not in ('not available in demo dataset','(not set)')
							group by
									Cnty,
									Cty,
									cat
							ORDER by
									Cnty,
									Cty desc,
									Cat,
									Qtn
							) as Temp
				) as temp2
			where rank =1
			order by Country, city

```

Answer:

The top selling product(s) varries by  country and city,. The top selling product is the hard cover journal in two countries and three cities.

![](/Users/patrick/Desktop/Lighthouse_labs/LHL_Week_One_Project/Files/TopSellingPrdts.png)


## Question 5: Can we summarize the impact of revenue generated from each city/country?
SQL Queries:
```
select
	temp3.country,
	temp3.city,
	sum(temp3.Rev) as RevenueByCountry
		from
			(
				SELECT
				cnty as Country,
				cty as City,
				cat as Product,
				qtn as Quantity_sold,
				Revenue as Rev
			from
				(
				select
					cnty,
					cty,
					cat,
					qtn,
					Revenue,
					rank() over (partition by cty order by qtn desc)
				from
						(		
						select  
									RPT.name as cat,
									ALLS.country as Cnty,
									ALLS.city as Cty,
									sum((RPT.total_ordered)) as Qtn,
									SUM (ANA.unit_price * RPT.total_ordered) as Revenue
							from
									analytics ANA
							join
									All_sessions ALLS
							on
									ALLS.visitid = ANA.visitid
							join
									sales_report RPT
							on
									ALLS.productsku = RPT.productsku
											where RPT.total_ordered >0
											and ALLS.city NOT IN ('not available in demo dataset','(not set)')
											and ALLS.v2productcategory not in ('not available in demo dataset','(not set)')
							group by
									Cnty,
									Cty,
									cat
							ORDER by
									Cnty,
									Cty desc,
									Cat,
									Qtn
							) as Temp
				) as temp2
			where rank =1
			order by Country, city
			) as temp3
GROUP BY temp3.country, temp3.city
order by RevenueByCountry desc
``` 	





Answer:
The top performing country is India — brought the most revenue to the site, specifically Bengaluru and New Delhi.


![](/Users/patrick/Desktop/Lighthouse_labs/LHL_Week_One_Project/Files/TopPerfCountry.png)
