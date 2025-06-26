SELECT
    job_id,
    salary_year_avg,
        CASE
        WHEN  job_title ILIKE  '%Senior%' THEN 'Senior'
        WHEN  job_title ILIKE  '%Lead%' OR job_title ILIKE '%Manager%' THEN 'Lead/Manager'
        WHEN  job_title ILIKE  '%Junior%'OR job_title ILIKE'%Entry%' THEN 'Junior/Entry'
        ELSE 'Not Specified'
    END AS experience_level,
        CASE
        WHEN job_work_from_home = true THEN 'Yes'
        ELSE 'No'
    END AS work_from_home_option
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    job_id;
