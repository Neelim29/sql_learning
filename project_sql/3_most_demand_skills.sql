WITH most_demand_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim
    INNER JOIN job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id )
SELECT 
    skills AS skill_name,
    skill_count
FROM
    most_demand_skills
INNER JOIN skills_dim ON skills_dim.skill_id = most_demand_skills.skill_id
ORDER by 
    skill_count DESC
LIMIT 10 ;