# 🏥 Healthcare Readmission Analytics Dashboard

## 📌 Project Summary

This project aims to analyze **hospital readmissions** using patient data to uncover patterns and identify high-risk populations. By leveraging SQL for data transformation, Excel for raw data inspection, and Power BI for visual storytelling, the goal was to create a compelling dashboard that provides actionable insights for healthcare decision-makers.

📊 **Objective**: Predict and visualize factors that influence patient readmission rates — such as diagnosis, age, comorbidities, and number of procedures.

📁 **Dataset**: [Hospital Admissions Dataset (Kaggle)](https://www.kaggle.com/datasets/tariqali/hospital-readmission-dataset)

---

## 🛠 Tools Used

| Tool      | Purpose                                                                 |
|-----------|-------------------------------------------------------------------------|
| **Excel** | Initial data exploration, formatting flat files, spotting early issues |
| **SQL Server** | Data cleaning, transformation, view creation, feature engineering    |
| **Power BI** | Building the interactive dashboard with charts and KPIs               |

---

## 🧩 Project Structure

### 1. **Data Preparation (Excel)**

- Opened raw `.csv` or `.xlsx` files
- Inspected columns for missing values, outliers, and incorrect data types
- Ensured column headers were cleaned and consistent before import

### 2. **Data Engineering (SQL Server)**

All SQL logic was implemented in a structured way across the following phases:

#### 🔹 PHASE 1: Flat File Import

- Imported flat files (e.g., `train_df.csv`) into SQL Server as staging tables.

#### 🔹 PHASE 2: Data Cleaning

- Normalized gender text formatting
- Standardized discharge destinations (e.g., “Home”, “H”, “house” → "Home")
- Detected and flagged outliers (e.g., `age < 0` or `age > 120`)
- Removed duplicate `patient_id`s if needed
- Casted `readmitted_flag` to a boolean type
- Checked for NULLs in important fields

#### 🔹 PHASE 3: Feature Engineering

- Created derived fields using `CASE`:
  - `stay_category`: Short / Medium / Long stay based on `days_in_hospital`
  - `risk_flag`: High / Normal based on `comorbidity_score`

#### 🔹 PHASE 4: Views & Transformations

Created analytical views including:

- `vw_patient_summary`: One row per patient (latest admission and diagnosis)
- `vw_discharge_readmission`: Readmission rates by discharge destination
- `vw_procedure_summary`: Readmission rate by number of procedures
- `vw_comorbidity_distribution`: Grouped comorbidity scores vs readmissions
- `vw_risk_profiles`: Filtered for high-risk patients
- `vw_age_readmission`: Readmission rates grouped by age brackets

#### 🔹 PHASE 5: Analytics & Advanced SQL

- Correlated readmission rates with:
  - Primary diagnosis
  - Number of procedures
  - Age group
  - Gender
- Created a **window function** to rank patients within age groups by readmission risk
- Created a **stored procedure** for high-risk patients
- Built a **trigger** to alert for critical admissions (`comorbidity_score >= 8`)

---

## 📊 Power BI Dashboard

The final dashboard includes:

### 🔹 KPI Cards
- **Total Patients**
- **Total Admissions**
- **Readmission Rate** (calculated from `readmitted_flag`)
- **High-Risk Patients Readmitted** (using DAX `CALCULATE()` logic)

### 🔹 Visualizations

1. **Readmission Rate by Primary Diagnosis**  
   - X-Axis: Diagnosis name  
   - Y-Axis: Readmission rate  
   - View: `vw_patient_summary`

2. **Readmission Rate by Number of Procedures**  
   - X-Axis: `num_procedures`  
   - Y-Axis: Readmission rate  
   - View: `vw_procedure_summary`

3. **Readmission Rate by Age Group**  
   - Created DAX `AgeGroup` column (Under 30, 30–49, etc.)  
   - X-Axis: Age Group  
   - Y-Axis: Average readmission rate  
   - View: `vw_patient_summary`

> All charts are interactive and filter each other dynamically.

---

## 🧠 Insights

- Patients diagnosed with **COPD** had the highest readmission rate (~29%)
- **Long hospital stays** correlated with higher readmission probability
- A comorbidity score above 5 sharply increased the chance of readmission
- Patients aged **70+** were significantly more likely to be readmitted





