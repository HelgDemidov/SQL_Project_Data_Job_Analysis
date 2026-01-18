/*
Date Handling
1. ::DATE - converts date-time data to a date format by removing time. 
2. AT TIME ZONE - converts a timestamp to a specified timezone. 
3. EXTRACT - allows to get specific date parts (year, month, day)
*/

SELECT job_posted_date
FROM job_postings_fact
LIMIT 10; 

SELECT 
    '2023-02-19'::DATE, 
    '123'::INTEGER, 
    '1'::BOOLEAN,
    '3.14'::REAL; 

SELECT  
    job_title_short AS title, 
    job_location AS location, 
    job_posted_date::DATE AS date 
FROM 
    job_postings_fact
LIMIT 10000; 

/*
AT TIME ZONE - converts timestamps between different time zones. 
It can be used on timestamps with or without time zone information. 
Recall:
    TIMESTAMP:
       A specific date and time without time zone.
       Format: YYYY-MM-DD HH:MM:SS
    TIMESTAMP WITH TIME ZONE: 
       A specific date and time with time zone information. 
       Format: YYYY-MM-DD HH:MM:SS+HH:MM
       Similar to TIMESTAMP, but includes time zone information. 
     */

SELECT  
    job_title_short AS title, 
    job_location AS location,
    job_posted_date::TIMESTAMP AS date_time
FROM 
    job_postings_fact
LIMIT 5; 

/*
1. Timestamps with time zone:
    Stored as UTC, displayed per query's or system's time zone
    AT TIME ZONE converts UTC to the specified time zone correctly

Example: 
SELECT
    column_name AT TIME ZONE 'EST' -- (Eastern Standard Time Zone)
FROM 
    table_name; 

2. Timestamps without time zone (our sotuation):
    Treated as local time in PostgreSQL
    Using AT TIME ZONE assumes the machine's local time for conversion; 
    I need to specify the it, or the default is UTC. 

Example:

SELECT 
    column_name AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM 
    table_name; 
*/

SELECT
    job_title_short AS title, 
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC'AT TIME ZONE 'EST'
FROM    
    job_postings_fact
LIMIT 5; 

/*
EXTRACT
    Gets a field (e.g., year, month, day) from a date/time value
    Example:

SLEECT 
    EXTRACT(MONTH FROM column_name) AS column_month
FROM
    table_name; ALTER
*/ 

SELECT
    job_title_short AS title, 
    job_location AS location, 
    EXTRACT(MONTH FROM job_posted_date) AS job_posted_month,
    EXTRACT(YEAR FROM job_posted_date) AS job_posted_year
FROM 
    job_postings_fact
LIMIT 5; 

SELECT -- Here we apply the EXTRACT function to analyze the statistical trends of job applications by months. 
    COUNT(job_id) AS job_posted_count, 
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE 
    job_title_short LIKE '%Data Engineer%'
GROUP BY 
    month
ORDER BY job_posted_count DESC
LIMIT 50000; 

/*
Timecode 2:20:15
Practice Problem 1:
    Find both average yearly and average hourly salary for all job postings
    that were posted after June 1, 2023. Group the results by job schedule type. 
*/

SELECT  
    job_schedule_type,
    ROUND(AVG(salary_hour_avg),2) AS avg_hourly,
    ROUND(AVG(salary_year_avg),2) AS avg_yearly
FROM 
    job_postings_fact
WHERE
    job_posted_date >= DATE '2023-06-02' 
    AND (salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL)
        AND job_schedule_type IS NOT NULL
GROUP BY job_schedule_type
ORDER BY avg_yearly DESC NULLS LAST;

/*
Practice Problem 2:
    Count the number of job postings for each month in 2023, 
    adjusting the job_posted_date to be in 'America/New York' time zone before extracting (hint) the month. 
*/

SELECT 
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'America/New_York') AS month,
    COUNT(*) AS job_count
FROM 
    job_postings_fact
WHERE 
    EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'America/New_York') = 2023
GROUP BY 1
ORDER BY 2 DESC; 

/*
Practice Problem 3:
    Find companies (including company names) that have posted jobs
    offering health insurance, where these postings were made in the second quarter of 2023. 
    Use date extraction to filter by quarter. 
*/

