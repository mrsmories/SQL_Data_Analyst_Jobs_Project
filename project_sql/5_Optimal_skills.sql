/*--What are optimal skills to learn, meaning they are in high demand and command high average salaries?
-- Focus on Data Analyst roles.
--Focus on remote positions with specified salaries.*/

/*
Original 2 queries combined as CTE's
WITH skills_demand AS (
    SELECT 
        skills_job_dim.skill_id,
        skills,
        COUNT(skills_job_dim.job_id) AS demand_count
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
    skills_job_dim.skill_id , skills_dim.skills
              
),  average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        skills,
        skills_dim.type,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM
            job_postings_fact
        INNER JOIN
            skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN
            skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title LIKE '%Data Analyst%' 
    AND salary_year_avg IS NOT NULL 
    AND job_work_from_home = TRUE
    GROUP BY
    skills_job_dim.skill_id, skills_dim.skills, skills_dim.type
 
    )
    SELECT
        skills_demand.skill_id,
        skills_demand.skills,
        skills_demand.demand_count,
        average_salary.avg_salary
    FROM
        skills_demand
    INNER JOIN
        average_salary ON skills_demand.skill_id = average_salary.skill_id
    ORDER BY
        demand_count DESC,
        avg_salary DESC;
        */
        --
        --EDit:
      
      
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
        avg_salary DESC,
        demand_count DESC
    LIMIT 40;