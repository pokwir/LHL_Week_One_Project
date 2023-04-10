Question 1: Revenue by traffic source.

SQL Queries:

```
Select
	Cat as Channel,
	qtn as TrnsRev
		FROM
			(select
				cat,
				qtn,
			 	rank() over (partition by cat order by qtn desc) as Ranking
				from
				  (		
					select  

						  DISTINCT all_sessions.channelgrouping as Cat,
						  sum((RPT.total_ordered)) as Qtn


					  from
						  all_sessions
					  join
						  sales_report RPT
					  on
						  all_sessions.productsku = RPT.productsku
							  where RPT.total_ordered >0
							  and all_sessions.city NOT IN ('not available in demo dataset','(not set)')
							  and all_sessions.channelgrouping not in ('not available in demo dataset','(not set)')
					  group by
					  		cat
					  ORDER by
						  Cat,
						  Qtn
						) as Temporary
				order by cat) as Temp2
order by TrnsRev desc

```

Answer:
Refferral is the traffic source with the most revenue.

![](/Users/patrick/Desktop/Lighthouse_labs/LHL_Week_One_Project/Files/TransByTraffic.png)


Question 2: Event Tracking. Which Event(s) generate the most revenue?


SQL Queries:

```
Select
	Cat as Event,
	qtn as TrnsRev
		FROM
			(select
				cat,
				qtn,
			 	rank() over (partition by cat order by qtn desc) as Ranking
				from
				  (		
					select  

						  DISTINCT all_sessions.type as Cat,
						  sum((RPT.total_ordered)) as Qtn


					  from
						  all_sessions
					  join
						  sales_report RPT
					  on
						  all_sessions.productsku = RPT.productsku
							  where RPT.total_ordered >0
							  and all_sessions.city NOT IN ('not available in demo dataset','(not set)')
							  and all_sessions.type not in ('not available in demo dataset','(not set)')
					  group by
					  		cat
					  ORDER by
						  Cat,
						  Qtn
						) as Temporary
				order by cat) as Temp2
order by TrnsRev desc

```

Answer:
Page views seems to be generating more revenue than events like downloading, filling and submitting forms or playing video games.

![](/Users/patrick/Desktop/Lighthouse_labs/LHL_Week_One_Project/Files/RevByEvent.png)


Question 3: Total number of unique visitors that made a purchase

SQL Queries:

```
select
  count(fullvisitorid)
from all_sessions
where
    ecommerceaction_step <=1
    and
      ecommerceaction_step is not null

```

Answer:

14,641