SELECT
    c.name AS company, 
    COUNT(*)
FROM 
    job_postings_fact AS p INNER JOIN company_dim AS c ON
        p.company_id = c.company_id
WHERE 
    p.job_health_insurance = true AND
        (EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'America/New_York') BETWEEN 4 AND 6) AND
        EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'America/New_York') = 2023
GROUP BY 1
ORDER BY 2 DESC;

/* 
Timecode 2:20:30
Practice Problem 6
Create 3 tables: 
    Jan 2023 jobs
    Feb 2023 jobs
    Mar 2023 jobs
This will be used in another practice problem below
Hints:
    Use CREATE TABLE table_name AS syntax to create respective tables.
    Look at a way to filter out only specific months.
*/

CREATE TABLE january_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'America/New_York') = 1 AND
        EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'America/New_York') = 2023; 

CREATE TABLE february_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'America/New_York') = 2 AND
        EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'America/New_York') = 2023; 

CREATE TABLE march_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'America/New_York') = 3 AND
        EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'America/New_York') = 2023; 

SELECT job_posted_date
FROM march_jobs
LIMIT 10; 

/*
Timecode 2:25:20
CASE Expression
A CASE expression is a way to apply conditional logic to my SQL queries
Example:

SELECT
    CASE 
        WHEN 'column name' = 'Value 1' THEN 'Description for value 1'
        WHEN 'column name' = 'Value 2' THEN 'Description for value 2'
        ELSE 'Other'
    END AS column description
FROM 
    table_name;

CASE - begins the expression
WHEN - specifies the condition(-s) to look at (could be multiple)
THEN - specifies what to do when the condition is TRUE
ELSE - specifies what to do when all previous conditions are FALSE
END - concludes the CASE expression
*/ 

/*
Label the new column:
- 'Anywhere jobs' as "Remote"
- 'New York, NY' jobs as "Local"
- Otherwise 'Onsite'
*/

SELECT 
    CASE 
        WHEN job_location = 'New York, NY' THEN 'Local'
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'Onsite'
    END AS location_category,
    COUNT(job_id) AS jobs_count -- Here I add COUNT() to get some stats on different job location categories that we introduced.
FROM 
    job_postings_fact
WHERE 
    job_title_short LIKE '%Data Engineer%' -- In case I'm interested in a particular job
GROUP BY 
    CASE 
        WHEN job_location = 'New York, NY' THEN 'Local'
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'Onsite'
    END 
ORDER BY jobs_count DESC; 

/*
Time code 2:30:20
Practice Problem 1
I want to categorize salaries from each job posting to see if it fits in my desired salary range. I need to:
    Put salaries into different buckets (categories)
    Set conditions for what is to be considered a 'high', 'medium' and 'low' salary
    Why? It is easy to determine what job postings are worthy of my attention based on salary. 
    Bucketing is a common practice in Data analysis when viewing different categories
    I only want to look at Data Engineer roles (and their variations)
    Order the results from highest to lowest salary
*/

SELECT
    CASE
        WHEN salary_year_avg < 60000 THEN 'low_salary'
        WHEN salary_year_avg BETWEEN 60000 AND 119999 THEN 'medium_salary'
        WHEN salary_year_avg BETWEEN 120000 AND 199999 THEN 'high_salary'
        ELSE 'superhigh_salary' 
    END AS salary_tier,
    COUNT(job_id) AS jobs_count
FROM 
    job_postings_fact
WHERE 
    job_title_short LIKE '%Data Engineer%' AND 
    salary_year_avg IS NOT NULL
GROUP BY 
    CASE
        WHEN salary_year_avg < 60000 THEN 'low_salary'
        WHEN salary_year_avg BETWEEN 60000 AND 119999 THEN 'medium_salary'
        WHEN salary_year_avg BETWEEN 120000 AND 199999 THEN 'high_salary'
        ELSE 'superhigh_salary' 
    END 
ORDER BY jobs_count DESC; 

