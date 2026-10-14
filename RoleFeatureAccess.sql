CREATE TABLE RoleFeatureAccess(
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    RoleId BIGINT UNSIGNED NOT NULL,
    FeatureSettingId BIGINT UNSIGNED NOT NULL,

    CreatedAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    UpdatedAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),

    CONSTRAINT uq_RoleFeature_settings UNIQUE (RoleId, featureSettingId),
    KEY IX_RoleFeatureAccess_FeatureSettingId (FeatureSettingId),
    CONSTRAINT Fk_RoleFeatureAccess_Roles FOREIGN KEY (RoleId) REFERENCES Roles (Id),
    CONSTRAINT fk_RoleFeatureAccess_FeatureSettings FOREIGN KEY (featureSettingId) REFERENCES featuresettings (Id)
)