# Data Engineer Job Market Analysis 2023

---

**Explore the complete analysis through our interactive dashboard featuring real-time visualizations and insights from 231,000+ job postings.**

---
🧱 **Introduction & Project Background: From "Tutorial Hell" to Real Engineering**

This project started as my personal "sandbox" to bridge the gap between watching tutorials and actually building things. I followed Luke Barousse's course to get the basics down, but I didn't want to just copy-paste code. I treated this as a full-scale engineering simulation: I set up a proper VS Code environment, managed my own Git repository, and ventured into front-end territory using LLM assistance to build an interactive visualization layer on top of my SQL analysis.

My goal here was to understand the full lifecycle of a data project—from raw CSVs to complex aggregations, and finally, to a public-facing dashboard hosted on GitHub Pages. This repo is my proof of concept that I can not only query data but also organize, document, and present it in a way that makes sense to real people. It’s my first step out of the classroom and into the field.

---

### 📊 **[Click Here to View the Interactive Dashboard](https://helgdemidov.github.io/SQL_Project_Data_Job_Analysis/)**
---

### Dashboard Features

| 📊 Market Overview | 💰 Salary Analysis | 🎯 Optimal Skills |
|:------------------:|:------------------:|:-----------------:|
| ![Market](26-01%20DE%20Study%20Screenshot%201.png) | ![Salary](26-01%20DE%20Study%20Screenshot%202.png) | ![Skills](26-01%20DE%20Study%20Screenshot%203.png) |
| Remote job distribution | Top-paying skills | Demand vs salary matrix |

---

## 📋 Project Overview

This project analyzes real-world job posting data to answer critical questions facing aspiring and current data engineers:

- Which data roles dominate the remote job market?
- What skills command the highest salaries?
- Which skills offer the best balance of demand and compensation?
- What technical stack do top-paying positions require?

**Data Source:** Luke Barousse's SQL Course Dataset  
**Tools Used:** PostgreSQL, SQL  
**Scope:** 231,000+ data-related job postings with focus on Data Engineer positions

---

## 🔍 Key Questions Explored

| # | Question | Focus Area |
|---|----------|------------|
| 1 | What are the top-paying data jobs and their market share? | Market Overview |
| 2 | What skills are required for the top-paying DE positions? | Premium Skills |
| 3 | Which skills are most in-demand for Data Engineers? | Skill Demand |
| 4 | Which skills correlate with highest salaries? | Salary Analysis |
| 5 | What are the most optimal skills to learn? | Strategic Learning |

---

## 📊 Analysis Results

### 1. Remote Data Job Market Distribution

**Finding:** Data Engineer is the dominant role in the remote data job market.

| Rank | Job Title | Remote Postings | Market Share |
|------|-----------|-----------------|--------------|
| 1 | **Data Engineer** | 21,261 | **30.55%** |
| 2 | Data Scientist | 14,534 | 20.88% |
| 3 | Data Analyst | 13,331 | 19.15% |
| 4 | Senior Data Engineer | 6,564 | 9.43% |
| 5 | Senior Data Scientist | 3,809 | 5.47% |
| 6 | Software Engineer | 2,918 | 4.19% |
| 7 | Business Analyst | 2,786 | 4.00% |
| 8 | Senior Data Analyst | 2,352 | 3.38% |
| 9 | Machine Learning Engineer | 1,480 | 2.13% |
| 10 | Cloud Engineer | 571 | 0.82% |

**Key Insight:** Data Engineer positions account for nearly **one-third** of all remote data job postings, representing **1.46x more opportunities** than Data Scientist roles. When combined with Senior Data Engineer positions, the engineering track comprises **40% of the market**.

---

### 2. Skills Required for Top-Paying Positions

**Finding:** The highest-paying DE roles ($242K-$325K) require mastery of big data ecosystems.

| Company | Annual Salary | Required Skills |
|---------|---------------|-----------------|
| Engtal | $325,000 | hadoop, kafka, kubernetes, numpy, pandas, pyspark, python, spark |
| Durlston Partners | $300,000 | python, sql |
| Twitch | $251,000 | hadoop, kafka, keras, pytorch, spark, tensorflow |
| Signify Technology | $250,000 | databricks, python, scala, spark |
| AI Startup | $250,000 | azure, python, r, scala |
| Movable Ink | $245,000 | aws, gcp, nosql |
| Handshake | $245,000 | go |
| Meta | $242,000 | java, perl, python, sql |

**Key Insights:**
- **Python** appears in **6 of 8** unique top-paying positions—it is non-negotiable
- The **Apache ecosystem** (Spark, Kafka, Hadoop) dominates premium roles
- **Scala** emerges as the preferred secondary language for distributed computing
- Top salaries require **broad technical depth**, not narrow specialization
- Notable exception: Durlston Partners offers $300K for Python + SQL alone, suggesting elite proficiency in fundamentals can rival extensive tech stacks

---

### 3. Most In-Demand Skills for Data Engineers

**Finding:** Foundational programming skills dominate demand, followed by cloud platforms.

| Rank | Skill | Related Jobs | Market Share | Category |
|------|-------|--------------|--------------|----------|
| 1 | **SQL** | 142,062 | **61.40%** | Programming |
| 2 | **Python** | 137,245 | **59.32%** | Programming |
| 3 | AWS | 81,578 | 35.26% | Cloud |
| 4 | Azure | 77,054 | 33.30% | Cloud |
| 5 | Spark | 69,905 | 30.21% | Libraries |
| 6 | Java | 45,814 | 19.80% | Programming |
| 7 | Kafka | 38,890 | 16.81% | Libraries |
| 8 | Scala | 37,453 | 16.19% | Programming |
| 9 | Hadoop | 36,762 | 15.89% | Libraries |
| 10 | Snowflake | 35,821 | 15.48% | Cloud |

