-- admission table
select * from patients

-- Standardize capitalization
UPDATE patients
SET gender = 'Male'
WHERE LOWER(gender) IN ('m', 'male');

UPDATE patients
SET gender = 'Female'
WHERE LOWER(gender) IN ('f', 'female');


-- Audit distinct values
SELECT DISTINCT gender FROM patients;

-- Check for Nulls
SELECT * FROM patients WHERE gender IS NULL;
-- No nulls


-- Outliers
SELECT * FROM patients WHERE age < 0 OR age > 120;

SELECT MIN(age),
MAX(age),
AVG(age)
FROM patients;

-- diagnoses tale
select * from diagnoses

-- Check for Nulls
SELECT * FROM diagnoses WHERE primary_diagnosis IS NULL OR LTRIM(RTRIM(primary_diagnosis)) = '';
-- No nulls

-- Trim spaces and standardize case
UPDATE diagnoses
SET primary_diagnosis = UPPER(LTRIM(RTRIM(primary_diagnosis)));

-- Distinct Values
SELECT DISTINCT primary_diagnosis FROM diagnoses;


-- admissions table
select * from admissions


-- Check for Nulls
SELECT * FROM admissions WHERE num_procedures IS NULL OR num_procedures < 0;
SELECT * FROM admissions WHERE days_in_hospital IS NULL OR days_in_hospital < 0;
SELECT * FROM admissions WHERE comorbidity_score IS NULL OR comorbidity_score < 0;
-- No nulls

-- Normalize discharge values
UPDATE admissions
SET discharge_to = 'Home'
WHERE LOWER(discharge_to) IN ('home', 'house', 'h');

-- Review all unique values
SELECT DISTINCT discharge_to FROM admissions;


SELECT a.*
FROM admissions a
LEFT JOIN patients p ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;


-- readmissions table
select * from readmissions

-- Check for Nulls
SELECT * FROM readmissions WHERE readmitted_flag IS NULL;
-- No nulls


SELECT DISTINCT readmitted_flag FROM readmissions;



SELECT 
  (SELECT COUNT(*) FROM patients) AS total_patients,
  (SELECT COUNT(*) FROM diagnoses) AS total_diagnoses,
  (SELECT COUNT(*) FROM admissions) AS total_admissions,
  (SELECT COUNT(*) FROM readmissions) AS total_readmissions;






