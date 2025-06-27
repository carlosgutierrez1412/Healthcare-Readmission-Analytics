use HealthOps_Analytics

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY IDENTITY(1,1),
    age TINYINT,
    gender NVARCHAR(50)
);

CREATE TABLE Diagnoses (
    diagnosis_id INT PRIMARY KEY IDENTITY(1,1),
    patient_id INT,
    primary_diagnosis NVARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

CREATE TABLE Admissions (
    admission_id INT PRIMARY KEY IDENTITY(1,1),
    patient_id INT,
    num_procedures TINYINT,
    days_in_hospital TINYINT,
    comorbidity_score TINYINT,
    discharge_to NVARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

CREATE TABLE Readmissions (
    admission_id INT,
    readmitted_flag BIT,
    FOREIGN KEY (admission_id) REFERENCES Admissions(admission_id)
);

INSERT INTO Patients (age, gender)
SELECT DISTINCT age, gender
FROM train_df;

INSERT INTO Diagnoses (patient_id, primary_diagnosis)
SELECT p.patient_id, r.primary_diagnosis
FROM train_df r
JOIN Patients p ON r.age = p.age AND r.gender = p.gender;

INSERT INTO Admissions (patient_id, num_procedures, days_in_hospital, comorbidity_score, discharge_to)
SELECT p.patient_id, r.num_procedures, r.days_in_hospital, r.comorbidity_score, r.discharge_to
FROM train_df r
JOIN Patients p ON r.age = p.age AND r.gender = p.gender;

WITH train_df_numbered AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM train_df
),
Admissions_numbered AS (
    SELECT admission_id, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM Admissions
)
INSERT INTO Readmissions (admission_id, readmitted_flag)
SELECT a.admission_id, r.readmitted
FROM train_df_numbered r
JOIN Admissions_numbered a ON r.rn = a.rn;


SELECT * FROM Patients;
SELECT min(patient_id) FROM Diagnoses;
SELECT COUNT(*) FROM Admissions;
SELECT COUNT(*) FROM Readmissions;






