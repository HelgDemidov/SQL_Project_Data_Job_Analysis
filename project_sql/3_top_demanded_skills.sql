/*
Question 4: Identify most in-demand skills for Data Engineer
    - Join job postings to inner join table similarly to query 2
    - Identify the top-5 in-demand skills for Data Engineer job (including Senior DE, Chief DE, Lead DE, etc.)
    - Cover all job postings (whichever has skills associated with it in the dataset)
*/

WITH skill_stats AS (
    SELECT
        s.skills AS skill_name,
        s.type AS skill_type,
        COUNT(sj.job_id) AS related_jobs
    FROM skills_job_dim AS sj 
        INNER JOIN skills_dim AS s ON
            sj.skill_id = s.skill_id
        INNER JOIN job_postings_fact AS p ON
            sj.job_id = p.job_id
        WHERE 
            job_title_short LIKE '%Data Engineer%'
         -- AND p.job_work_from_home = true -- optional parameter: remote jobs
         -- AND salary_year_avg > 80000 -- optional parameter: Medium+ paid jobs
    GROUP BY 
        s.type,
        s.skills
    ORDER BY related_jobs DESC
    LIMIT 5
),

    job_stats AS (
    SELECT 
        COUNT(DISTINCT job_id) AS total_jobs
    FROM job_postings_fact
    WHERE 
        job_title_short LIKE '%Data Engineer%'
     -- AND job_work_from_home = true -- optional parameter: remote jobs
     -- AND salary_year_avg > 80000 -- optional parameter: Medium+ paid jobs
    )

SELECT 
    ss.*,
    ROUND((ss.related_jobs::numeric / js.total_jobs) * 100, 3) || '%' AS skill_share
FROM 
    skill_stats ss CROSS JOIN job_stats js
GROUP BY 
    ss.skill_name,
    ss.skill_type, 
    ss.related_jobs,
    js.total_jobs
ORDER BY ROUND((ss.related_jobs::numeric / js.total_jobs) * 100, 3) DESC;