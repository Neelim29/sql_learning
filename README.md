# Introduction
Lets dive into data about the data market itself ! A rigourous finding about everything that you need to know about the data market- be it be the tops skills , highest paying jobs,most unique job roles - every findings in one small report.

*Want to dig more into my sql codes ? Check them out here:* [project_codes](/project_sql/) 
# Background
A typical Data-nerd trying to host his first project in the field of data and eventually landing on the most important component of every Data-nerd's mind- the Data Market ! 

**Note: The data used in this project are from the Youtube course : "SQL for Data Analytics" BY Luke Barousse.**

### This Capstone project covers 5 relavent topics that are as follows- ###

1. What are the top paying Data/Business analyst jobs ?
2. What skills are associated for these top-paying jobs ?
3. What skills are most in demand for Data/Business analyst ?
4. What skills are associated with higher salaries ?
5. What are the most optical skills to learn ?



# Tools used in this project
  
There are multiple tools that can be used to analyse a dataset. But then here are the 4 tolls that I thought were the most suitable to be used in this project-
 
 - **SQL** – Structured Query Language. A language used to find, add, or change data in large tables stored in databases.
 - **VS Code** – A software where you can write and edit code easily; it supports many programming languages.
 - **PostgreSQL** – A system that stores and manages data; it helps run SQL commands and handle complex data tasks.
 - **Git and GitHub** – Git is a tool that keeps track of changes made to files, so you can go back to earlier versions if needed. Github is a website where you can save your projects online, share them with others, and work together as a team.
# The analysis
In this project , each query has been significantly written to identify the above qustions highlighted above. Let us dig deep into every question one by one.

#### 1. Top paying Data/Business Analyst roles 
To find the top paying roles we wrote a query returning us the necessary details like job title and average salaries that either belonged to Category "Data Analyst" or "Business Analyst". Also, we have a filter of returning us jobs that were 'remote'.

a. Data Analyst
```sql
SELECT
    job_id,
    job_title,
    name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC 
LIMIT 10
;
```
**Result:** We found out that-

1. The highest pay of a Data analyst role can go upto $650,000 
2. The highest salried analyst are given titles such as Director of analytics, Associate Director , Principle Data analyst.
3. Bug comapnies such as Meta , AT&T , SmartAsset hire Data analyst.

b. Business Analyst
```sql
SELECT
    job_id,
    job_title,
    name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Business Analyst' AND
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC 
LIMIT 10
;
```
**Result:** WE found out that- 
1. Business analyst can expect salaries upto $220,000.
2. They are offered roles such as Lead Business Intelligence Engineer, Senior Economy Designer, etc.
3. Big company such as Uber hiring in these sector.

### 2. Skills associated with these top-paying jobs.

For these analysis, we wrote a query that dispalyed skills that are associated with these top paying jobs. We also put a filter regarding the jobs specific to 'Data Analyst' or 'Business Analyst'. Also with that we made sure that none of the values that have 'null' as thier salary were excluded from the result.

a. Data Analyst
```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        name AS company_name,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC 
    LIMIT 10 )

SELECT 
    top_paying_jobs.*,
    skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY 
    salary_year_avg DESC ;
```
b. Business Analyst
```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        name AS company_name,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Business Analyst' AND
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC 
    LIMIT 10 )

SELECT 
    top_paying_jobs.*,
    skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY 
    salary_year_avg DESC ;
```
**Result:** For both the designations, we observe that skills like sql , python , r , excel and some more top the charts.

### 3. Skills most in demand for Data/Business Analyst 
For these , we wrote a query that gave us the most desired/in demand skills that recruiters looks for in a Data analyst or a Business Analyst.

**Note: We used two ways to execute this query.For convinience , we used one query for skills in demand for Data Analyst and the other for Business analyst.**

a. Data Analyst
```sql
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
```
By vizualising the data , we get the graph as follows-

![Top skills in demand for Data Analyst](assets\q3_skills_in_demand.png)*Image showcasing the data that includes the top skills that are in most demand for Data Analyst*

