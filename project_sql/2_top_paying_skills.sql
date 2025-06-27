/*--What are the top skills listed with the highest paying Data Analyst roles?
*/
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