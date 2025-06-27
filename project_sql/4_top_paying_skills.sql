/* What are the top paying skills
--Look at the average salary associated with each skills for Data Analyst roles.
--Focus on jobs that have a salary specified.
--WHY? Offers insight into most financially rewarding skills to learn or improve..
*/
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