IF OBJECT_ID('dbo.Roles', 'U') IS NULL
    CREATE TABLE dbo.Roles (
        Id        UNIQUEIDENTIFIER CONSTRAINT DF_Roles_Id DEFAULT NEWSEQUENTIALID() NOT NULL,
        Name      VARCHAR (50)     NOT NULL,
        CreatedAt DATETIME2        CONSTRAINT DF_Roles_CreatedAt DEFAULT CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2) NOT NULL,
        UpdatedAt DATETIME2        CONSTRAINT DF_Roles_UpdatedAt DEFAULT CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2) NOT NULL,
        CONSTRAINT PK_Roles PRIMARY KEY (Id),
        CONSTRAINT CK_Roles_Name_NotEmpty CHECK (LEN(Name) > 0),
        CONSTRAINT UQ_Roles_Name UNIQUE (Name)
    );