-- Stored Procedure – High Risk Alerts
CREATE PROCEDURE sp_HighRiskPatients
AS
BEGIN
    SELECT * FROM vw_risk_profiles
    WHERE risk_flag = 'High' AND readmitted_flag = 1;
END;
