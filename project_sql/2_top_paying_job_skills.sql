/* Quesion 2 (Q2):
Identify skills required for the top-paying Data Engineer jobs
(the jobs that we identified when solving Question 1)
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
    INNER JOIN skills_job_dim as sj ON
        p.job_id = sj.job_id
    INNER JOIN skills_dim AS s ON
        sj.skill_id = s.skill_id
WHERE 
    p.job_title_short LIKE '%Data Engineer%' AND
    p.job_work_from_home = TRUE AND
    p.salary_year_avg IS NOT NULL -- AND
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

-- Alternative solution using CTE from a previous query (Question 1):

WITH top_paying_jobs AS (
    SELECT 
        p.job_id AS id,
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
        c.name,
        p.job_country,
        p.salary_year_avg
    ORDER BY p.salary_year_avg DESC
    LIMIT 10
)

SELECT 
    tj.*,
    STRING_AGG(DISTINCT s.skills, ' / ') as required_skills
FROM top_paying_jobs tj 
    INNER JOIN skills_job_dim AS sj ON
        tj.id = sj.job_id 
    INNER JOIN skills_dim AS s ON 
        sj.skill_id = s.skill_id
GROUP BY -- A sad thing is PostgreSQL doesnt allow to group like "tj.*"
    tj.id,
    tj.job_title, 
    tj.company,
    tj.country,
    tj.annual_salary
ORDER BY annual_salary DESC;

/*
Saving the query results below in JSON for further re-use in subsequent course tasks:

[
  {
    "id": 21321,
    "job_title": "Data Engineer",
    "company": "Engtal",
    "country": "United States",
    "annual_salary": "325000",
    "required_skills": "hadoop / kafka / kubernetes / numpy / pandas / pyspark / python / spark"
  },
  {
    "id": 157003,
    "job_title": "Data Engineer",
    "company": "Engtal",
    "country": "United States",
    "annual_salary": "325000",
    "required_skills": "hadoop / kafka / kubernetes / numpy / pandas / pyspark / python / spark"
  },
  {
    "id": 270455,
    "job_title": "Data Engineer",
    "company": "Durlston Partners",
    "country": "United States",
    "annual_salary": "300000",
    "required_skills": "python / sql"
  },
  {
    "id": 230458,
    "job_title": "Data Engineer",
    "company": "Twitch",
    "country": "United States",
    "annual_salary": "251000",
    "required_skills": "hadoop / kafka / keras / pytorch / spark / tensorflow"
  },
  {
    "id": 543728,
    "job_title": "Data Engineer",
    "company": "Signify Technology",
    "country": "United States",
    "annual_salary": "250000",
    "required_skills": "databricks / python / scala / spark"
  },
  {
    "id": 561728,
    "job_title": "Data Engineer",
    "company": "AI Startup",
    "country": "United States",
    "annual_salary": "250000",
    "required_skills": "azure / python / r / scala"
  },
  {
    "id": 595768,
    "job_title": "Data Engineer",
    "company": "Signify Technology",
    "country": "United States",
    "annual_salary": "250000",
    "required_skills": "databricks / python / scala / spark"
  },
  {
    "id": 151972,
    "job_title": "Data Engineer",
    "company": "Movable Ink",
    "country": "United States",
    "annual_salary": "245000",
    "required_skills": "aws / gcp / nosql"
  },
  {
    "id": 204320,
    "job_title": "Data Engineer",
    "company": "Handshake",
    "country": "United States",
    "annual_salary": "245000",
    "required_skills": "go"
  },
  {
    "id": 2446,
    "job_title": "Data Engineer",
    "company": "Meta",
    "country": "United States",
    "annual_salary": "242000",
    "required_skills": "java / perl / python / sql"
  }
]
*/
