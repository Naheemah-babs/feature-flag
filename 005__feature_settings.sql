IF OBJECT_ID('dbo.FeatureSettings', 'U') IS NULL
    CREATE TABLE dbo.FeatureSettings (
        Id                UNIQUEIDENTIFIER CONSTRAINT DF_FeatureSettings_Id DEFAULT NEWSEQUENTIALID() NOT NULL,
        ApplicationId     UNIQUEIDENTIFIER NOT NULL,
        FeatureId         UNIQUEIDENTIFIER NOT NULL,
        IsEnabled         BIT              CONSTRAINT DF_FeatureSettings_IsEnabled DEFAULT 0 NOT NULL,
        IsReleased        BIT              CONSTRAINT DF_FeatureSettings_IsReleased DEFAULT 0 NOT NULL,
        RolloutPercentage INT              CONSTRAINT DF_FeatureSettings_RolloutPercentage DEFAULT 0 NOT NULL,
        CreatedAt         DATETIME2        CONSTRAINT DF_FeatureSettings_CreatedAt DEFAULT CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2) NOT NULL,
        UpdatedAt         DATETIME2        CONSTRAINT DF_FeatureSettings_UpdatedAt DEFAULT CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2) NOT NULL,
        CONSTRAINT PK_FeatureSettings PRIMARY KEY (Id),
        CONSTRAINT CK_FeatureSettings_RolloutPercentage_Range CHECK (RolloutPercentage BETWEEN 0 AND 100),
        CONSTRAINT FK_FeatureSettings_Applications FOREIGN KEY (ApplicationId) REFERENCES dbo.Applications (Id),
        CONSTRAINT FK_FeatureSettings_Features FOREIGN KEY (FeatureId) REFERENCES dbo.Features (Id),
        CONSTRAINT UQ_FeatureSettings_Application_Feature UNIQUE (ApplicationId, FeatureId)
    );