**Key Insights:**
- **SQL and Python are essential**—appearing in ~60% of all postings each
- **Cloud platform proficiency** (AWS or Azure) is required in **~1 of 3** positions
- The **big data trinity** (Spark, Kafka, Hadoop) collectively represents significant demand
- **Snowflake** has emerged as a major player, approaching Hadoop in demand

---

### 4. Skills Correlated with Highest Salaries

**Finding:** Specialized NoSQL and database technologies command premium compensation.

| Rank | Skill | Job Count | Average Salary | Median Salary |
|------|-------|-----------|----------------|---------------|
| 1 | **MongoDB** | 239 | $176,119 | **$173,500** |
| 2 | **Cassandra** | 432 | $156,724 | **$156,596** |
| 3 | Shell | 569 | $149,303 | $150,000 |
| 4 | Angular | 54 | $146,583 | $147,500 |
| 5 | Redis | 76 | $143,495 | $147,500 |
| 6 | Kafka | 1,319 | $147,097 | $147,500 |
| 7 | MySQL | 612 | $145,363 | $147,500 |
| 8 | PyTorch | 64 | $141,784 | $147,500 |
| 9 | Redshift | 1,176 | $145,249 | $147,500 |
| 10 | Scala | 1,222 | $146,949 | $147,500 |

**Key Insights:**
- **MongoDB specialists** earn a **$26,000 premium** over the next highest skill
- **Cassandra** (distributed NoSQL) ranks second—reflecting demand for large-scale systems expertise
- **Kafka and Scala** offer the best combination of **high job count + high salary**
- The salary plateau at **$147,500** across multiple skills suggests a market-established benchmark for senior DE compensation

---

### 5. Optimal Skills to Learn (Demand + Salary Combined)

**Finding:** Python and SQL lead the optimal skills ranking, but specialized tools offer salary premiums.

| Combined Rank | Skill | Job Demand | Median Salary |
|---------------|-------|------------|---------------|
| 🥇 1 | **Python** | 4,196 | $135,000 |
| 🥈 2 | **SQL** | 4,289 | $131,580 |
| 🥉 3 | **AWS** | 2,887 | $140,000 |
| 4 | Spark | 2,297 | $145,000 |
| 5 | Azure | 2,059 | $132,500 |
| 6 | Java | 1,656 | $144,482 |
| 7 | Snowflake | 1,571 | $143,000 |
| 8 | Kafka | 1,319 | $147,500 |
| 9 | Scala | 1,222 | $147,500 |
| 10 | Hadoop | 1,226 | $145,000 |

**Key Insights:**
- **Python ranks #1** despite not having the highest salary—its ubiquitous demand makes it indispensable
- **SQL follows closely**, confirming that relational database skills remain foundational
- **AWS edges out Azure** in the combined ranking due to higher demand
- **Kafka and Scala** (ranks 8-9) offer the **highest median salaries** ($147,500) among the top 10
- A strategic learning path: Master Python/SQL → Add AWS → Specialize in Spark/Kafka

---

## 💡 Strategic Recommendations

Based on this analysis, here are evidence-based recommendations for data engineering career development:

### For Entry-Level Engineers
1. **Master the fundamentals:** SQL and Python are non-negotiable prerequisites
2. **Choose one cloud platform:** AWS has slightly higher demand; Azure is a close second
3. **Learn Apache Spark:** It's the most demanded big data framework

### For Mid-Level Engineers Seeking Higher Compensation
1. **Add streaming expertise:** Kafka skills correlate with $147,500 median salary
2. **Learn Scala:** Enables deeper Spark optimization and functional programming patterns
3. **Explore NoSQL:** MongoDB and Cassandra specialists command significant premiums

### For Senior Engineers Targeting $250K+ Roles
1. **Build comprehensive big data stacks:** Top positions require Hadoop + Kafka + Spark proficiency
2. **Add ML frameworks:** TensorFlow, PyTorch, Keras appear in premium roles
3. **Master container orchestration:** Kubernetes differentiates top-tier candidates

---

## 🛠️ Technical Implementation

### SQL Queries Used

All analysis was performed using PostgreSQL. Key techniques included:
- Common Table Expressions (CTEs) for query organization
- Window functions for ranking
- Aggregate functions with GROUP BY for statistical analysis
- JOINs across job postings and skills tables
- Subqueries for filtered analysis

### Repository Structure

```
├── sql_queries/
│   ├── 1_job_market_overview.sql
│   ├── 2_top_paying_skills.sql
│   ├── 3_skills_demand.sql
│   ├── 4_skills_salary.sql
│   └── 5_optimal_skills.sql
├── data/
│   ├── task_1_results.json
│   ├── task_2_results.json
│   ├── task_3_results.json
│   ├── task_4_results.json
│   └── task_5_results.json
├── visualizations/
│   └── dashboard.jsx
└── README.md
```

---

## 📚 Data Source & Acknowledgments

- **Dataset:** [Luke Barousse's SQL Course](https://www.youtube.com/watch?v=7mz73uXD9DA)
- **Original Data:** Real job postings from various job boards
- **Analysis Period:** 2023 job market data

---

## 🔗 Connect

Feel free to reach out for questions about the analysis methodology or findings.

---

*This analysis is based solely on the provided dataset. Results reflect patterns in the analyzed job postings and should be considered alongside current market conditions when making career decisions.*
