-- Patient Summary
ALTER VIEW vw_patient_summary AS
WITH RankedAdmissions AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY patient_id ORDER BY admission_id DESC) AS rn
  FROM admissions
),
RankedDiagnoses AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY patient_id ORDER BY diagnosis_id DESC) AS rn
  FROM diagnoses
)
SELECT 
  p.patient_id, p.age, p.gender,
  d.primary_diagnosis,
  a.admission_id, a.num_procedures, a.days_in_hospital, a.comorbidity_score, a.discharge_to,
  a.stay_category, a.risk_flag,
  r.readmitted_flag
FROM patients p
JOIN RankedDiagnoses d ON p.patient_id = d.patient_id AND d.rn = 1
JOIN RankedAdmissions a ON p.patient_id = a.patient_id AND a.rn = 1
JOIN readmissions r ON a.admission_id = r.admission_id;

SELECT * from vw_patient_summary;

-- Risk Profile
CREATE VIEW vw_risk_profiles AS
SELECT *
FROM vw_patient_summary
WHERE risk_flag = 'High';

SELECT * from vw_risk_profiles;

-- Discharge vs Readmission
CREATE VIEW vw_discharge_readmission AS
SELECT discharge_to,
       COUNT(*) AS total_discharges,
       SUM(CAST(readmitted_flag AS INT)) AS total_readmissions,
       1.0 * SUM(CAST(readmitted_flag AS INT)) / COUNT(*) AS readmission_rate
FROM vw_patient_summary
GROUP BY discharge_to;

SELECT * FROM vw_discharge_readmission;

-- Procedure Summary
CREATE VIEW vw_procedure_summary AS
SELECT num_procedures,
       COUNT(*) AS procedure_count,
       AVG(CAST(readmitted_flag AS FLOAT)) AS readmission_rate
FROM vw_patient_summary
GROUP BY num_procedures;

SELECT * FROM vw_procedure_summary;

-- Comorbidity Distribution
CREATE VIEW vw_comorbidity_distribution AS
SELECT comorbidity_score,
       COUNT(*) AS patient_count,
       AVG(CAST(readmitted_flag AS FLOAT)) AS readmission_rate
FROM vw_patient_summary
GROUP BY comorbidity_score;

SELECT * FROM vw_comorbidity_distribution;

