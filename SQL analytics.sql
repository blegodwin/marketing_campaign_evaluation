-- create database from csv containing data set
CREATE DATABASE campaign;

-- Create the table with appropriate columns
CREATE TABLE campaigns (
    campaign_id SERIAL PRIMARY KEY,
    company TEXT NOT NULL,
    campaign_type TEXT NOT NULL,
    target_audience TEXT NOT NULL,
    duration INTEGER NOT NULL,
    channels_used TEXT NOT NULL,
    conversion_rate NUMERIC(5, 2) NOT NULL, 
    acquisition_cost NUMERIC(10, 2) NOT NULL, 
    roi NUMERIC(10, 2) NOT NULL, 
    location TEXT NOT NULL,
    language TEXT NOT NULL,
    clicks INTEGER NOT NULL,
    impressions INTEGER NOT NULL,
    engagement_score INTEGER NOT NULL, 
    customer_segment TEXT NOT NULL,
    date DATE NOT NULL
);

-- Import/Export Data Dialog used to inport csv

-- SQL Analytics
SELECT * FROM campaigns
LIMIT 10;

-- Revenue Metrics

/* calculating Total Revenue
assuming each click/impression generates a fixed revenue of $1 per click: */

SELECT 
    Company, 
    Campaign_Type, 
    SUM(Clicks) * 1 AS Total_Revenue -- assuming $1 revenue per click
FROM campaigns
GROUP BY Company, Campaign_Type;

-- campaign cost for each company
SELECT 
    Company, 
    Campaign_Type, 
    SUM(Acquisition_Cost) AS Total_Campaign_Cost
FROM campaigns
GROUP BY Company, Campaign_Type;

-- Average ROI for each company
SELECT 
    Company, 
    Campaign_Type, 
    AVG(ROI) AS Average_ROI
FROM campaigns
GROUP BY Company, Campaign_Type
ORDER BY Average_ROI DESC;

-- Weighted ROI
SELECT 
    Company, 
    Campaign_Type, 
    SUM(ROI * Acquisition_Cost) / SUM(Acquisition_Cost) AS Weighted_Average_ROI
FROM campaigns
GROUP BY Company, Campaign_Type
ORDER BY Weighted_Average_ROI DESC;

-- Average conversion rate
SELECT 
    Company, 
    Campaign_Type, 
    AVG(Conversion_Rate) AS Avg_Conversion_Rate
FROM campaigns
GROUP BY Company, Campaign_Type;

-- engagement score
SELECT 
    Company, 
    Campaign_Type, 
    AVG(Engagement_Score) AS Avg_Engagement_Score
FROM campaigns
GROUP BY Company, Campaign_Type;

-- identfying campaigns with the lowest and highest ROI
SELECT 
    Company, 
    Campaign_Type, 
    roi
FROM campaigns
ORDER BY ROI DESC
LIMIT 5; -- Top 5 campaigns with highest ROI

SELECT 
    Company, 
    Campaign_Type,
    roi
FROM campaigns
ORDER BY ROI ASC
LIMIT 5; -- top 5 campaigns with lowest ROI

-- dropping the existing view if it exists
DROP VIEW IF EXISTS computation;
-- creating a view
CREATE VIEW computation AS

SELECT 
    Company, 
    Campaign_Type, 
    ROI,
    Acquisition_Cost AS Total_Campaign_Cost,
    Clicks AS Total_Clicks,
    (ROI * Acquisition_Cost + Acquisition_Cost) AS Total_Revenue,
    (ROI * Acquisition_Cost + Acquisition_Cost) / Clicks AS Revenue_Per_Click
FROM campaigns;

-- identify most effective campaigns
SELECT 
    Company, 
    Campaign_Type,
    ROI
FROM campaigns
ORDER BY ROI DESC
LIMIT 5; -- top 5 campaigns with highest ROI
