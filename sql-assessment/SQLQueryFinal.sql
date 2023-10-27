--Write a query to get the sum of impressions by day
SELECT
    FORMAT(date, 'dddd, MMMM dd, yyyy') AS Date,
    Format(SUM(impressions),'N0','en-us') AS [Total Impressions]
FROM
    marketing_data
GROUP BY
    FORMAT(date, 'dddd, MMMM dd, yyyy')
ORDER BY
    min(date) ASC;

--Write a query to get the top three revenue-generating states in order of best to worst. How much revenue did the third best state generate?

Select Top 3
		state,
		FORMAT(Sum(revenue),'C','en-us') [Total Revenue]
from 
		website_revenue
Group By
		state
Order By sum(revenue) desc;

--Write a query to get the number of conversions of Campaign5 by state.which state generated the most conversions for this campaign?	

Select Top 1
		w.state [State],
		Format(sum(m.conversions),'N0','en-us') as [Total Conversions]
From
	marketing_data m
left Join
	website_revenue w on w.campaign_id= m.campaign_id
where m.campaign_id = 99058240
Group by w.state
Order by sum(m.conversions)desc


--Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.

Select 
	c.name [Campaign Name],
		Format(sum(cost),'C','en-us') as [Total Cost],
		Format(SUM(impressions),'N0','en-us') AS [Total Impressions],
		Format(sum(clicks),'N0','en-us')  [Total Clicks],
		FORMAT(Sum(revenue),'C','en-us') [Total Revenue]
From 
		marketing_data m
		left join campaign_info c on c.id = m.campaign_id 
		left join website_revenue w on w.campaign_id = m.campaign_id
Group by c.name

--In your opinion, which campaign was the most efficient, and why?
--In order to calculate efficiency in campaing we need to apply certain metrics with the information provided. in Marketing campaigns we have a lot of KPI that can be used to measure efficiency for this example we shall use Return on Investment, Click through Rate and Conversion Rate.
Select 
		 
		c.name [Campaign Name],
		[Return on Investment]=CONCAT((format(sum(revenue-cost)/sum(cost),'N2')),'%'),
		[Click Through Rate] = (format(sum(clicks)/sum(impressions),'P')),
		[Conversion Rate] =format((sum(conversions)/sum(clicks)),'P')
From 
		marketing_data m
		left join campaign_info c on c.id = m.campaign_id 
		left join website_revenue w on w.campaign_id = m.campaign_id
Group by c.name;
--Based on the data above , based on the individual metrics provided, "Campaign4," "Campaign5," and "Campaign2" appear to be the most efficient in terms of ROI, CTR, and Conversion Rate, respectively.

--Bonus Question- 
--Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.
--We are going to based our query on the assumption that utlimately conversions are the best matric to measure ads success in a marketing campaign. Based on the result below, Fridays are the best days because we have the highest conversions on that weekday.
SELECT
    DATENAME(weekday, date) AS [Day of the Week],
    FORMAT(SUM(conversions), 'N0', 'en-us') AS [Total Conversions]
FROM
    marketing_data
GROUP BY
    DATENAME(weekday, date)
ORDER BY
    SUM(conversions) desc