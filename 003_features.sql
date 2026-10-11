USE FeatureFlagDb;


GO
IF OBJECT_ID('dbo.Features', 'U') IS NULL
    CREATE TABLE dbo.Features (
        Id            UNIQUEIDENTIFIER CONSTRAINT DF_Features_Id DEFAULT NEWID() NOT NULL,
        ApplicationId UNIQUEIDENTIFIER NOT NULL,
        Name          VARCHAR (100)    NOT NULL,
        FeatureKey    VARCHAR (100)    NOT NULL,
        CreatedAt     DATETIME2        CONSTRAINT DF_Features_CreatedAt DEFAULT SYSUTCDATETIME() NOT NULL,
        UpdatedAt     DATETIME2        CONSTRAINT DF_Features_UpdatedAt DEFAULT SYSUTCDATETIME() NOT NULL,
        IsDeleted     BIT              CONSTRAINT DF_Features_IsDeleted DEFAULT 0 NOT NULL,
        CONSTRAINT PK_Features PRIMARY KEY (Id),
        CONSTRAINT FK_Features_Applications FOREIGN KEY (ApplicationId) REFERENCES dbo.Applications (Id),
        CONSTRAINT UQ_Features_Id_ApplicationId UNIQUE (Id, ApplicationId)
    );