/*
Time Code 3:15:00
Task 1: Identifying top-paying Data Engineer jobs in the market
Subtasks:
    1) Identify the top-10 highest=paying Data Engineer jobs that are available remotely. 
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
