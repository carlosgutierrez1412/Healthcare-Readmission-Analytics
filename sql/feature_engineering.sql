-- Add categorical features

SELECT *,
  CASE 
    WHEN days_in_hospital <= 2 THEN 'Short'
    WHEN days_in_hospital <= 5 THEN 'Medium'
    ELSE 'Long'
  END AS stay_category,
  CASE 
    WHEN comorbidity_score >= 3 THEN 'High'
    ELSE 'Normal'
  END AS risk_flag
FROM admissions;


ALTER TABLE admissions
ADD stay_category AS (
  CASE 
    WHEN days_in_hospital <= 2 THEN 'Short'
    WHEN days_in_hospital <= 5 THEN 'Medium'
    ELSE 'Long'
  END);

ALTER TABLE admissions
ADD risk_flag AS (
  CASE 
    WHEN comorbidity_score >= 3 THEN 'High'
    ELSE 'Normal'
  END);