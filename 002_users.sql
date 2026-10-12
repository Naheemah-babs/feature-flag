USE FeatureFlagDb;


GO
IF OBJECT_ID('dbo.Users', 'U') IS NULL
    CREATE TABLE dbo.Users (
        Id          UNIQUEIDENTIFIER CONSTRAINT DF_Users_Id DEFAULT NEWID() NOT NULL,
        Name        VARCHAR (100)    NOT NULL,
        Email       VARCHAR (254)    NOT NULL,
        DateOfBirth DATE             NULL,
        CreatedAt   DATETIME2        CONSTRAINT DF_Users_CreatedAt DEFAULT SYSUTCDATETIME() NOT NULL,
        UpdatedAt   DATETIME2        CONSTRAINT DF_Users_UpdatedAt DEFAULT SYSUTCDATETIME() NOT NULL,
        IsDeleted   BIT              CONSTRAINT DF_Users_IsDeleted DEFAULT 0 NOT NULL,
        CONSTRAINT PK_Users PRIMARY KEY (Id)
    );