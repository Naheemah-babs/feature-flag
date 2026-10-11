USE FeatureFlagDb;


GO
CREATE UNIQUE INDEX UX_App_Key
    ON dbo.Applications(ApplicationKey) WHERE IsDeleted = 0;

CREATE UNIQUE INDEX UX_User_Email
    ON dbo.Users(Email) WHERE IsDeleted = 0;

CREATE UNIQUE INDEX UX_Feature_App_Key
    ON dbo.Features(ApplicationId, FeatureKey) WHERE IsDeleted = 0;

CREATE UNIQUE INDEX UX_Env_App_Key
    ON dbo.Environments(ApplicationId, EnvironmentKey) WHERE IsDeleted = 0;

CREATE INDEX IX_FeatureSetting_Env
    ON dbo.FeatureSettings(EnvironmentId);

CREATE INDEX IX_UserSetting_Feature_Env
    ON dbo.UserFeatureSettings(FeatureId, EnvironmentId);