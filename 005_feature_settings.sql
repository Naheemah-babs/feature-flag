USE FeatureFlagDb;


GO
IF OBJECT_ID('dbo.FeatureSettings', 'U') IS NULL
    CREATE TABLE dbo.FeatureSettings (
        FeatureId     UNIQUEIDENTIFIER NOT NULL,
        EnvironmentId UNIQUEIDENTIFIER NOT NULL,
        ApplicationId UNIQUEIDENTIFIER NOT NULL,
        IsEnabled     BIT              CONSTRAINT DF_FeatureSettings_IsEnabled DEFAULT 0 NOT NULL,
        UpdatedAt     DATETIME2        CONSTRAINT DF_FeatureSettings_UpdatedAt DEFAULT SYSUTCDATETIME() NOT NULL,
        CONSTRAINT PK_FeatureSettings PRIMARY KEY (FeatureId, EnvironmentId),
        CONSTRAINT FK_FeatureSettings_Features FOREIGN KEY (FeatureId, ApplicationId) REFERENCES dbo.Features (Id, ApplicationId),
        CONSTRAINT FK_FeatureSettings_Environments FOREIGN KEY (EnvironmentId, ApplicationId) REFERENCES dbo.Environments (Id, ApplicationId)
    );