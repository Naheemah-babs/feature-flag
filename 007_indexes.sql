CREATE INDEX IX_Users_RoleId
    ON dbo.Users(RoleId);

CREATE INDEX IX_FeatureSettings_FeatureId
    ON dbo.FeatureSettings(FeatureId);

CREATE INDEX IX_RoleFeatureAccess_FeatureSettingId
    ON dbo.RoleFeatureAccess(FeatureSettingId);