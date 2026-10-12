USE FeatureFlagDb;


GO
IF OBJECT_ID('dbo.Environments', 'U') IS NULL
    CREATE TABLE dbo.Environments (
        Id             UNIQUEIDENTIFIER CONSTRAINT DF_Environments_Id DEFAULT NEWID() NOT NULL,
        ApplicationId  UNIQUEIDENTIFIER NOT NULL,
        Name           VARCHAR (50)     NOT NULL,
        EnvironmentKey VARCHAR (50)     NOT NULL,
        CreatedAt      DATETIME2        CONSTRAINT DF_Environments_CreatedAt DEFAULT SYSUTCDATETIME() NOT NULL,
        UpdatedAt      DATETIME2        CONSTRAINT DF_Environments_UpdatedAt DEFAULT SYSUTCDATETIME() NOT NULL,
        IsDeleted      BIT              CONSTRAINT DF_Environments_IsDeleted DEFAULT 0 NOT NULL,
        CONSTRAINT PK_Environments PRIMARY KEY (Id),
        CONSTRAINT FK_Environments_Applications FOREIGN KEY (ApplicationId) REFERENCES dbo.Applications (Id),
        CONSTRAINT UQ_Environments_Id_ApplicationId UNIQUE (Id, ApplicationId)
    );