/*
Time code 2:31:30 
Subqueries and CTEs (Common Table Expressions)
Subqueries are queries nested inside larger queries
Subqeuries can be used in several places within a main query, including the folloowing 4 clauses:
    SELECT
    FROM 
    WHERE
    HAVING 
NB: a subquery can NOT be used with GROUP BY clause (!)
In terms of execution logic, a subquery is executed FIRST (before the main query), and its results are passed to the outer query
    It is used when we want to peform calculation before the main queerty can complete its calculation
See a subquery example below:
*/

SELECT *
FROM ( 
    SELECT *
    FROM job_postings_fact
    WHERE 
        EXTRACT (MONTH FROM job_posted_date AT TIME ZONE 'America/New_York') = 1
 ) AS january_jobs
 LIMIT 100;  

/*
CTEs: Common Table Expressions
CTEs define a temporary result set that I can reference in my later requests
CTEs in PostgreSQL can be referenced within SELECT, INSERT, UPDATE and DELETE clauses
CTEs are defined (introduced to the query) with a WITH clause
CTEs are referenced (called) by queries BELOW them (!)
See a CTE example below:
*/

WITH january_jobs AS ( -- Basically, a CTE is just a subquery/nested query, introduced with WITH
    SELECT *
    FROM job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'America/New_York') = 1
)

SELECT *
FROM january_jobs -- We can use it with under tenporary name we introduced earlier
LIMIT 100;  

-- Subquery (nested query) practice

SELECT
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT 
        company_id
    FROM 
        job_postings_fact
    WHERE
        job_no_degree_mention = TRUE
    ); 

-- Alternative query without using a subquery - to get the same data:

SELECT DISTINCT -- If we DISTINCT here, than it should be applied to both company name AND company ID to work correctly
    c.company_id,
    c.name AS company_name
FROM company_dim AS c INNER JOIN job_postings_fact AS p ON
    c.company_id = p.company_id
WHERE 
    p.job_no_degree_mention = true
GROUP BY c.company_id -- GROUP BY just duplicates DISTINCT here, they could be used as alternatives to each other
ORDER BY c.company_id; 

/*
A CTE practice (time code 2:37:50)
Find the companies that have the most job openings.
    Get the total number of job postings per company_id
    Return the total number of jobs for a company name
*/

SELECT
    p.company_id AS id,
    c.name AS company_name, 
    COUNT(p.job_id) AS posted_jobs
FROM 
    job_postings_fact AS p INNER JOIN company_dim as c ON
        p.company_id  = c.company_id
GROUP BY 
    p.company_id, 
    c.name
ORDER BY posted_jobs DESC; 

-- Now let's do it with CTE, as Perplexity recommends:

WITH company_job_counts AS (
    SELECT 
        p.company_id, 
        COUNT(p.job_id) AS jobs_count
    FROM job_postings_fact AS p
    GROUP BY p.company_id
)

SELECT 
    cc.company_id AS id, 
    c.name AS company, 
    cc.jobs_count 
FROM company_dim AS c LEFT JOIN company_job_counts AS cc ON
    c.company_id = cc.company_id
ORDER BY cc.jobs_count DESC
LIMIT 100; 

--Finally, the course author's version:
-- It's basically the same as the one above from Perplexity
-- The only difference is that in the course LEFT JOIN is used

/*
Time code 2:42:00 - Practice Problems
Practice Problem 1:
Identify the top-5 skills most frequently mentioned in job postings. 
Hints:
    Use a subquery to find skill IDs with the highest counts in skills_job_dim table.
    Then join them with skills_dim table to get the skill names.
*/

SELECT
    s.skills, 
    skills_number -- I introduce this alias below in subquery
FROM 
    skills_dim AS s INNER JOIN (
    SELECT
        sj.skill_id,
        COUNT(sj.skill_id) AS skills_number
    FROM skills_job_dim AS sj
    GROUP BY sj.skill_id
    ) AS sc ON s.skill_id = sc.skill_id
ORDER BY skills_number DESC
LIMIT 5; 

/*
Practice Problem 2:
Determine the size category ('Small'(<10), 'Medium'(11-50), 'Large'(50+)) for each company by first identifying how many job postings they have. 
Use a subquery to identify the total number of job postings per company
Implement a subquery to aggregate job counts per company before categorizing them as Small/Medium/Large.
*/ 

