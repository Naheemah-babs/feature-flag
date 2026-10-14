-- Creates the Applications table if it does not already exist.
IF OBJECT_ID('dbo.Applications', 'U') IS NULL
    CREATE TABLE dbo.Applications (
        Id             UNIQUEIDENTIFIER CONSTRAINT DF_Applications_Id DEFAULT NEWID() NOT NULL,
        Name           VARCHAR (100)    NOT NULL,
        ApplicationKey VARCHAR (50)     NOT NULL,
        CreatedAt      DATETIME2        CONSTRAINT DF_Applications_CreatedAt DEFAULT SYSUTCDATETIME() NOT NULL,
        UpdatedAt      DATETIME2        CONSTRAINT DF_Applications_UpdatedAt DEFAULT SYSUTCDATETIME() NOT NULL,
        IsDeleted      BIT              CONSTRAINT DF_Applications_IsDeleted DEFAULT 0 NOT NULL,
        CONSTRAINT PK_Applications PRIMARY KEY (Id),
        CONSTRAINT CK_Applications_ApplicationKey_NotEmpty CHECK (LEN(ApplicationKey) > 0)
    );