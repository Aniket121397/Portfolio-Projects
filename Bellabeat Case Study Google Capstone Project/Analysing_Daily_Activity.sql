-- Calculate the number of Days for each user tracking physical activity

SELECT DISTINCT ID, days_activity_recorded
FROM (
	   SELECT ID, Count(ActivityDate) AS days_activity_recorded
	   FROM bellabeat.dbo.daily_activity_cleaned
	   GROUP BY ID
	 ) AS Subquery
ORDER BY days_activity_recorded DESC;

-- Calculate average minutes for each activity

SELECT
	ROUND(AVG(VeryActiveMinutes),2) AS AverageVeryActiveMinutes,
	ROUND(AVG(FairlyActiveMinutes),2) AS AverageFailyActiveMinutes,
	ROUND(AVG(LightlyActiveMinutes)/60.0,2) AS AverageLightlyActiveHours,
	ROUND(AVG(SedentaryMinutes)/60.0,2) AS AverageSedentaryHours

FROM	
	bellabeat.dbo.daily_activity_cleaned

