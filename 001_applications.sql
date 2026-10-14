IF OBJECT_ID('dbo.Applications', 'U') IS NULL
    CREATE TABLE dbo.Applications (
        Id             UNIQUEIDENTIFIER CONSTRAINT DF_Applications_Id DEFAULT NEWSEQUENTIALID() NOT NULL,
        Name           VARCHAR (100)    NOT NULL,
        ApplicationKey VARCHAR (50)     NOT NULL,
        CreatedAt      DATETIME2        CONSTRAINT DF_Applications_CreatedAt DEFAULT CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2) NOT NULL,
        UpdatedAt      DATETIME2        CONSTRAINT DF_Applications_UpdatedAt DEFAULT CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2) NOT NULL,
        CONSTRAINT PK_Applications PRIMARY KEY (Id),
        CONSTRAINT UQ_Applications_ApplicationKey UNIQUE (ApplicationKey),
        CONSTRAINT CK_Applications_ApplicationKey_NotEmpty CHECK (LEN(ApplicationKey) > 0)
    );