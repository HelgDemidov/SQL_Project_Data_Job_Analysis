/*
Time Code 3:15:00
Task 1: Identifying top-paying Data Engineer jobs in the market
Subtasks:
    1) Identify the top-10 highest-paying Data Engineer jobs that are available remotely. 
    2) Refine the data selection of job postings with unspecified salaries (NULLs)
    3) [MY OWN]: derive additional statistical insights into top-paying Data Engineer jobs [TO BE SPECIFIED LATER]
Reasons:
    - to highlight top-paying job opportunities for Data Engineer (and related) roles; 
    - to gather insights into employment opportunities I pursue based on real data. 
*/

SELECT 
    p.job_id AS id,
    p.job_title_short AS job_title, 
    STRING_AGG (DISTINCT s.skills, ' / ') AS required_skills, -- STRING_AGG is used to list all relevant skills for each job posting. 
    c.name AS company,
    p.job_country AS country,
    ROUND(p.salary_year_avg) AS annual_salary -- If I want 0 signs after ., no need to provide a figure in ROUND fn
FROM job_postings_fact AS p 
    LEFT JOIN company_dim AS c ON
        p.company_id = c.company_id
    LEFT JOIN skills_job_dim as sj ON
        p.job_id = sj.job_id
    LEFT JOIN skills_dim AS s ON
        sj.skill_id = s.skill_id
WHERE 
    p.job_title_short LIKE '%Data Engineer%' AND
    p.job_work_from_home = TRUE AND
    p.salary_year_avg IS NOT NULL AND
    p.salary_year_avg > 70000 -- AND
 -- p.job_country NOT LIKE '%United States%' AND 
 -- p.job_country != 'USA'
GROUP BY
    p.job_id,
    p.job_title_short, 
    c.name,
    p.job_country,
    p.salary_year_avg
ORDER BY p.salary_year_avg DESC
LIMIT 10; 

/*
Additional tasks for the dataset:
    1. What is the share (percentile) of Data Engineer positions in the whole dataset of job postings?
    2. What is the respective share of high, medium and low salary Data Engineer positions?
    3. What is the average AND median salary for Data Engineer roles? 
        3.2. How does it correlate with the median salary for all positions in the dataset?
        3.3. ...
*/

/*
Additional Question (AQ) 1: 
Find share of DE positions among all job postings
Additional conditions:
    a) No jobs without yearly salary data
    b) Not strictly Data Engineer but also vatiations (Senior, Lead, etc.)
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

/*
Question 2:
    Find the number of open positions for all remote job postings
    Present their shares (percentiles) to all remote job postings
    Identify skills associated with such job postings (using STRING_AGG)
*/

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
