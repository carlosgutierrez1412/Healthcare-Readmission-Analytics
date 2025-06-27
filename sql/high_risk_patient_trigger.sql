-- Trigger – Flag Critical Admission
CREATE TRIGGER trg_HighRiskAdmission
ON admissions
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT * FROM inserted WHERE comorbidity_score >= 5 AND risk_flag = 'High'
    )
    BEGIN
        PRINT 'Critical admission detected';
    END
END;

