--Calculating number of users and averages

-- 1) Tracking their physical activities

SELECT 
	COUNT(DISTINCT(Id)) AS users_tracking_activity,
	AVG(TotalSteps) AS average_steps,
	AVG(TotalDistance) AS average_distance,
	AVG(Calories) AS average_calories
FROM bellabeat.dbo.daily_activity_cleaned

--2) Tracking heart rate

SELECT 
	COUNT(DISTINCT(Id)) AS users_tracking_heartrate,
	AVG(Value) AS average_heartrate,
	MIN(Value) AS min_heartrate,
	MAX(Value) AS max_heartrate
FROM bellabeat.dbo.heartrate_seconds

--3) Tracking Sleep

SELECT 
	COUNT(DISTINCT(Id)) AS users_tracking_sleep,
	AVG(TotalMinutesAsleep)/60.0 AS avg_hours_sleep,
	MIN(TotalMinutesAsleep)/60.0 AS min_hours_sleep,
	MAX(TotalMinutesAsleep)/60.0 AS max_hours_sleep,
	AVG(TotalTimeInBed)/60.0 AS average_hours_inBed

FROM bellabeat.dbo.sleep_day

--4) Tracking weight

SELECT 
	COUNT(DISTINCT(Id)) AS users_tracking_weight
FROM bellabeat.dbo.weight_cleaned	


