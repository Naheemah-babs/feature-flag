IF OBJECT_ID('dbo.Users', 'U') IS NULL
    CREATE TABLE dbo.Users (
        Id        UNIQUEIDENTIFIER CONSTRAINT DF_Users_Id DEFAULT NEWSEQUENTIALID() NOT NULL,
        RoleId    UNIQUEIDENTIFIER NOT NULL,
        Name      VARCHAR (100)    NOT NULL,
        Email     VARCHAR (254)    NOT NULL,
        CreatedAt DATETIME2        CONSTRAINT DF_Users_CreatedAt DEFAULT CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2) NOT NULL,
        UpdatedAt DATETIME2        CONSTRAINT DF_Users_UpdatedAt DEFAULT CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2) NOT NULL,
        CONSTRAINT PK_Users PRIMARY KEY (Id),
        CONSTRAINT UQ_Users_Email UNIQUE (Email),
        CONSTRAINT CK_Users_Email_NotEmpty CHECK (LEN(Email) > 0),
        CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId) REFERENCES dbo.Roles (Id)
    );