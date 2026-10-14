CREATE OR ALTER TRIGGER dbo.TR_Applications_SetUpdatedAt
    ON dbo.Applications
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE a
           SET    UpdatedAt = CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2)
           FROM   dbo.Applications AS a
                  INNER JOIN
                  inserted AS i
                  ON a.Id = i.Id;
       END


GO
CREATE OR ALTER TRIGGER dbo.TR_Features_SetUpdatedAt
    ON dbo.Features
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE f
           SET    UpdatedAt = CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2)
           FROM   dbo.Features AS f
                  INNER JOIN
                  inserted AS i
                  ON f.Id = i.Id;
       END


GO
CREATE OR ALTER TRIGGER dbo.TR_Roles_SetUpdatedAt
    ON dbo.Roles
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE r
           SET    UpdatedAt = CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2)
           FROM   dbo.Roles AS r
                  INNER JOIN
                  inserted AS i
                  ON r.Id = i.Id;
       END


GO
CREATE OR ALTER TRIGGER dbo.TR_Users_SetUpdatedAt
    ON dbo.Users
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE u
           SET    UpdatedAt = CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2)
           FROM   dbo.Users AS u
                  INNER JOIN
                  inserted AS i
                  ON u.Id = i.Id;
       END


GO
CREATE OR ALTER TRIGGER dbo.TR_FeatureSettings_SetUpdatedAt
    ON dbo.FeatureSettings
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE fs
           SET    UpdatedAt = CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2)
           FROM   dbo.FeatureSettings AS fs
                  INNER JOIN
                  inserted AS i
                  ON fs.Id = i.Id;
       END


GO
CREATE OR ALTER TRIGGER dbo.TR_RoleFeatureAccess_SetUpdatedAt
    ON dbo.RoleFeatureAccess
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE rfa
           SET    UpdatedAt = CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2)
           FROM   dbo.RoleFeatureAccess AS rfa
                  INNER JOIN
                  inserted AS i
                  ON rfa.Id = i.Id;
       END