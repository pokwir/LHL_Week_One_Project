--Question 1: Which cities and countries have the highest level of transaction revenues on the site?

--inner join revenue on all sessions 
-- select county, cities, revenue
--select max revenue, partition by cities and country

-- select 
-- 	all_sessions.city as a, 
-- 	all_sessions.country as b, 
-- 	sum(totaltransactionrevenue) as c
-- from all_sessions
-- --full outer join all_sessions as e on e.visitid = analytics.visitid
-- group by a, b


select 
		city,
		country, 
		sum(totaltransactionrevenue)
from all_sessions
group by city
order by country






-- select * from sales_by_sku
-- where productsku = (select productsku from all_sessions
-- where transactionrevenue = (select max(all_sessions.transactionrevenue) from all_sessions))

-- select productsku as p, total_ordered from sales_report
-- where productsku  = (select productsku from all_sessions
-- where transactionrevenue = (select max(all_sessions.transactionrevenue) from all_sessions))

-- select * from analytics
-- where units_sold is not null

-- select * from all_sessions where totaltransactionrevenue is not null
