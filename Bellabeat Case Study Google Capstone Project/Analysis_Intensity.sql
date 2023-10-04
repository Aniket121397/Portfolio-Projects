-- Determine Time when users were most active
-- Calculating average intensity for every hour. High intensity or High METs implies more people are physically active during that time.

SELECT
    hourly_activity.activity_time,
    AVG(hourly_activity.TotalIntensity) AS average_intensity,
    AVG(METs.METs / 10.0) AS average_METs
FROM
    (
        SELECT DISTINCT CAST(ActivityHour AS TIME) AS activity_time, Id, TotalIntensity
        FROM bellabeat.dbo.hourly_activity
    ) AS hourly_activity
JOIN bellabeat.dbo.minuteMETsNarrow AS METs
ON
    hourly_activity.Id = METs.Id
    AND DATEPART(HOUR, METs.ActivityMinute) = DATEPART(HOUR, hourly_activity.activity_time)
GROUP BY
    hourly_activity.activity_time
ORDER BY
    average_intensity DESC;


