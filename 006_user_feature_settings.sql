USE FeatureFlagDb;


GO
IF OBJECT_ID('dbo.UserFeatureSettings', 'U') IS NULL
    CREATE TABLE dbo.UserFeatureSettings (
        UserId        UNIQUEIDENTIFIER NOT NULL,
        FeatureId     UNIQUEIDENTIFIER NOT NULL,
        EnvironmentId UNIQUEIDENTIFIER NOT NULL,
        IsEnabled     BIT              CONSTRAINT DF_UserFeatureSettings_IsEnabled DEFAULT 0 NOT NULL,
        UpdatedAt     DATETIME2        CONSTRAINT DF_UserFeatureSettings_UpdatedAt DEFAULT SYSUTCDATETIME() NOT NULL,
        CONSTRAINT PK_UserFeatureSettings PRIMARY KEY (UserId, FeatureId, EnvironmentId),
        CONSTRAINT FK_UserFeatureSettings_Users FOREIGN KEY (UserId) REFERENCES dbo.Users (Id),
        CONSTRAINT FK_UserFeatureSettings_FeatureSettings FOREIGN KEY (FeatureId, EnvironmentId) REFERENCES dbo.FeatureSettings (FeatureId, EnvironmentId)
    );