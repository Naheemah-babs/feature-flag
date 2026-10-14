USE FeatureFlagDb;


GO
CREATE OR ALTER TRIGGER dbo.TR_Applications_UpdatedAt
    ON dbo.Applications
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE a
           SET    UpdatedAt = SYSUTCDATETIME()
           FROM   dbo.Applications AS a
                  INNER JOIN
                  inserted AS i
                  ON a.Id = i.Id;
       END


GO
CREATE OR ALTER TRIGGER dbo.TR_Users_UpdatedAt
    ON dbo.Users
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE u
           SET    UpdatedAt = SYSUTCDATETIME()
           FROM   dbo.Users AS u
                  INNER JOIN
                  inserted AS i
                  ON u.Id = i.Id;
       END


GO
CREATE OR ALTER TRIGGER dbo.TR_Features_UpdatedAt
    ON dbo.Features
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE f
           SET    UpdatedAt = SYSUTCDATETIME()
           FROM   dbo.Features AS f
                  INNER JOIN
                  inserted AS i
                  ON f.Id = i.Id;
       END


GO
CREATE OR ALTER TRIGGER dbo.TR_Environments_UpdatedAt
    ON dbo.Environments
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE e
           SET    UpdatedAt = SYSUTCDATETIME()
           FROM   dbo.Environments AS e
                  INNER JOIN
                  inserted AS i
                  ON e.Id = i.Id;
       END


GO
CREATE OR ALTER TRIGGER dbo.TR_FeatureSettings_UpdatedAt
    ON dbo.FeatureSettings
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE s
           SET    UpdatedAt = SYSUTCDATETIME()
           FROM   dbo.FeatureSettings AS s
                  INNER JOIN
                  inserted AS i
                  ON s.FeatureId = i.FeatureId
                     AND s.EnvironmentId = i.EnvironmentId;
       END


GO
CREATE OR ALTER TRIGGER dbo.TR_UserFeatureSettings_UpdatedAt
    ON dbo.UserFeatureSettings
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE s
           SET    UpdatedAt = SYSUTCDATETIME()
           FROM   dbo.UserFeatureSettings AS s
                  INNER JOIN
                  inserted AS i
                  ON s.UserId = i.UserId
                     AND s.FeatureId = i.FeatureId
                     AND s.EnvironmentId = i.EnvironmentId;
       END