WITH company_jobs_count AS (
    SELECT 
        p.company_id, 
        COUNT(p.job_id) AS jobs_count
    FROM job_postings_fact AS p
    GROUP BY p.company_id
)

SELECT
    DISTINCT c.name, 
    (CASE
        WHEN cc.jobs_count <10 THEN 'Small'
        WHEN cc.jobs_count BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END) AS company_size
FROM company_dim AS c LEFT JOIN company_jobs_count AS cc ON
    c.company_id = cc.company_id
WHERE cc.jobs_count IS NOT NULL
ORDER BY c.name
LIMIT 100; 

/*
Time code 2:42:20
Practice Problem 7
Find the count of the number of remote job postings per skill. 
    Display the top 5 skills by their demand for remote jobs
    Include skill ID, name, and count of job postings requiring this skill
*/

SELECT
    sj.skill_id AS id, 
    s.skills AS skill_name,
    COUNT(sj.job_id) AS related_jobs
FROM skills_job_dim AS sj 
    INNER JOIN skills_dim AS s ON
        sj.skill_id = s.skill_id
    INNER JOIN job_postings_fact AS p ON
        sj.job_id = p.job_id
WHERE p.job_work_from_home = true
GROUP BY sj.skill_id, s.skills
ORDER BY related_jobs DESC
LIMIT 5; 

-- Another solution using WITH clause
WITH remote_jobs AS ( -- По сути, WITH просто позволяет реализовать первый JOIN отдельно. Больше никакого смысла в ней здесь нет. 
    SELECT DISTINCT
        sj.job_id,
        sj.skill_id
    FROM skills_job_dim AS sj INNER JOIN job_postings_fact AS p ON
        sj.job_id = p.job_id
    WHERE p.job_work_from_home = true AND
        p.job_title_short LIKE '%Data Analyst%' -- Additional condition from the course

)
SELECT
    rj.skill_id AS id, 
    s.skills AS skill_name,
    COUNT(rj.job_id) AS related_jobs
FROM remote_jobs rj 
    INNER JOIN skills_dim s ON
        rj.skill_id = s.skill_id
GROUP BY 
    rj.skill_id,
    s.skills
ORDER BY related_jobs DESC
LIMIT 5; 

/*
Luke Barousse approach:
    1) First build a CTE showing number of jobs per skill_id (skills_dim INNER JOIN skills_job_dim)
    2) Then do anohter JOIN with jobs_postings_fact to get remote jobs
*/

/*
Time code 2:50:15
UNION Operators
UNION Operators combine result sets of 2 or more SELECT statements into a single result set
    UNION: remove duplicate rows
    UNION ALL: applies to all diplicate rows
NB (!): each SELECT statement in the UNION must have the same numbe of columns in the result sets with similar data tyoes
NB2 (!): in a sense, UNIONs are an opposite of JOINs:
    - JOINs unite tables by identical values in their columns
    - UNIONs merge identical columns from different tables with different values

UNION Syntax:
SELECT column_name
FROM table 1

UNION

SELECT column_name
FROM table2;

Gets rid of all identical rows - all ros are unique 
NB(!): this is unlike UNION ALL (which leaves duplicate row values)
*/

SELECT
    job_title_short,
    company_id, 
    job_location
FROM january_jobs

UNION ALL

SELECT
    job_title_short,
    company_id, 
    job_location
FROM february_jobs

UNION ALL

SELECT
    job_title_short,
    company_id, 
    job_location
FROM march_jobs;

/*
UNION ALL - combines the result of 2 or more SELECT statements.
    The statements have to have equal number of columns with compatible data types.
    Returns all rows, even the duplicating ones
    NB: Luke Barousse uses UNION ALL to combine 2 or more tables together
Syntax:
SELECT column_name 
FROM table1

UNION ALL

SELECT column_name
FROM table2
*/

/*
Time code 2:54:10
Practice Problems: UNION and UNION ALL
Practice Problem 1:
Get the corresponding skill and skill type for each job posting in Q1 2023(?)
    This includes jobs postings without any skills too
    Why? Look at the skills and skill type for each job in the first quarter that has a salary > $70k
*/

