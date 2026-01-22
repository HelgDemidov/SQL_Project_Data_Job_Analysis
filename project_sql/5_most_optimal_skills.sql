/*
Question 5 (Q5): Identify most optimal skills to learn for a Data Engineer (DE) job
Key parameters:
    a) Identify top high-paying skills for DE position
    b) Focus on skills that are frequently required in the market
    b) Optional: Focus on remote positions with specified salaries
Essentially, we have to run a two-axial analysis: 
financial value of a skill combined with high demand for it in the market
*/

-- Solution 1 (suboptimal): Total demand capacity (TDC) based approach
-- skill_count * median_salary_for_skill = total demand capacity (TDC) per skill 
-- by ranking results by TDC we get the optimal skills for a Data Engineer role

WITH skill_metrics AS ( -- CTE introduced to avoid double calculation in ORDER BY clause
    SELECT
        s.skills AS skill_name,
        COUNT(sj.skill_id) AS skill_count,
        ROUND(AVG(p.salary_year_avg)) AS avg_salary,
        ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY p.salary_year_avg)) AS median_salary
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
    GROUP BY s.skills
    HAVING
        COUNT(sj.skill_id) > 30 -- Let's get rid of rare skills
        AND ROUND(AVG(p.salary_year_avg)) > 110000 -- Let's get rid of skills with high demand but lower average salary
    )

SELECT sm.*
FROM skill_metrics AS sm
ORDER BY sm.median_salary * sm.skill_count DESC
LIMIT 10;