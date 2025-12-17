For the analysis, I used four tables: dailyActivity_merged, dailyCalories_merged, dailyIntensities_merged, and dailySteps_merged. I chose them because they all have the same "Id" and "ActivityDate" columns. I used these columns to join the tables and make sure the data was the same.

SELECT activity.calories,
calories.calories
FROM `composite-rhino-472219-m9.BellaBeat.dailyActivity_merged` activity
INNER JOIN `composite-rhino-472219-m9.BellaBeat.dailyCalories_merged` calories
ON activity.id = calories.id
AND activity.ActivityDate = calories.ActivityDay


SELECT activity.SedentaryMinutes,
intensities.SedentaryMinutes
FROM `composite-rhino-472219-m9.BellaBeat.dailyActivity_merged` activity
INNER JOIN `composite-rhino-472219-m9.BellaBeat.dailyIntensities_merged` intensities
ON activity.id = intensities.id
AND activity.ActivityDate = intensities.ActivityDay


SELECT activity.TotalSteps,
steps.StepTotal
FROM `composite-rhino-472219-m9.BellaBeat.dailyActivity_merged` activity
INNER JOIN `composite-rhino-472219-m9.BellaBeat.dailySteps_merged` steps
ON activity.id = steps.id
AND activity.ActivityDate = steps.ActivityDay


I checked the number of unique users using the COUNT(DISTINCT id) function.

SELECT COUNT(DISTINCT id) AS unique_id
FROM `composite-rhino-472219-m9.BellaBeat.dailyActivity_merged`

I wanted to see how often each user logged into the system. I used a COUNT(id) query grouped by ID:

SELECT id,
COUNT(id) AS total_id
FROM composite-rhino-472219-m9.BellaBeat.dailyActivity_merged
GROUP BY id

I divided this range into four equal groups to categorize the users:

SELECT id,
COUNT(id) AS total_uses,
CASE
WHEN COUNT(id) BETWEEN 4 AND 10 THEN "sedentary user"
WHEN COUNT(id) BETWEEN 11 AND 17 THEN "casual user"
WHEN COUNT(id) BETWEEN 18 AND 24 THEN "active user"
WHEN COUNT(id) BETWEEN 25 AND 31 THEN "power user"
END AS user_classification
FROM composite-rhino-472219-m9.BellaBeat.dailyActivity_merged
GROUP BY id


I checked the minimum, maximum, and average values for steps, calories, total distance, and other metrics.

SELECT id,
ROUND(MIN(TotalSteps), 2) AS min_total_steps,
ROUND(MAX(TotalSteps), 2) AS max_total_steps,
ROUND(AVG(TotalSteps), 2) AS avg_total_steps,
ROUND(MIN(TotalDistance), 2) AS min_total_distance,
ROUND(MAX(TotalDistance), 2) AS max_total_distance,
ROUND(AVG(TotalDistance), 2) AS avg_total_distance,
ROUND(MIN(Calories), 2) AS min_calories,
ROUND(MAX(Calories), 2) AS max_calories,
ROUND(AVG(Calories), 2) AS avg_calories,
ROUND(MIN(VeryActiveMinutes), 2) AS min_very_active_minutes,
ROUND(MAX(VeryActiveMinutes), 2) AS max_very_active_minutes,
ROUND(AVG(VeryActiveMinutes), 2) AS avg_very_active_minutes,
ROUND(MIN(FairlyActiveMinutes), 2) AS min_fairly_active_minutes,
ROUND(MAX(FairlyActiveMinutes), 2) AS max_fairly_active_minutes,
ROUND(AVG(FairlyActiveMinutes), 2) AS avg_fairly_active_minutes,
ROUND(MIN(LightlyActiveMinutes), 2) AS min_lightly_active_minutes,
ROUND(MAX(LightlyActiveMinutes), 2) AS max_lightly_active_minutes,
ROUND(AVG(LightlyActiveMinutes), 2) AS avg_lightly_active_minutes,
ROUND(MIN(SedentaryMinutes), 2) AS min_sedentary_minutes,
ROUND(MAX(SedentaryMinutes), 2) AS max_sedentary_minutes,
ROUND(AVG(SedentaryMinutes), 2) AS avg_sedentary_minutes,
FROM composite-rhino-472219-m9.BellaBeat.dailyActivity_merged
GROUP BY id
ORDER BY id

I also looked at the average number of minutes spent on active movements.

SELECT id,
ROUND(AVG(VeryActiveMinutes), 2) AS avg_very_active_minutes,
ROUND(AVG(FairlyActiveMinutes), 2) AS avg_fairly_active_minutes,
ROUND(AVG(LightlyActiveMinutes), 2) AS avg_lightly_active_minutes,
ROUND(AVG(SedentaryMinutes), 2) AS avg_sedentary_minutes,
FROM composite-rhino-472219-m9.BellaBeat.dailyActivity_merged
GROUP BY id
ORDER BY 2, 3, 4, 5 DESC

I decided to change my query slightly and check on which days of the week users are more active or inactive.

SELECT FORMAT_DATE("%A", ActivityDate) AS day_of_the_week,
ROUND(AVG(VeryActiveMinutes), 2) AS avg_very_active_minutes,
ROUND(AVG(FairlyActiveMinutes), 2) AS avg_fairly_active_minutes,
ROUND(AVG(LightlyActiveMinutes), 2) AS avg_lightly_active_minutes,
ROUND(AVG(SedentaryMinutes), 2) AS avg_sedentary_minutes
FROM `composite-rhino-472219-m9.BellaBeat.dailyActivity_merged`
GROUP BY day_of_the_week
ORDER BY 2, 3, 4, 5 DESC


I checked the average values for steps, distance, and calories for each day of the week.

SELECT FORMAT_DATE("%A", ActivityDate) AS day_of_the_week,
ROUND(AVG(TotalSteps), 2) AS avg_total_steps,
ROUND(AVG(TotalDistance), 2) AS avg_total_distance,
ROUND(AVG(Calories), 2) AS avg_calories
FROM `composite-rhino-472219-m9.BellaBeat.dailyActivity_merged`
GROUP BY day_of_the_week
ORDER BY 2 DESC

I decided to use it to compare the number of calories burned with the time spent on these activities.

SELECT dailyactivity.id AS dailyactivity_id,
calories.id AS calories_id,
COUNT(dailyactivity.calories) AS dailyactivity_calories,
COUNT(calories.calories) AS total_hourly_calories
FROM `composite-rhino-472219-m9.BellaBeat.dailyActivity_merged` dailyactivity
LEFT JOIN `composite-rhino-472219-m9.BellaBeat.hourlyCalories_merged` calories
ON dailyactivity.id = calories.id
GROUP BY dailyactivity.id, calories.id






