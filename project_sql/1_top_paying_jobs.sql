/*
Time Code 3:15:00
Question 1 (Q1): Identify top-paying Data Engineer jobs in the market & gather statistical insights into them
Subquestions:
    Q1A: Identify the top-10 highest-paying Data Engineer jobs that are available remotely
    Q1B: Refine the data selection of job postings with unspecified salaries (NULLs)
    Q1C: What is the share (percentile) of Data Engineer positions in the whole dataset of job postings?
    Q1D: What is the respective share of high, medium and low salary Data Engineer positions?
    Q1E: What is the average AND median salary for Data Engineer roles?
    1QF: Find the number and respective share of open positions for all remote job postings
Reasons:
    - to highlight top-paying job opportunities for Data Engineer (and related) roles; 
    - to gather insights into employment opportunities I pursue based on real data
*/

-- Q1A-Q1B Solution:

SELECT 
    p.job_id AS id,
    p.job_schedule_type AS schedule,
    p.job_title_short AS job_title, 
    c.name AS company,
    p.job_country AS country,
    ROUND(p.salary_year_avg) AS annual_salary -- If I want 0 signs after ., no need to provide a figure in ROUND fn
FROM job_postings_fact AS p 
    LEFT JOIN company_dim AS c ON
        p.company_id = c.company_id
WHERE 
    p.job_title_short LIKE '%Data Engineer%' AND
    p.job_work_from_home = TRUE AND
    p.salary_year_avg IS NOT NULL -- AND
 -- p.job_country NOT LIKE '%United States%' AND -- optional: if I want to see the market beyoind the US
 -- p.job_country != 'USA' -- optional: if I want to see the market beyoind the US
GROUP BY
    p.job_id,
    p.job_title_short, 
    p.job_schedule_type,
    c.name,
    p.job_country,
    p.salary_year_avg
ORDER BY p.salary_year_avg DESC
LIMIT 10; 

/* Q1C solution:
Additional conditions:
    - No jobs without yearly salary data
    - Not strictly Data Engineer but also vatiations (Senior, Lead, etc.)
*/

WITH total_jobs AS (
    SELECT 
        COUNT(*) AS total_postings
    FROM job_postings_fact
   -- WHERE salary_year_avg IS NOT NULL
),
    DE_jobs AS (
    SELECT 
        COUNT(*) AS DE_postings 
    FROM job_postings_fact
    WHERE -- salary_year_avg IS NOT NULL AND
        job_title_short LIKE '%Data Engineer%' 
    )
SELECT
    DE_postings,
    total_postings,
    ROUND((DE_postings::numeric / total_postings) * 100, 3) || ' %' AS DE_share_percent
FROM
    total_jobs, 
    DE_jobs;

-- Q1D: Find the respective shares of High, Medium and Low salary Data Engineer jobs
 
WITH salary_tier_stats AS (
    SELECT 
        (CASE
            WHEN salary_year_avg < 70000 THEN 'Lower'
            WHEN salary_year_avg BETWEEN 70000 AND 120000 THEN 'Medium'
            ELSE 'High'
            END) AS DE_salary_tier,
        COUNT(job_id) AS salary_tier_count
    FROM job_postings_fact
    WHERE   
        job_title_short LIKE '%Data Engineer%'
        AND salary_year_avg IS NOT NULL
    GROUP BY DE_salary_tier
)

SELECT 
    ss.*,
    ROUND(ss.salary_tier_count * 100 / SUM(ss.salary_tier_count) OVER (), 3) || ' % ' AS salary_tier_share
FROM 
    salary_tier_stats ss
ORDER BY 
    ROUND(ss.salary_tier_count * 100 / SUM(ss.salary_tier_count) OVER (), 3) DESC;

/*
Q1E: What is the average AND median salary for Data Engineer roles?
Additional conditions: 
- identify separate Average and Median values for EACH of DE salary tiers (Low, Mid, High)
- focus on remote DE roles;
*/

-- Q1E Solution 1: Average and Median for ALL DE remote jobs:

SELECT
    COUNT(job_id) AS de_job_count,
    ROUND(AVG(salary_year_avg)) AS avg_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_year_avg) AS median_salary
FROM job_postings_fact
WHERE 
    job_title_short LIKE '%Data Engineer%'
    AND salary_year_avg IS NOT NULL
    -- AND job_work_from_home = true -- additional parameter
ORDER BY avg_salary DESC;

-- Alternative solution with a CTE:

WITH de_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE 
        job_title_short LIKE '%Data Engineer%'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = true -- additional parameter
    )

