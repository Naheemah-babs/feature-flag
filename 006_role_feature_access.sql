IF OBJECT_ID('dbo.RoleFeatureAccess', 'U') IS NULL
    CREATE TABLE dbo.RoleFeatureAccess (
        Id                UNIQUEIDENTIFIER CONSTRAINT DF_RoleFeatureAccess_Id DEFAULT NEWSEQUENTIALID() NOT NULL,
        RoleId     UNIQUEIDENTIFIER NOT NULL,
        FeatureSettingId         UNIQUEIDENTIFIER NOT NULL,
        CreatedAt         DATETIME2        CONSTRAINT DF_RoleFeatureAccess_CreatedAt DEFAULT CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2) NOT NULL,
        UpdatedAt         DATETIME2        CONSTRAINT DF_RoleFeatureAccess_UpdatedAt DEFAULT CAST (SYSDATETIMEOFFSET() AT TIME ZONE 'W. Central Africa Standard Time' AS DATETIME2) NOT NULL,
        CONSTRAINT PK_RoleFeatureAccess PRIMARY KEY (Id),
        CONSTRAINT FK_RoleFeatureAccess_Roles FOREIGN KEY (RoleId) REFERENCES dbo.Roles (Id) ON DELETE CASCADE,
        CONSTRAINT FK_RoleFeatureAccess_FeatureSettings FOREIGN KEY (FeatureSettingId) REFERENCES dbo.FeatureSettings (Id) ON DELETE CASCADE,
        CONSTRAINT UQ_RoleFeatureAccess_Role_Setting UNIQUE (RoleId, FeatureSettingId)
    );