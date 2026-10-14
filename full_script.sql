-- ============================================================
-- FEATURE FLAG MANAGEMENT SYSTEM
-- Database: MySQL
-- Storage Engine: InnoDB
-- Recommended Version: MySQL 8.0.16+
-- ============================================================

CREATE DATABASE IF NOT EXISTS feature_flag_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE feature_flag_db;


-- ============================================================
-- 1. APPLICATIONS
-- Registers applications that use the feature flag system.
-- ============================================================

CREATE TABLE IF NOT EXISTS applications (
    id BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),

    name VARCHAR(100) NOT NULL,

    application_key VARCHAR(100) NOT NULL,

    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    updated_at DATETIME(6) NOT NULL
        DEFAULT CURRENT_TIMESTAMP(6)
        ON UPDATE CURRENT_TIMESTAMP(6),

    PRIMARY KEY (id),

    CONSTRAINT uq_applications_application_key
        UNIQUE (application_key)

) ENGINE = InnoDB
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;


-- ============================================================
-- 2. FEATURES
-- Defines features that can be configured for applications.
--
-- A feature can appear in multiple applications.
-- FeatureKey is globally unique, as indicated by the ERD.
-- ============================================================

CREATE TABLE IF NOT EXISTS features (
    id BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),

    name VARCHAR(100) NOT NULL,

    feature_key VARCHAR(100) NOT NULL,

    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    updated_at DATETIME(6) NOT NULL
        DEFAULT CURRENT_TIMESTAMP(6)
        ON UPDATE CURRENT_TIMESTAMP(6),

    PRIMARY KEY (id),

    CONSTRAINT uq_features_feature_key
        UNIQUE (feature_key)

) ENGINE = InnoDB
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;


-- ============================================================
-- 3. FEATURE_SETTINGS
-- Configures a feature for a particular application.
--
-- Controls:
--   is_enabled         : Whether the feature is enabled.
--   is_released        : Whether the feature is released.
--   rollout_percentage : Percentage of eligible users targeted.
--
-- Each application can configure a particular feature once.
-- ============================================================

CREATE TABLE IF NOT EXISTS feature_settings (
    id BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),

    application_id BINARY(16) NOT NULL,

    feature_id BINARY(16) NOT NULL,

    is_enabled BOOLEAN NOT NULL DEFAULT FALSE,

    is_released BOOLEAN NOT NULL DEFAULT FALSE,

    rollout_percentage TINYINT UNSIGNED NOT NULL DEFAULT 0,

    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    updated_at DATETIME(6) NOT NULL
        DEFAULT CURRENT_TIMESTAMP(6)
        ON UPDATE CURRENT_TIMESTAMP(6),

    PRIMARY KEY (id),

    CONSTRAINT uq_feature_settings_application_feature
        UNIQUE (application_id, feature_id),

    CONSTRAINT chk_feature_settings_rollout_percentage
        CHECK (rollout_percentage BETWEEN 0 AND 100),

    CONSTRAINT fk_feature_settings_application
        FOREIGN KEY (application_id)
        REFERENCES applications (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE,

    CONSTRAINT fk_feature_settings_feature
        FOREIGN KEY (feature_id)
        REFERENCES features (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE,

    INDEX idx_feature_settings_feature_id (feature_id),

    INDEX idx_feature_settings_application_enabled (
        application_id,
        is_enabled
    )

) ENGINE = InnoDB
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;


-- ============================================================
-- 4. ROLES
-- Defines roles used for authorization.
--
-- Examples:
--   Administrator
--   Manager
--   Developer
--   Viewer
-- ============================================================

CREATE TABLE IF NOT EXISTS roles (
    id BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),

    name VARCHAR(100) NOT NULL,

    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    updated_at DATETIME(6) NOT NULL
        DEFAULT CURRENT_TIMESTAMP(6)
        ON UPDATE CURRENT_TIMESTAMP(6),

    PRIMARY KEY (id),

    CONSTRAINT uq_roles_name
        UNIQUE (name)

) ENGINE = InnoDB
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;


-- ============================================================
-- 5. USERS
-- Stores users and their assigned roles.
--
-- Every user must have an assigned role.
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
    id BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),

    role_id BINARY(16) NOT NULL,

    name VARCHAR(100) NOT NULL,

    email VARCHAR(254) NOT NULL,

    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    updated_at DATETIME(6) NOT NULL
        DEFAULT CURRENT_TIMESTAMP(6)
        ON UPDATE CURRENT_TIMESTAMP(6),

    PRIMARY KEY (id),

    CONSTRAINT uq_users_email
        UNIQUE (email),

    CONSTRAINT fk_users_role
        FOREIGN KEY (role_id)
        REFERENCES roles (id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    INDEX idx_users_role_id (role_id)

) ENGINE = InnoDB
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;


-- ============================================================
-- 6. ROLE_FEATURE_ACCESS
-- Grants roles access to feature settings.
--
-- A role can be associated with multiple feature settings.
-- A feature setting can be granted to multiple roles.
-- ============================================================

CREATE TABLE IF NOT EXISTS role_feature_access (
    id BINARY(16) NOT NULL DEFAULT (UUID_TO_BIN(UUID())),

    role_id BINARY(16) NOT NULL,

    feature_setting_id BINARY(16) NOT NULL,

    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    updated_at DATETIME(6) NOT NULL
        DEFAULT CURRENT_TIMESTAMP(6)
        ON UPDATE CURRENT_TIMESTAMP(6),

    PRIMARY KEY (id),

    CONSTRAINT uq_role_feature_access
        UNIQUE (role_id, feature_setting_id),

    CONSTRAINT fk_role_feature_access_role
        FOREIGN KEY (role_id)
        REFERENCES roles (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE,

    CONSTRAINT fk_role_feature_access_feature_setting
        FOREIGN KEY (feature_setting_id)
        REFERENCES feature_settings (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE,

    INDEX idx_role_feature_access_feature_setting (
        feature_setting_id
    )

) ENGINE = InnoDB
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;


-- ============================================================
-- END OF SCHEMA
-- ============================================================