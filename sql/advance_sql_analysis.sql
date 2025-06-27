-- Readmission Rate by Diagnosis
SELECT primary_diagnosis, COUNT(*) AS total_cases,
       SUM(CAST(readmitted_flag AS INT)) AS readmissions,
       AVG(CAST(readmitted_flag AS FLOAT)) AS readmission_rate
FROM vw_patient_summary
GROUP BY primary_diagnosis
ORDER BY readmission_rate DESC;

-- Gender and Age Interaction
SELECT gender, age,
       COUNT(*) AS total_patients,
       AVG(CAST(readmitted_flag AS FLOAT)) AS readmission_rate
FROM vw_patient_summary
GROUP BY gender, age
ORDER BY age;

-- Readmission Rate by Age Group
SELECT 
  CASE 
    WHEN age < 30 THEN 'Under 30'
    WHEN age BETWEEN 30 AND 49 THEN '30-49'
    WHEN age BETWEEN 50 AND 69 THEN '50-69'
    WHEN age BETWEEN 70 AND 89 THEN '70-89'
    ELSE '90+'
  END AS age_group,
  COUNT(*) AS patient_count,
  AVG(CAST(readmitted_flag AS FLOAT)) AS readmission_rate
FROM vw_patient_summary
GROUP BY 
  CASE 
    WHEN age < 30 THEN 'Under 30'
    WHEN age BETWEEN 30 AND 49 THEN '30-49'
    WHEN age BETWEEN 50 AND 69 THEN '50-69'
    WHEN age BETWEEN 70 AND 89 THEN '70-89'
    ELSE '90+'
  END
ORDER BY age_group;

-- Window Function – Percentile Rank of Readmission Risk by Age Group
-- This query assigns each patient a percentile rank within their age group based on whether they were readmitted.
-- It helps compare readmission likelihood among peers, identifying high-risk individuals relative to others their age.
-- Useful for patient targeting, alerts, and population risk segmentation.
SELECT *,
       PERCENT_RANK() OVER (PARTITION BY 
         CASE 
           WHEN age < 30 THEN 'Under 30'
           WHEN age BETWEEN 30 AND 49 THEN '30-49'
           WHEN age BETWEEN 50 AND 69 THEN '50-69'
           WHEN age BETWEEN 70 AND 89 THEN '70-89'
           ELSE '90+'
         END ORDER BY readmitted_flag DESC) AS readmission_percentile
FROM vw_patient_summary;
