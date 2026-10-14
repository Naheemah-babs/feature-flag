IF OBJECT_ID('dbo.Features', 'U') IS NULL
    CREATE TABLE dbo.Features (
        Id         UNIQUEIDENTIFIER CONSTRAINT DF_Features_Id DEFAULT NEWSEQUENTIALID() NOT NULL,
        Name       VARCHAR (100)    NOT NULL,
        FeatureKey VARCHAR (100)    NOT NULL,
        CreatedAt  DATETIME2        CONSTRAINT DF_Features_CreatedAt DEFAULT CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2) NOT NULL,
        UpdatedAt  DATETIME2        CONSTRAINT DF_Features_UpdatedAt DEFAULT CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2) NOT NULL,
        CONSTRAINT PK_Features PRIMARY KEY (Id),
        CONSTRAINT UQ_Features_FeatureKey UNIQUE (FeatureKey),
        CONSTRAINT CK_Features_FeatureKey_NotEmpty CHECK (LEN(FeatureKey) > 0)
    );