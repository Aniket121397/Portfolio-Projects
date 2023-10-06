# Case Study : Bellabeat Fitness Data Analysis 
##### Author: Aniket Panpatil

##### Date: October 4, 2023

_The case study follows the six step data analysis process:_

### ❓ [Ask](#1-ask)
### 💻 [Prepare](#2-prepare)
### 🛠 [Process](#3-process)
### 📊 [Analyze](#4-analyze)
### 📋 [Share](#5-share)
### 🧗‍♀️ [Act](#6-act)

## Scenario
You are a junior data analyst working on the marketing analyst team at Bellabeat, a high-tech manufacturer of health-focused products for women. Bellabeat is a successful small company, but they have the potential to become a larger player in the global smart device market. Urška Sršen, cofounder and Chief Creative Officer of Bellabeat, believes that analyzing smart device fitness data could help unlock new growth opportunities for the company. You have been asked to focus on one of Bellabeat’s products and analyze smart device data to gain insight into how consumers are using their smart devices. The insights you discover will then help guide marketing strategy for the company. You will present your analysis to the Bellabeat executive team along with your high-level recommendations for Bellabeat’s marketing strategy.

## About the Company
Urška Sršen and Sando Mur founded Bellabeat, a high-tech company that manufactures health-focused smart products. Sršen used her background as an artist to develop beautifully designed technology that informs and inspires women around the world. Collecting data on activity, sleep, stress, and reproductive health has allowed Bellabeat to empower women with knowledge about their own health and habits. Since it was founded in 2013, Bellabeat has grown rapidly and quickly
positioned itself as a tech-driven wellness company for women. By 2016, Bellabeat had opened offices around the world and launched multiple products. Bellabeat products became available through a growing number of online retailers in addition to their own e-commerce channel on their website. The companyhas invested in traditional advertising media, such as radio, out-of-home billboards, print, and television, but focuses on digital marketing extensively. Bellabeat invests year round in Google Search, maintaining active Facebook and Instagram pages, and consistently engages consumers on Twitter. Additionally, Bellabeat runs video ads on Youtube and display ads on the Google Display Network to support campaigns around key marketing dates. Sršen knows that an analysis of Bellabeat’s available consumer data would reveal more opportunities for growth. She has asked the marketing analytics team to focus on a Bellabeat product and analyze smart device usage data in order to gain insight into how people are already using their smart devices. Then, using this information, she would like high-level recommendations for how these trends can inform Bellabeat marketing strategy .

## 1. Ask
**Business Task** :
Sršen asks you to analyze smart device usage data in order to gain insight into how consumers use non-Bellabeat smart devices. She then wants you to select one Bellabeat product to apply these insights to in your presentation.
- What are some trends in smart device usage?
- How could these trends apply to Bellabeat customers?
- How could these trends help influence Bellabeat marketing strategy?

## 2. Prepare
To answer Bellabeat's business tasks I will be using [FitBit Fitness Tracker Data](https://www.kaggle.com/datasets/arashnic/fitbit) (CC0: Public Domain, dataset made available through Mobius): This Kaggle data set contains personal fitness tracker from thirty fitbit users. Thirty eligible Fitbit users consented to the submission of personal tracker data, including minute-level output for physical activity, heart rate, and sleep monitoring. It includes information about daily activity, steps, and heart rate that can be used to explore users’ habits.

I have used  Excel Power Query Editor to merge multiple Excel files and Microsoft SQL Server Management Studio for this project to help process and analyze and for visualization I have used Tableau Public. In order to solve this business task, only 9 of the given 18 datasets were used.

The following CSV files were focused on.
- dailyActivity_merged
- heartrate_seconds_merged
- minutesMETsNarrow_merged
- minuteSleep_merged
- sleepDay_merged
- weightLogInfo_merged
- dailyCalories_merged
- dailyIntensities_merged
- dailySteps_merged

The 3 CSV files - dailyCalories_merged , dailyIntensities_merged , dailySteps_merged were merged into 1 CSV file called as Hourly_activity using Excel Power Editor.

## 3. Process
Examine the data , I found that the data in the daily_activity and weightLoginfo_merged were not in correct format to perform calculations. So I created a new table and using the CAST function converted all the required data formats into correct formats.

For cleaning the daily_activity , I wrote the following code in Microsoft SSMS
```
IF EXISTS(SELECT *
		   FROM bellabeat.dbo.daily_activity_cleaned)

DROP TABLE bellabeat.dbo.daily_activity_cleaned
		   
CREATE TABLE bellabeat.dbo.daily_activity_cleaned
(
    ID FLOAT,
    ActivityDate DATETIME2(7),
    TotalSteps INT,
    TotalDistance FLOAT,
    VeryActiveDistance FLOAT,
    ModeratelyActiveDistance FLOAT,
    LightActiveDistance FLOAT,
    SedentaryActiveDistance FLOAT,
    VeryActiveMinutes INT,
    FairlyActiveMinutes INT,
    LightlyActiveMinutes INT,
    SedentaryMinutes INT,
    Calories FLOAT
);

INSERT INTO bellabeat.dbo.daily_activity_cleaned
(
    ID,
    ActivityDate,
    TotalSteps,
    TotalDistance,
    VeryActiveDistance,
    ModeratelyActiveDistance,
    LightActiveDistance,
    SedentaryActiveDistance,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    SedentaryMinutes,
    Calories
)
SELECT
    ID,
    CAST(CONVERT(DATETIME2, ActivityDate, 101) AS DATETIME2) AS ActivityDate,
    TotalSteps,
    CAST(TotalDistance AS FLOAT) AS TotalDistance,
    CAST(VeryActiveDistance AS FLOAT) AS VeryActiveDistance,
    CAST(ModeratelyActiveDistance AS FLOAT) AS ModeratelyActiveDistance,
    CAST(LightActiveDistance AS FLOAT) AS LightActiveDistance,
    CAST(SedentaryActiveDistance AS FLOAT) AS SedentaryActiveDistance,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    SedentaryMinutes,
    Calories
FROM
    bellabeat.dbo.dailyActivity;
```
For weightLoginfo , I wrote the following code in Microsoft SSMS
```
IF EXISTS (SELECT * 
		   FROM bellabeat.dbo.weight_cleaned)

DROP TABLE bellabeat.dbo.weight_cleaned

CREATE TABLE bellabeat.dbo.weight_cleaned
( Id FLOAT , 
  Date DATETIME2(7),
  WeightKg FLOAT)
  
INSERT INTO bellabeat.dbo.weight_cleaned

SELECT
	Id,
	Date,
	WeightKg

FROM bellabeat.dbo.weightLogInfo
```
