CREATE TABLE FeatureSettings (
    Id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ApplicationId     BIGINT UNSIGNED NOT NULL,
    FeatureId         BIGINT UNSIGNED NOT NULL,
    IsEnabled         BOOLEAN         NOT NULL DEFAULT FALSE,
    IsReleased        BOOLEAN         NOT NULL DEFAULT FALSE,
    RolloutPercentage INT UNSIGNED    NOT NULL DEFAULT 0,
    CreatedAt         DATETIME(3)     NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    UpdatedAt         DATETIME(3)     NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
                                      ON UPDATE CURRENT_TIMESTAMP(3),

    CONSTRAINT UQ_FeatureSettings_App_Feature UNIQUE (ApplicationId, FeatureId),
    CONSTRAINT FK_FeatureSettings_Applications FOREIGN KEY (ApplicationId) REFERENCES Applications (Id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FK_FeatureSettings_Features FOREIGN KEY (FeatureId) REFERENCES Feature (Id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT CK_FeatureSettings_IsEnabled_Bool CHECK (IsEnabled IN (0, 1)),
    CONSTRAINT CK_FeatureSettings_IsReleased_Bool CHECK (IsReleased IN (0, 1)),
    CONSTRAINT CK_FeatureSettings_Rollout_Range CHECK (RolloutPercentage BETWEEN 0 AND 100),
    CONSTRAINT CK_FeatureSettings_Released_Is_Full CHECK (IsReleased = 0 OR RolloutPercentage = 100)
);