SELECT 
       type skill_type,
    COUNT(skill_id) AS skill_count
FROM skills_dim 
GROUP BY type
ORDER BY skill_count DESC
LIMIT 100; 

-- Solution with the fucking UNION:

SELECT
    jj.job_id AS job_id,
    s.skills AS skill, 
    s.type AS skill_type
FROM january_jobs AS jj 
    LEFT JOIN skills_job_dim AS sj ON 
        jj.job_id = sj.job_id
    LEFT JOIN skills_dim AS s ON
        sj.skill_id = s.skill_id
WHERE salary_year_avg > 70000 AND 
    salary_year_avg IS NOT NULL

UNION ALL

SELECT
    fj.job_id AS job_id,
    s.skills AS skill, 
    s.type AS skill_type
FROM february_jobs AS fj 
    LEFT JOIN skills_job_dim AS sj ON 
        fj.job_id = sj.job_id
    LEFT JOIN skills_dim AS s ON
        sj.skill_id = s.skill_id
WHERE salary_year_avg > 70000 AND 
    salary_year_avg IS NOT NULL

UNION ALL

SELECT
    mj.job_id AS job_id,
    s.skills AS skill, 
    s.type AS skill_type
FROM march_jobs AS mj 
    LEFT JOIN skills_job_dim AS sj ON 
        mj.job_id = sj.job_id
    LEFT JOIN skills_dim AS s ON
        sj.skill_id = s.skill_id
WHERE salary_year_avg > 70000 AND 
    salary_year_avg IS NOT NULL;

-- The mostrous query above returns 34040 rows

-- An optimal query (returns 34112 rows)

SELECT
    jp.job_id AS job_id,
    s.skills AS skill, 
    s.type AS skill_type
FROM job_postings_fact AS jp 
    LEFT JOIN skills_job_dim AS sj ON 
        jp.job_id = sj.job_id
    LEFT JOIN skills_dim AS s ON
        sj.skill_id = s.skill_id
WHERE 
    salary_year_avg > 70000 AND 
    salary_year_avg IS NOT NULL AND
    EXTRACT(MONTH FROM job_posted_date) BETWEEN 1 AND 3 AND
    EXTRACT(YEAR FROM job_posted_date) = 2023
ORDER BY skill NULLS FIRST; 

-- Luke Barousse solution:

SELECT 
    job_title_short AS job,
    job_location AS location,
    job_via,
    job_posted_date::DATE AS posting_date,
    salary_year_avg
FROM ( -- UNION ALL can be used in a subquery!
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs) as q1jp
WHERE 
    salary_year_avg > 70000 AND 
    salary_year_avg IS NOT NULL AND
    job_title_short LIKE '%Data Analyst%' -- Luke uses = 'Data Analyst' which is bullshit
ORDER BY salary_year_avg DESC;

/*
Time code 2:58:30 - Project Section
About the Project:
1. Goal
I am an aspiring data engineer looking to analyze the top-paying roles and skills in the market.
I will create SQL queries to explore the dataset through lens and angles specific and unique to me
If I look for a job: I can not only use this project to showcase experience but also to extract insights about what roles/skills I should target
*/

/* Time code 3:00:55
Questions to answer
1. What are the top=paying jobs for my role?
2. What are the skills required for those top=paying roles?
3. What are the most demanded skills for the role I'm seeking?
4. What are the top skills for my role based  on salary?
5. What are the optimal skills to learn based on my specific goals and career interests?
    Optimal may be defined as simultaneously high-demand AND high-paying
*/

/*
Github repository created
Termonology:
Push Changes:
Uploads local repository content (changes) to a remote repository (e.g. Github)
Push Changes are used after committing changes I want to share with others or save them remotely
To Push any changes made on my local repository to Github, click Push origin in Github Desktop 
and then Push to update my remote repository. 
I shouldn't forget to create a summary description of my changes

Pull Changes:
Pull - downloads changes from a remote (e.g. Github) repository to my local repository
Pull is used to uodate my local repository with changes made by myself or others in a remote repository
To pull any changes made on Github to my local repository, I need to click Fetch origin in GitHub Desktop
and then Pull to update my local copy of the repository