Conclusion: We may conclude that sql is the top in-demand skills that is associated to Data Analyst followed by Excel , Python and many more.

 b. Buisness Analyst
 ```sql
 SELECT 
    skills AS skill_name,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    job_title_short = 'Business Analyst'
GROUP BY 
    skill_name
ORDER BY 
    demand_count DESC
LIMIT 10 ;
```
By vizualizing the data , we get 

![Skills in demand for Business Analyst](assets\q3_skills_in_demand_ba.png) *Image showcasing the data that includes the top skills that are in most demand for Business Analyst*

Hence from the data , we can clearly observe that the core skills are the same as Data analyst but here it can be observed that excel is on par with sql on this field of line . This can come from the fact that Business Analyst rely heavily on excel and its figures and presentations to convey meassages to CXO's of the company.

### 4. Skills associated with higher salary
 For this , we wrote a query that gave us the skills that have the highest average salaries associated with them.

 a. Data Analyst
 ```sql
 SELECT 
    skills AS skill_name,
    ROUND(AVG(salary_year_avg),2) AS avg_pay_per_skill
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY 
    skill_name
ORDER BY 
    avg_pay_per_skill DESC
LIMIT 10 ;
```
**Result:**
| Rank | Skill Name  | Average Pay (USD) |
|------|-------------|-------------------|
| 1    | SVN         | $400,000.00       |
| 2    | Solidity    | $179,000.00       |
| 3    | Couchbase   | $160,515.00       |
| 4    | DataRobot   | $155,485.50       |
| 5    | Golang      | $155,000.00       |
| 6    | MXNet       | $149,000.00       |
| 7    | dplyr       | $147,633.33       |
| 8    | VMware      | $147,500.00       |
| 9    | Terraform   | $146,733.83       |
| 10   | Twilio      | $138,500.00       |

Hence , we can observe that skills that are not so popular like SVN , solidity and dplyr are to be seen in this observation. This comes down to the fact that these skills are not so common in Data Analyst field and are more commonly seen in Data Science field . Hence having these skills can significantly boost your salary as a Data Analyst.

b. Business Analyst
```sql
SELECT 
    skills AS skill_name,
    ROUND(AVG(salary_year_avg),2) AS avg_pay_per_skill
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    job_title_short = 'Business Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY 
    skill_name
ORDER BY 
    avg_pay_per_skill DESC
LIMIT 10 ;
```
**Result:**

| Rank | Skill      | Average Pay (USD) |
|------|------------|-------------------|
| 1    | Chef       | $220,000.00       |
| 2    | NumPy      | $157,500.00       |
| 3    | Ruby       | $150,000.00       |
| 4    | Hadoop     | $139,201.36       |
| 5    | Julia      | $136,100.00       |
| 6    | Airflow    | $135,410.00       |
| 7    | Phoenix    | $135,248.18       |
| 8    | Electron   | $131,000.00       |
| 9    | C          | $123,328.57       |
| 10   | PyTorch    | $120,333.33       |

Here , we can onserve that tools like Chef for automation purposes,numpy for working with arrays etc. are skills that has been in high demand.

### 5. The most optimum skills to learn
For the last statement, we develop a query that gives us the optimum skills that we can learn for becoming a optimum canditate for the role 'Data Analyst' or 'Business Analyst'.

We can differ our choices into two parts - i. the skills which have the most pay among the others OR ii. the skills that are in large demand . Hence for this statement , we can develop two queries related to the above choices . **#We will use one for the role of Data Analyst and one for the role of Business Analyst** 

a. Optimum skills by most average pay (Data Analyst)
```sql
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
```
**Result:**
### 📊 Skill Demand and Average Pay

| Skill        | Demand Count | Average Pay (USD) |
|--------------|--------------|-------------------|
| Kafka        | 40           | $129,999.16       |
| PyTorch      | 20           | $125,226.20       |
| Perl         | 20           | $124,685.75       |
| TensorFlow   | 24           | $120,646.83       |
| Cassandra    | 11           | $118,406.68       |
| Atlassian    | 15           | $117,965.60       |
| Airflow      | 71           | $116,387.26       |
| Scala        | 59           | $115,479.53       |
| Linux        | 58           | $114,883.20       |
| Confluence   | 62           | $114,153.12       |
| PySpark      | 49           | $114,057.87       |
| MongoDB      | 26           | $113,607.71       |
| GCP          | 78           | $113,065.48       |
| Spark        | 187          | $113,001.94       |
| Splunk       | 15           | $112,927.60       |
| Databricks   | 102          | $112,880.74       |
| Git          | 74           | $112,249.64       |
| Snowflake    | 241          | $111,577.72       |
| Shell        | 44           | $111,496.45       |
| Unix         | 37           | $111,123.32       |
| Hadoop       | 140          | $110,888.27       |
| Pandas       | 90           | $110,767.07       |
| Phoenix      | 23           | $109,259.09       |
| PHP          | 29           | $109,051.51       |

