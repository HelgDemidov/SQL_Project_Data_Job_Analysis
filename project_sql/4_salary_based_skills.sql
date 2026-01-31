/*
Question 4: Identify top skills based on salary for Data Engineer jobs
Specific steps:
    - Look at the average salary associated with each skill for Data Engineer positions
    - Optional: Narrow down the selection to REMOTE Data Engineer jobs, otherwise disregard job location
Purpose: to gather insight into how different skills impact salary levels for Data Engineers, 
and to help identify the most financially rewarding skills to master for DE job
*/

-- Q4 Solution #1: No CTEs, no Window Functions

SELECT
    s.skills AS skill_name,
    COUNT(sj.skill_id) AS skill_count,
    ROUND(AVG(p.salary_year_avg)) AS avg_salary_for_skill,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY p.salary_year_avg)) AS median_salary_for_skill
FROM
    job_postings_fact AS p 
    INNER JOIN skills_job_dim AS sj ON
        p.job_id = sj.job_id
    INNER JOIN skills_dim AS s ON
        sj.skill_id = s.skill_id
WHERE
    p.job_title_short LIKE '%Data Engineer%'
    AND p.salary_year_avg IS NOT NULL 
    -- AND p.job_work_from_home = true -- optional parameter
GROUP BY 
    skill_name
HAVING
    COUNT(sj.skill_id) > 50 -- Let's get rid of rare skills
ORDER BY
    median_salary_for_skill DESC
LIMIT 10;