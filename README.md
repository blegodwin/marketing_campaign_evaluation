## Table of Contents
1. [Project Overview](#project-overview)
2. [Introduction](#introduction)
3. [Objectives](#objectives)
4. [Data Source](#data-soucre)
5. [Data Validation and Augumentation](#data-validation-and-augumentation)
6. [Descriptive Analysis](#descriptive-analysis)
7. [SQL Queries and Data Retrieval](#sql-queries-and-data-retrieval)
8. [Attributed Analysis](#attributed-analysis)
9. [Ad-Hoc Analyses](#ad-hoc-analyses)
10. [Dashboard Visualsation](#dashboard-visualsation)
11. [Insights](#insights)
12. [Strategic Reccommendation](#strategic-reccommendation)
13. [Conclusion](#conclusion)

## Project Overview

This project involved the comprehensive analysis of marketing campaign data for a Phantom firm, focusing on identifying the most effective campaigns, optimizing funding, and providing actionable insights for future marketing strategies for its top 5 clients. The analysis was conducted using Excel, SQL and Tableau, leveraging marketing campaign data to ensure accuracy and relevance.
The project plan and problem statement can be found here [project plan](project_pllan.PDF)
An interactive version of the dashboard visualisation has been pubished on [Tableau Public.](https://public.tableau.com/app/profile/blessing.godwin3292/viz/campaign_17224191582780/Dashboard1?publish=yes)

## Introduction

A Phantom Firm, a leading marketing agency, manages campaigns for multiple clients across various channels and strategies. In an effort to enhance customer satisfaction and financial efficiency, the firm aims to prioritise quality over quantity by streamlining campaigns for its top 5 clients. The primary objective is to identify and continue funding the most profitable campaigns while defunding the less successful ones. This initiative requires a comprehensive analysis of the return on investment (ROI) for the different marketing campaigns launched in 2021, assessing their financial impact and effectiveness to make informed decisions about resource allocation. 

## Objectives

1.	Financial Metrics and KPI Definition: Define and track financial and marketing metrics (Total Revenue, Acquisition Cost, Total Clicks) and KPIs (Conversion Rate, ROI) to measure campaign success.
2.	Comprehensive ROI Evaluation: Analyze the ROI for different marketing campaigns across Phantom Firm's top 5 clients to determine profitability.
3.	Campaign Effectiveness Comparison: Compare the effectiveness of campaigns in driving conversions and engagement, identifying the most impactful strategies.
4.	Optimizing Resource Allocation: Identifying high-ROI campaigns and reallocating resources from less effective ones.
5.	Supporting Strategic Decisions: Providing actionable insights through comprehensive data analysis.


## Data Source

This dataset was collected from Kaggle. The [Marketing Campaign Performance Dataset](https://www.kaggle.com/datasets/manishabhatt22/marketing-campaign-performance-dataset). This dataset captures the performance metrics, target audience, duration, channels used, and other essential factors that contribute to the success of marketing initiatives at a Phantom firm. With 200000 unique rows of data spanning a year, across diverse companies and customer segments.

License: [CC0: Public Domain](https://creativecommons.org/publicdomain/zero/1.0/)

Note: This is a fictional dataset. The Introduction and firm name are provided for smooth story telling.

## Data Validation and Augumentation

The following steps were taken to assess the data quality and ensure data completeness and accuracy before analysis in Excel:
 - **Data cleaning and accessment:** The data was accessed for missing data and duplicates. The data types were set. The dataset was filtered and inconsistencies in spelling assessed.

-**Verification of ROI:** To verify the ROI column provided for accuracy, Revenue and Revenue Per Click (RPC) data were recovered using formulas. 

-**Data Augumentation:** The Revenue and RPC columns were calculated for using formulas and autofill and computed using:
    - Total Revenue = (Conversion Rate / 100) * Clicks
    - Revenue_per_click = (Total_Revenue) / (Total_Clicks)
    - ROI = ( Revenue - Acquisition Cost) / Acquisition Cost

## Descriptive Analysis:

- Exploratory data analysis (EDA) was performed using summary statistics on MS Excel  to understand data distribution and relationships.
- Charts, graphs, formulas and statistical tools were used to visualise and understand the dataset.


## SQL Queries and Data Retrieval
PostgreSQL was used via pgAdmin to create a denormalised database containing data points from the csv data file. The data was not normalised as the data was a static data with seldom updates.
SQL queries were written to retrieve and analyse the appropriate data. These queries were designed to:

- Extract relevant metrics and dimensions from the dataset.
- Perform complex calculations and aggregations to derive key insights.
- Optimize performance and ensure efficient data retrieval.

1. Create Database
```sql
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
```

2. To create a view of computed Total Revenue and Revenue Per Click fields
```sql
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
```

3. Create calculation query for weighted ROI
```sql
-- Weighted ROI
SELECT 
    Company, 
    Campaign_Type, 
    SUM(ROI * Acquisition_Cost) / SUM(Acquisition_Cost) AS Weighted_Average_ROI
FROM campaigns
GROUP BY Company, Campaign_Type
ORDER BY Weighted_Average_ROI DESC
LIMIT 5;
```

|company                   |   campaign_type      |weighted_average_roi           |
|--------------------------|----------------------|--------------|
|DataTech Solutions        |   Display            |  5.04        |
|Alpha Innovations         |   Influencer         |  5.03        |
|TechCorp                  |   Influencer         | 5.03         |
|DataTech Solutions        |   Search             | 5.02         |
|Innovate Industries       |   Display            |  5.02        |

4. Analysis query sample snippet

```sql
-- identfying campaigns with the lowest and highest ROI
SELECT 
    Company, 
    Campaign_Type, 
    ROI
FROM campaigns
ORDER BY ROI DESC
LIMIT 5; -- Top 5 campaigns with highest ROI
```
|company                   |   campaign_type      |roi          |
|--------------------------|----------------------|-------------|
|NexGen Systems            |   Search             |  8          |
|Alpha Innovations         |   Display            |  8          |
|Innovate Industries       |   Influencer         |  8          |
|NexGen Systems            |   1Display           |  8          |
|TechCorp                  |   Social Media       |  8          |

```sql
SELECT 
    Company, 
    Campaign_Type,
    roi
FROM campaigns
ORDER BY ROI ASC
LIMIT 5; -- Top 5 campaigns with lowest ROI
```


|company                   |   campaign_type      |roi           |
|--------------------------|----------------------|--------------|
|TechCorp                  |   Display            |  2.00        |
|TechCorp                  |   Social Media       |  2.00        |
|NexGen Systems            |   Display            | 2.00         |
|Alpha Innovations         |   Display            | 2.00         |
|Alpha Innovations         |   Email              |  2.00        |


The SQL queries used in the project can be found in the [SQL analytics](SQL_analytics.sql) file. [File Name](filename.ext)

## Attribution Analysis

Dashboard reports were created and maintained in Tableau to provide real-time insights into the performance of various marketing campaigns. These dashboards featured:

- **Metrics**: Financial metrics(Revenue, Return on Investment, Cost of Acquisition) and marketing metrics (Impressions, Clicks)
- **Key Performance Indicators (KPIs):** Metrics such as average ROI, conversion rate, and click through rate.
- **Calculated Field:** Calculated fields such as Click through rate (CTR). 
- **Visualisations:** Charts and graphs to illustrate trends and comparisons across different campaign types, channels and companies.
- **Attribution:** Contribution of different campaign channels and types, metrics and KPIs to overall success.
- **Interactive Elements:** Filters and selectors to allow stakeholders to drill down into specific data points and time periods.

## Ad-Hoc Analyses

Ad-hoc analyses were performed to identify trends and patterns in the dataset. These analyses were conducted in response to specific business questions or observed anomalies. The results were presented to respective teams, providing insights into:

- **Campaign Performance:** Identifying which campaigns were driving the most conversions and engagement.
- **Target Audience Interaction:** Analysing the most effective campaign channels for campaigns and target audience.
- **Financial Implications:** Assessing the cost-effectiveness of different marketing strategies.


## Dashboard Visualisation

This section showcases the dashboard that provides insights into marketing campaign performance.

![Dashboard](marketing/dashboard.png)


## Insights

1. **High ROI Companies and Campaign Types:**
- Alpha Innovations, Data Technology Solutions, and TechCorp stand out with a high ROI of 5.01, indicating they are achieving 500% profits on their marketing investments.
- Display, Influencer, and Search campaign types have the highest ROI, suggesting these are the most profitable channels across different companies.

2. **Duration and ROI:**
- There is no clear correlation between the duration of a campaign and its ROI, indicating that longer campaigns do not necessarily result in higher profits.

3. **Company-Specific Insights:**
- *Alpha Innovations:* Display campaigns are most profitable, while Influencer campaigns lag. The effectiveness of the campaign type based on the campaign with the least acquisition cost and highest return rate, Display leads, followed closely by Search. Search and Email through Websites and Facebook had the Highest conversion rate with a sum of 224 leads. 

- *DataTech Solutions:* Email and Social Media campaigns are highly profitable as they generated significant ROI for DataTech Solutions at an average of 4 and 5 times the profit, especially for women aged 25-34. Whereas Display campaigns underperform. Influencer and Search campaign types drove the most conversion rate at an aggregate of 334 leads via Email, Google Ads and Website campaign channels.
The effectiveness of the campaign type based on the campaign with the least acquisition cost and highest return rate was Display and Influencers, followed closely by Social Media.

- *Innovate Industries:* Social Media and Influencer campaigns excel, with Display being less effective overall but still significant for certain demographics. Instagram was the campaign channel that drove the most conversion rate for Display and Influencer campaign type. Followed by Email and Website for Search and Social Media campaign type at a sum of 449 leads.
The effectiveness of the campaign type based on the campaign with the least acquisition cost and highest return rate, Social Media and Influencer types take the lead, Display type was the least effective.

- *NextGen Systems:* Email and Display are top performers but was less effective compared to other campaigns for women 35-44, while Search campaigns excel in specific demographics. Influencer and Email campaign type were successful with the least acquisition cost and resulted resulted in high conversion rate.

- *TechCorp:* Consistently high ROI in Email and Display campaigns, with Influencer campaigns being less effective overall but still valuable for targeted demographics. Google Ads was the most effective campaign channel for every campaign type at 446. Followed closely is YouTube and Email campaign channels.

4. **Channel Effectiveness:**
- Instagram is particularly effective for Display and Influencer campaigns.
- Google Ads and YouTube lead in conversion rates, especially for Search and Social Media campaigns.

5. **Demographic Insights:**
Demographic-specific performance varies, with Email and Social Media showing strong results for younger demographics and Display being more effective for other segments.
- *Women 35-44:* Display and Social Media campaigns are particularly effective.
- *Men 25-34:* Display and Social Media campaigns yield high profits.
- *Women 34-45:* Influencer campaigns perform well.


## Strategic Reccomendations

1. Investigate why Display campaigns are prioritized over Email despite Email's potential. Either increase investment in Display if justified or reconsider Email's role in the strategy.

2. Focus on campaigns with low acquisition costs and high returns. Continue to fund campaigns like Display and Search that provide high ROI and low acquisition costs.

3. Increase personalization in campaigns to improve engagement and conversion rates. Tailor messaging and offers to specific audience segments based on their preferences and behaviors. Invest in high-quality content that resonates with the target audience. Use insights from successful campaigns to guide content creation and strategy.

4. Continue leveraging Instagram for Display and Influencer campaigns and Google Ads for Search and Social Media campaigns.  Evaluate the performance of other channels and adjust strategies accordingly.

5. Underperforming campaigns, such as certain Display and Email efforts, should be closely monitored and optimized. If they cannot be improved, reassess the allocation of resources, consider reallocating budget to more effective channels for these demographics or campaign types.

6. Tailor campaigns more precisely to demographic segments that show higher responsiveness and profitability, such as specific age and gender groups.

**Proposed Campaigns to Continue Funding:**
- **Search campaigns** exhibit high ROI and conversion rates, especially when aggregated. They are effective across various channels and demographics. 
- **Email campaigns** generate significant ROI and high conversion rates, particularly for younger demographics and for certain clients like DataTech Solutions.
- **Social Media campaign**s demonstrate good ROI and are effective in driving engagement and conversions. They are particularly strong for specific demographics and channels.
Continue or even increase funding for search campaigns. They offer high returns and perform well across different target audience and channels.

**Proposed Campaigns to Defund:**
- **Influencer campaigns** generally show lower ROI compared to other types. While they perform well in specific demographics, the overall ROI is lower, and they are less cost-effective.
- **Display Campaigns (for Specific Demographics:** While display campaigns have a high ROI overall, they are less effective for certain demographics like women aged 35-44. Additionally, display campaigns for TechCorp show a lower ROI in some contexts. Reassess the allocation of resources for display campaigns targeted at less profitable demographics. Consider reallocating budget to more effective demographics or campaign types.

## Conclusion

This project provided a comprehensive analysis of Phantom Firm's marketing campaigns, offering valuable insights and actionable recommendations. The key responsibilities outlined above ensured that the analysis was thorough, accurate, and aligned with the business needs. The outcomes of this project will help Phantom Firm optimize their marketing strategies and achieve better results in future campaigns. 