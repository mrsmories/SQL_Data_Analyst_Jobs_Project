## [README.md](http://README.md) contents:

- Introduction
- Background
- Tools I Used
- The Analysis
- What I Learned
- Conclusions

# **The Readme** ⬇️

### **Introduction**

Welcome to my SQL Portfolio Project, where I delve into the data job market with a focus on data analyst roles. This project is a personal exploration into identifying the top-paying jobs, in-demand skills, and the intersection of high demand with high salary in the field of data analytics.

Check out my SQL queries here: [https://github.com/mrsmories/SQL_Data_Analyst_Jobs_Project/tree/main].

### **Background**

The motivation behind this project stemmed from my desire to understand the data analyst job market better. I aimed to discover which skills are paid the most and in demand, making my job search more targeted and effective. 

The data for this analysis is from [Luke Barousse’s SQL Course](https://www.lukebarousse.com/products/sql-for-data-analytics). This data includes details on job titles, salaries, locations, and required skills. 

The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn for a data analyst looking to maximize job market value?

### Tools I Used

In this project, I utilized a variety of tools to conduct my analysis:

- **SQL** (Structured Query Language): Enabled me to interact with the database, extract insights, and answer my key questions through queries.
- **PostgreSQL**: As the database management system, PostgreSQL allowed me to store, query, and manipulate the job posting data.
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.

### Analysis

Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question: 


## SQL Files

This project contains the following SQL analysis files:

### 📊 [Entry Level Analyst Jobs](./project_sql/1_Entry_analyst_jobs.sql)
Analysis of entry-level data analyst job postings

### 💰 [Top Paying Skills](./project_sql/2_top_paying_skills.sql)
Identification of the highest-paying skills in data analysis

### 🔥 [Most Demanded Skills](./project_sql/3_top_demanded_skills.sql)
Analysis of the most frequently requested skills in job postings

### 💸 [Top Paying Skills Analysis](./project_sql/4_top_paying_skills.sql)
Further analysis of high-paying technical skills

### ⚖️ [Optimal Skills Strategy](./project_sql/5_Optimal_skills.sql)
Finding the optimal balance between skill demand and salary potential


### 1. Entry Level Remote Data Analyst Job
  For the first query I was interested in how many remote jobs there are with Data Analyst in their job title in the 2023 database along with the company names and where the jobs were posted.  I focused on jobs with specified salaries and started at the lower end of the salary range assuming those would be the jobs most accessible to me at the Entry level.
```
sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    job_via,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title LIKE '%Data Analyst%' AND job_location ='Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg;
```

### 2. Skills for Top Paying Jobs
  For this query I wanted to explore what skills are associated with the top paying jobs in the 2023 data set.  As an Entry Level analyst that is still looking to build my skills I am curious about what types of skills are most valuable on the job market.  By first finding the 20 job postings with highest average salaries and connecting to the skills that were highlighted in those postings I want to analyze how many times common skills occur associated with high paying jobs.
```
sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        job_via,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE
        job_title LIKE '%Data Analyst%' AND job_location ='Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 20)
    SELECT 
        top_paying_jobs.*,
        skills

    FROM
        top_paying_jobs
    INNER JOIN
        skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    ORDER BY
        top_paying_jobs.salary_year_avg DESC;

 /*
        --Table of top occuring skills
        | Rank | Skill         | Appearances |
| ---- | ------------- | ----------- |
| 1    | **SQL**       | 17          |
| 2    | **Python**    | 15          |
| 3    | **Tableau**   | 13          |
| 4    | **R**         | 9           |
| 5    | **Excel**     | 5           |
| 6    | **Snowflake** | 5           |
| 7    | **AWS**       | 4           |
| 8    | **Oracle**    | 3           |
| 9    | **Go**        | 3           |
| 10   | **Pandas**    | 3           |
*/
```
The table of results show the number of times each skill occurs in the top 20 highest paying Data Analyst jobs and orders the most popular skills highest to lowest.

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.  The query focuses on all posted Data Analyst jobs and narrows down to the top 5 skills associated with those jobs.
```

sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title LIKE '%Data Analyst%' 
GROUP BY
skills 
ORDER BY
    demand_count DESC       
    LIMIT 5
```

### 4. Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```
sql
SELECT 
    skills,
    skills_dim.type,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title LIKE '%Data Analyst%' AND salary_year_avg IS NOT NULL AND job_location = 'Anywhere'
GROUP BY
skills,
skills_dim.type
ORDER BY
    avg_salary DESC      
    LIMIT 50;
```
### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.  Queries used for previous questions were combined to take this question another step for analysis.
```
sql
      SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title LIKE '%Data Analyst%'
    AND job_work_from_home = TRUE
    AND salary_year_avg IS NOT NULL 
    GROUP BY
        skills_dim.skill_id
    HAVING
        COUNT(skills_job_dim.job_id) > 10
    ORDER BY
        demand_count DESC,
        avg_salary DESC
    LIMIT 40;
```
###***High Demand vs. High Pay Analysis:***
###**Top Skills by Demand:**
1.	SQL (465 postings) - $101,017 avg salary
2.	Python (274 postings) - $104,400 avg salary
3.	Tableau (271 postings) - $102,899 avg salary
4.	Excel (266 postings) - $90,086 avg salary
###**Specialized vs. General Skills:**
###**High-Value Specialized Skills (lower demand, higher pay):**
•	Snowflake (54 postings) - $115,303 avg salary
•	Oracle (37 postings) - $112,966 avg salary
•	Go (36 postings) - $115,843 avg salary
•	Looker (78 postings) - $110,997 avg salary
###**Foundation Skills (high demand, moderate pay):**
•	Excel - Most accessible but lowest paying ($90,086)
•	SQL - Essential foundation skill with solid pay
•	Python/Tableau - Strong balance of demand and salary
###***Market Trends Revealed:***
1.	Cloud/Modern Data Stack Premium: Snowflake, AWS, Azure command higher salaries
2.	Programming Languages: Python and Go show strong salary premiums
3.	Traditional vs. Modern: Excel still in demand but pays less than modern tools
4.	Specialization Pays: Lower-demand specialized skills often pay more per opportunity
###***Career Strategy Implications:***
•	Foundation First: Master SQL, Python, Tableau (high demand + good pay)
•	Specialize for Premium: Add cloud tools (Snowflake, AWS) for salary boost
•	Balance Portfolio: Combine high-demand skills with specialized tools

### **What I Learned**

Throughout this project, I honed several key SQL techniques and skills:

- **Complex Query Construction**: Learning to build advanced SQL queries that combine multiple tables and employ functions like **`WITH`** clauses for temporary tables.
- **Data Aggregation**: Utilizing **`GROUP BY`** and aggregate functions like **`COUNT()`** and **`AVG()`** to summarize data effectively.
- **Analytical Thinking**: Developing the ability to translate real-world questions into actionable SQL queries that got insightful answers.

### **Conclusion**

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.