Hence , by most pay , skills related to data pipeline such as Kafka and Airflow makes the list with date warehouses like git and data manupilation tools like pandas also make the list . It is to be noted that most of these skills/tools are very niche in the Data Analytics market compared to popular tools like sql and excel. 

b. By most demand (Business Analyst)
```sql
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
    demand_count DESC
LIMIT 25;
```
**Result:**

### 📊 High-Demand Skills and Their Average Pay

| Skill       | Demand Count | Average Pay (USD) |
|-------------|--------------|-------------------|
| SQL         | 3,083        | $96,435.33        |
| Excel       | 2,143        | $86,418.90        |
| Python      | 1,840        | $101,511.85       |
| Tableau     | 1,659        | $97,978.08        |
| R           | 1,073        | $98,707.80        |
| Power BI    | 1,044        | $92,323.60        |
| Word        | 527          | $82,940.76        |
| PowerPoint  | 524          | $88,315.61        |
| SAS         | 500          | $93,707.36        |
| SQL Server  | 336          | $96,191.42        |
| Oracle      | 332          | $100,964.19       |
| Azure       | 319          | $105,399.62       |
| AWS         | 291          | $106,439.84       |
| Go          | 288          | $97,266.97        |
| Flow        | 271          | $98,019.82        |
| Looker      | 260          | $103,855.35       |
| Snowflake   | 241          | $111,577.72       |
| SPSS        | 212          | $85,292.80        |
| Spark       | 187          | $113,001.94       |
| VBA         | 185          | $93,844.97        |
| SAP         | 183          | $92,446.21        |
| Outlook     | 180          | $80,680.33        |
| SharePoint  | 174          | $89,027.16        |
| Sheets      | 155          | $84,129.61        |

Hence , in the field of Business Analytics , popular tools like sql, excel, python etc. keeps the top spots for the most demand in the market. 

## What I learned
From this Fascinating Project about the job market of Data related fields , there are multiple things that I could learn.

- I could deep dive into the field of SQL much deeper than ever before exploring joints, manipulation , extraction and many more .
- I learned about tools and skills related in and around SQL such as postgres, VS code, and many more .
- I learned how to integrat AI into performing analytical tools that made my analysis much more easier .
-  Sticking around these project and having trouleshooting billions of times but not giving up made me learn discipline,consistancy and many other moral learnings.
## Conclusion 

Here are some facts/Conclusions that can be drawn from the analysis above

- Both the Field of 'Data analyst' and 'Business analysis' can tremendous career heights . It is to be highlighted that Business analyst is a part of Data analyst and hence shows similarities in many of the above queries.
- For both the fields , there are many common skills such as SQL, Excel,Python etc. These skills are now-a-days considered  essential for becoming a profound Data analyst or Business analyst.
- Again for Most demanded skills , both the fields share similar outcomes as both shows SQL,Excel,Power bi , tableau etc. as their most demanded skills .
- For top paying skills , niches skills like SVN for Data analyst and numpy or chef for Business analyst are seen as the most high paying skills.
- According to personal opinions,people may choose to learn skills associated to hugh pay or skills that are most demanded and choose what is optimum for them to learn. If they choose high pay skills like Kafka, Airflow would be ideal for them and if they choose high demand skills like SQL,Python etc would be ideal for them.

# Closing Thoughts
This project has helped me learn valuable skills such as SQL in a very high and useful manner. This project has also help me get familier with tools like postgres and connect to other people via platforms like Github. With tremendous efforts and lots of hardwork and troubleshooting , I feel that I have finally learned the essence of creating an analysis that can help people choose a better decision in the field of data. 