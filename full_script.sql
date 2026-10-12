CREATE TABLE Applications (
    Id CHAR(36) NOT NULL DEFAULT (UUID()),
    Name VARCHAR(100) NOT NULL,
    ApplicationKey VARCHAR(50) NOT NULL,
    CreatedAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    UpdatedAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    IsDeleted TINYINT(1) NOT NULL DEFAULT 0,
    ActiveApplicationKey VARCHAR(50) GENERATED ALWAYS AS (IF(IsDeleted = 0, ApplicationKey, NULL)) STORED,
   
    CONSTRAINT PK_Applications PRIMARY KEY (Id),
    CONSTRAINT UX_Applications_ApplicationKey_Active UNIQUE (ActiveApplicationKey)
);
 
CREATE TABLE Features (
    Id CHAR(36) NOT NULL DEFAULT (UUID()),
    ApplicationId CHAR(36) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    FeatureKey VARCHAR(100) NOT NULL,
    CreatedAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    UpdatedAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    IsDeleted TINYINT(1) NOT NULL DEFAULT 0,
    ActiveFeatureKey VARCHAR(100) GENERATED ALWAYS AS (IF(IsDeleted = 0, FeatureKey, NULL)) STORED,
 
    CONSTRAINT PK_Features PRIMARY KEY (Id),
    CONSTRAINT FK_Features_Applications
        FOREIGN KEY (ApplicationId) REFERENCES Applications (Id),
    CONSTRAINT UQ_Features_Id_ApplicationId UNIQUE (Id, ApplicationId),
    CONSTRAINT UX_Features_ApplicationId_FeatureKey_Active UNIQUE (ApplicationId, ActiveFeatureKey)
);
 
CREATE TABLE Environments (
    Id CHAR(36) NOT NULL DEFAULT (UUID()),
    ApplicationId CHAR(36) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    EnvironmentKey VARCHAR(50) NOT NULL,
    CreatedAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    UpdatedAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    IsDeleted TINYINT(1) NOT NULL DEFAULT 0,
    ActiveEnvironmentKey VARCHAR(50) GENERATED ALWAYS AS (IF(IsDeleted = 0, EnvironmentKey, NULL)) STORED,
 
    CONSTRAINT PK_Environments PRIMARY KEY (Id),
    CONSTRAINT FK_Environments_Applications
        FOREIGN KEY (ApplicationId) REFERENCES Applications (Id),
    CONSTRAINT UQ_Environments_Id_ApplicationId UNIQUE (Id, ApplicationId),
    CONSTRAINT UX_Environments_ApplicationId_EnvironmentKey_Active UNIQUE (ApplicationId, ActiveEnvironmentKey)
);
 
CREATE TABLE Feature_Settings (
    FeatureId CHAR(36) NOT NULL,
    EnvironmentId CHAR(36) NOT NULL,
    ApplicationId CHAR(36) NOT NULL,
    IsEnabled TINYINT(1) NOT NULL DEFAULT 1,
    UpdatedAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
 
    CONSTRAINT PK_Feature_Settings
        PRIMARY KEY (FeatureId, EnvironmentId, ApplicationId),
    CONSTRAINT FK_Feature_Settings_Features
        FOREIGN KEY (FeatureId, ApplicationId)
        REFERENCES Features (Id, ApplicationId),
    CONSTRAINT FK_Feature_Settings_Environments
        FOREIGN KEY (EnvironmentId, ApplicationId)
        REFERENCES Environments (Id, ApplicationId)
);
 
CREATE TABLE Users (
    Id CHAR(36) NOT NULL DEFAULT (UUID()),
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(254) NOT NULL,
    DateOfBirth DATE NULL,
    CreatedAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    UpdatedAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    IsDeleted TINYINT(1) NOT NULL DEFAULT 0,
    ActiveEmail VARCHAR(254) GENERATED ALWAYS AS (IF(IsDeleted = 0, Email, NULL)) STORED,
 
    CONSTRAINT PK_Users PRIMARY KEY (Id),
    CONSTRAINT UX_Users_Email_Active UNIQUE (ActiveEmail)
);
 
CREATE TABLE User_Feature_Settings (
    UserId CHAR(36) NOT NULL,
    FeatureId CHAR(36) NOT NULL,
    EnvironmentId CHAR(36) NOT NULL,
    IsEnabled TINYINT(1) NOT NULL DEFAULT 1,
    UpdatedAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
 
    CONSTRAINT PK_User_Feature_Settings
        PRIMARY KEY (UserId, FeatureId, EnvironmentId),
    CONSTRAINT FK_User_Feature_Settings_Users
        FOREIGN KEY (UserId) REFERENCES Users (Id),
    CONSTRAINT FK_User_Feature_Settings_Features
        FOREIGN KEY (FeatureId) REFERENCES Features (Id),
    CONSTRAINT FK_User_Feature_Settings_Environments
        FOREIGN KEY (EnvironmentId) REFERENCES Environments (Id)
);

show tables;
desc applications;