SELECT
    COUNT(de_jobs) AS de_job_count,
    ROUND(AVG(salary_year_avg)) AS avg_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_year_avg) AS median_salary
FROM de_jobs
ORDER BY avg_salary DESC;

-- Additional condition: compare DE AVG and MEDIAN salaries with the ones for ALL jobs
-- Solution instruments: CTEs + CROSS JOIN + PERCENTILE_CONT

WITH de_job_stats AS (
    SELECT
        COUNT(job_id) AS de_job_count,
        ROUND(AVG(salary_year_avg)) AS de_avg_salary,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_year_avg) AS de_median_salary
    FROM job_postings_fact
    WHERE 
        job_title_short LIKE '%Data Engineer%'
        AND salary_year_avg IS NOT NULL -- NULL salaries are out of scope
        -- AND job_work_from_home = true -- additional parameter
),

    total_job_stats AS (
    SELECT
        COUNT(job_id) AS total_job_count,
        ROUND(AVG(salary_year_avg)) AS total_avg_salary,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_year_avg) AS total_median_salary
    FROM job_postings_fact
    WHERE 
        salary_year_avg IS NOT NULL
        -- AND job_work_from_home = true -- additional parameter
    )

SELECT
    ROUND(dj.de_job_count * 100 / tj.total_job_count, 2) || '% ' AS de_job_share,
    ROUND(dj.de_avg_salary * 100 / tj.total_avg_salary) || '% ' AS avg_salary_correlation,
    ROUND(dj.de_median_salary * 100 / tj.total_median_salary) || '% ' AS median_salary_correlation
FROM 
    de_job_stats AS dj 
    CROSS JOIN total_job_stats AS tj;

-- Q1E Solution 2: AVERAGE and MEDIAN values for for EACH DE salary tier (Low, Mid, High):

WITH salary_tier_stats AS (
    SELECT 
        (CASE
            WHEN salary_year_avg < 70000 THEN 'Lower'
            WHEN salary_year_avg BETWEEN 70000 AND 120000 THEN 'Medium'
            ELSE 'High'
            END) AS de_salary_tier,
        salary_year_avg
    FROM job_postings_fact
    WHERE   
        job_title_short LIKE '%Data Engineer%'
        AND salary_year_avg IS NOT NULL
)

SELECT 
    de_salary_tier,
    COUNT(*) AS salary_tier_count,
    ROUND(AVG(salary_year_avg)) AS average_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_year_avg) as median_salary
FROM 
    salary_tier_stats AS ss
GROUP BY
    de_salary_tier
ORDER BY average_salary DESC;

/*
Q1F OPTIMAL solution: CTE + Window function OVER()
Additional condition: Identify skills associated with such job postings
*/

WITH remote_jobs AS (
    SELECT 
        p.job_title_short,
        COUNT(*) AS remote_postings
    FROM job_postings_fact AS p
    WHERE 
        p.job_work_from_home = true
    GROUP BY p.job_title_short
)

SELECT 
    rj.*,
    ROUND((remote_postings * 100) / SUM(remote_postings) OVER(), 3) || '%' AS job_share
FROM remote_jobs AS rj
ORDER BY 
    ROUND((remote_postings * 100) / SUM(remote_postings) OVER(), 3) DESC;

-- Q1F: Alternative solution: 2 CTEs + CROSS JOIN + STRING_AGG for skills:

WITH remote_jobs AS (
    SELECT 
        p.job_title_short,
        COUNT(*) AS remote_postings
    FROM job_postings_fact AS p
    WHERE 
        p.job_work_from_home = true
    GROUP BY p.job_title_short
),

total_remote_jobs AS (
    SELECT COUNT(*) AS total_remote_postings
    FROM job_postings_fact
    WHERE job_work_from_home = true
)

SELECT 
    rj.job_title_short,
    rj.remote_postings,
    ROUND((rj.remote_postings::numeric / tj.total_remote_postings) * 100, 3) || '%' AS job_share,
    STRING_AGG(DISTINCT s.skills, ' / ') AS top_skills
FROM 
    remote_jobs AS rj 
        CROSS JOIN total_remote_jobs AS tj
        LEFT JOIN job_postings_fact p ON 
            rj.job_title_short = p.job_title_short AND
            p.job_work_from_home = true
        LEFT JOIN skills_job_dim sj ON
            p.job_id = sj.job_id
        LEFT JOIN skills_dim s ON 
            sj.skill_id = s.skill_id 
GROUP BY
    rj.job_title_short,
    rj.remote_postings,
    tj.total_remote_postings
ORDER BY (rj.remote_postings::numeric / tj.total_remote_postings) * 100 DESC;
