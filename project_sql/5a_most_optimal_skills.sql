WITH skills_in_demand AS
    (SELECT 
        skills_dim.skill_id,
        skills_dim.skills AS skill_name,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
    ), avg_salary as(
    SELECT 
        skills_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg),2) AS avg_pay_per_skill
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id)

SELECT 
    skills_in_demand.skill_id,
    skills_in_demand.skill_name,
    demand_count,
    avg_pay_per_skill
FROM
    skills_in_demand
INNER JOIN avg_salary ON skills_in_demand.skill_id = avg_salary.skill_id
WHERE demand_count >10
ORDER BY 
    avg_pay_per_skill DESC
LIMIT 25;