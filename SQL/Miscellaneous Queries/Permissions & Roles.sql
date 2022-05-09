--Query 4 Permissions & Roles

USE ReportServer
GO

SELECT 
CAT.Name
,U.UserName
,ROL.RoleName
,ROL.Description
,U.AuthType
FROM dbo.Users U
    INNER JOIN dbo.PolicyUserRole PUR ON U.UserID = PUR.UserID
    INNER JOIN dbo.Policies POLICY ON POLICY.PolicyID = PUR.PolicyID
    INNER JOIN dbo.Roles ROL    ON ROL.RoleID = PUR.RoleID
    INNER JOIN dbo.Catalog CAT  ON CAT.PolicyID = POLICY.PolicyID
WHERE UPPER(UserName) like '%LARKINS%'    
ORDER BY U.UserName --CAT.Name