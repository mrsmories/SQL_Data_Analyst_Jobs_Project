/*
--Top paying data analyst jobs?
--Identify data analyst jobs in the US available remotely.
--Focuses on postings with specified salaries (removes NULLS)
--WHY? Offers insight into companies hiring data analysts and their salary offerings.
*/

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