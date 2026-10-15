# Feature Management Database

## Overview

This database provides the foundation for a feature management system built with MySQL and the InnoDB storage engine.

It supports registering applications, defining reusable features, configuring feature availability per application, managing user roles, and associating roles with feature settings.

The schema uses relational constraints to maintain data integrity and includes timestamps for tracking record creation and modification.

## Technologies

- **Database:** MySQL 8.0.16
- **Storage engine:** InnoDB
- **SQL features:** Foreign keys, unique constraints, CHECK constraints, auto-incrementing IDs, and automatic timestamps
- **Intended backend:** C# / .NET

MySQL 8.0.16 or later is recommended because this schema relies on enforced `CHECK` constraints.

## Database Structure
![Entity Relationship Diagram](./images/ERDV2.png)
The database contains six tables:

| Table | Purpose |
|---|---|
| `Applications` | Stores applications registered with the feature management system. |
| `Feature` | Defines features that can be configured for applications. |
| `Roles` | Stores the roles available within the system. |
| `FeatureSettings` | Configures each feature for a particular application. |
| `Users` | Stores users and their assigned roles. |
| `RoleFeatureAccess` | Associates roles with specific feature settings. |

## Table Definitions

### 1. Applications

Stores the applications registered with the system.

**Columns**

- `Id`: Auto-incrementing unsigned identifier and primary key.
- `Name`: Display name of the application.
- `ApplicationKey`: Unique identifier used to reference the application.
- `CreatedAt`: Timestamp recorded when the row is created.
- `UpdatedAt`: Timestamp automatically updated when the row changes.

**Constraints**

- `Id` is the primary key.
- `ApplicationKey` must be unique.
- `Name` and `ApplicationKey` cannot be NULL.

### 2. Feature

Stores feature definitions that can be configured for different applications.

**Columns**

- `Id`: Auto-incrementing unsigned identifier and primary key.
- `Name`: Display name of the feature.
- `FeatureKey`: Unique identifier for the feature.
- `CreatedAt`: Record creation timestamp.
- `UpdatedAt`: Automatically maintained modification timestamp.

**Constraints**

- `Id` is the primary key.
- `FeatureKey` must be unique.
- `Name` and `FeatureKey` cannot be NULL.

A feature definition is separate from its application-specific settings. This allows the same feature to be configured independently for multiple applications.

### 3. Roles

Stores the roles that can be assigned to users and associated with feature settings.

**Columns**

- `Id`: Auto-incrementing unsigned identifier and primary key.
- `Name`: Unique role name.
- `CreatedAt`: Record creation timestamp.
- `UpdatedAt`: Automatically maintained modification timestamp.

**Constraints**

- `Id` is the primary key.
- `Name` must be unique and cannot be NULL.

The current design allows each user to have one role through the `Users.RoleId` relationship.

### 4. FeatureSettings

Stores the configuration of a feature for a particular application.

**Columns**

- `Id`: Auto-incrementing unsigned identifier and primary key.
- `ApplicationId`: References the application receiving the configuration.
- `FeatureId`: References the feature being configured.
- `IsEnabled`: Indicates whether the feature is enabled.
- `IsReleased`: Indicates whether the feature has been marked as fully released.
- `RolloutPercentage`: Percentage associated with the feature rollout.
- `CreatedAt`: Record creation timestamp.
- `UpdatedAt`: Automatically maintained modification timestamp.

**Constraints**

- `ApplicationId` references `Applications.Id`.
- `FeatureId` references `Feature.Id`.
- The combination of `ApplicationId` and `FeatureId` must be unique.
- `IsEnabled` must be `0` or `1`.
- `IsReleased` must be `0` or `1`.
- `RolloutPercentage` must be between `0` and `100`.
- When `IsReleased` is `1`, `RolloutPercentage` must be `100`.

**Rollout behavior**

- `IsEnabled = 0`: The feature is disabled.
- `IsEnabled = 1`: The feature is enabled at the configuration level.
- `IsReleased = 0`: The feature is not marked as fully released.
- `IsReleased = 1`: The feature is marked as fully released, with a rollout percentage of `100`.

These fields represent configuration, not the complete runtime evaluation logic. The application must determine how enabled status, release status, rollout percentage, and any user targeting rules combine to decide whether a feature should be available.

The database constraint does not require `IsEnabled` to be `1` when `IsReleased` is `1`. Enforce that additional rule separately if it is required by the business logic.

### 5. Users

Stores users and their assigned roles.

**Columns**

- `Id`: Auto-incrementing unsigned identifier and primary key.
- `RoleId`: References the user's assigned role.
- `Name`: User's name.
- `Email`: Unique email address.
- `CreatedAt`: Record creation timestamp.
- `UpdatedAt`: Automatically maintained modification timestamp.

**Constraints**

- `Id` is the primary key.
- `RoleId` references `Roles.Id`.
- `Email` must be unique.
- `RoleId`, `Name`, and `Email` cannot be NULL.

Every user must be assigned an existing role.

### 6. RoleFeatureAccess

Associates a role with a particular feature setting.

**Columns**

- `Id`: Auto-incrementing integer primary key.
- `RoleId`: References the role receiving the association.
- `FeatureSettingId`: References the application-specific feature setting.
- `CreatedAt`: Record creation timestamp.
- `UpdatedAt`: Automatically maintained modification timestamp.

**Constraints**

- `RoleId` references `Roles.Id`.
- `FeatureSettingId` references `FeatureSettings.Id`.
- The combination of `RoleId` and `FeatureSettingId` must be unique.
- An index is created on `FeatureSettingId` to support lookups by feature setting.

This table prevents duplicate associations between the same role and feature setting.

The table represents a relationship only; it does not define separate permission levels such as read, update, or administer. Those would require additional authorization rules or schema changes.

## Relationships

The database relationships are:

- `Applications` → `FeatureSettings`: One application can have many feature settings.
- `Feature` → `FeatureSettings`: One feature can have settings for many applications.
- `Roles` → `Users`: One role can be assigned to many users.
- `Roles` → `RoleFeatureAccess`: One role can have many feature access associations.
- `FeatureSettings` → `RoleFeatureAccess`: One feature setting can be associated with many roles.

The unique constraint on `(ApplicationId, FeatureId)` ensures that a feature has only one configuration row per application.

The unique constraint on `(RoleId, FeatureSettingId)` ensures that a role cannot be associated with the same feature setting more than once.

## Referential Integrity

The schema uses foreign keys to prevent references to nonexistent parent records.

For `FeatureSettings`, the foreign keys explicitly use:

- `ON DELETE RESTRICT`: Prevents deleting an application or feature while it is referenced by a feature setting.
- `ON UPDATE CASCADE`: Propagates a referenced identifier change to dependent rows.

The foreign keys in `Users` and `RoleFeatureAccess` use MySQL's default referential actions because no explicit actions are specified.

## Timestamp Convention

All six tables use:

```sql
CreatedAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
UpdatedAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
    ON UPDATE CURRENT_TIMESTAMP(3)
```

`DATETIME(3)` stores fractional seconds to millisecond precision.

- `CreatedAt` is populated automatically when a row is inserted.
- `UpdatedAt` is populated on insertion and automatically refreshed when the row changes.

The timestamps use the database session's current time convention. Applications should configure their database sessions and timestamp handling consistently, preferably using UTC.

## Installation

### Prerequisites

- MySQL Server 8.0.16 or later.
- MySQL Workbench or another MySQL client.
- An account with permission to create tables and constraints.

### Step 1: Create a database

```sql
CREATE DATABASE FeatureManagement
    CHARACTER SET utf8mb4;

USE FeatureManagement;
```

If your project already has a database, select that database instead.

### Step 2: Execute the SQL script

Run the table creation statements in the following order:

1. `Applications`
2. `Feature`
3. `Roles`
4. `FeatureSettings`
5. `Users`
6. `RoleFeatureAccess`

This order ensures that the referenced tables exist before the dependent foreign keys are created.

### Step 3: Verify the tables

```sql
SHOW TABLES;
```

To inspect an individual table:

```sql
DESCRIBE Applications;
DESCRIBE Feature;
DESCRIBE Roles;
DESCRIBE FeatureSettings;
DESCRIBE Users;
DESCRIBE RoleFeatureAccess;
```

To inspect foreign keys and other table definitions:

```sql
SHOW CREATE TABLE FeatureSettings;
SHOW CREATE TABLE Users;
SHOW CREATE TABLE RoleFeatureAccess;
```

## Example Usage

### Register an application

```sql
INSERT INTO Applications (Name, ApplicationKey)
VALUES ('Customer Portal', 'CUSTOMER_PORTAL');
```

### Create a feature

```sql
INSERT INTO Feature (Name, FeatureKey)
VALUES ('New Dashboard', 'NEW_DASHBOARD');
```

### Create a role

```sql
INSERT INTO Roles (Name)
VALUES ('Administrator');
```

### Configure a feature for an application

The following example assumes the application and feature have already been created.

```sql
INSERT INTO FeatureSettings (
    ApplicationId,
    FeatureId,
    IsEnabled,
    IsReleased,
    RolloutPercentage
)
VALUES (
    1,
    1,
    TRUE,
    FALSE,
    25
);
```

This example configures the feature as enabled but not fully released, with a rollout percentage of `25`.

### Create a user

```sql
INSERT INTO Users (RoleId, Name, Email)
VALUES (
    1,
    'Example User',
    'user@example.com'
);
```

The referenced role must already exist.

### Associate a role with a feature setting

```sql
INSERT INTO RoleFeatureAccess (RoleId, FeatureSettingId)
VALUES (1, 1);
```

Both referenced records must exist before the association can be created.

### Retrieve enabled features for an application

```sql
SELECT
    a.Name AS ApplicationName,
    f.Name AS FeatureName,
    fs.IsEnabled,
    fs.IsReleased,
    fs.RolloutPercentage
FROM FeatureSettings AS fs
INNER JOIN Applications AS a
    ON a.Id = fs.ApplicationId
INNER JOIN Feature AS f
    ON f.Id = fs.FeatureId
WHERE a.ApplicationKey = 'CUSTOMER_PORTAL'
  AND fs.IsEnabled = TRUE;
```

This query retrieves enabled feature configurations. It does not evaluate percentage-based user targeting or role authorization.

## Data Integrity and Validation

The database enforces several rules:

- Duplicate application keys are rejected.
- Duplicate feature keys are rejected.
- Duplicate role names are rejected.
- Duplicate user email addresses are rejected.
- Duplicate application-feature configurations are rejected.
- Duplicate role-feature-setting associations are rejected.
- Invalid Boolean values and rollout percentages are rejected by enforced `CHECK` constraints.
- Foreign keys prevent invalid references to parent records.

The application should still validate incoming requests and enforce authorization. Database constraints complement application-level validation rather than replacing it.

## Important Design Notes

1. **Feature evaluation:** The backend must implement the rules for evaluating enabled status, release status, rollout percentage, and any targeting conditions.
2. **Role authorization:** `RoleFeatureAccess` records associations but does not automatically enforce authorization in application endpoints.
3. **Single-role users:** The current `Users` table supports one role per user. A many-to-many user-role relationship would require a separate junction table.
4. **Key comparison:** Unique string keys follow the selected MySQL collation rules. Confirm whether application keys, feature keys, and emails should be case-sensitive.
5. **Identifier consistency:** Most primary keys use `BIGINT UNSIGNED`, while `RoleFeatureAccess.Id` uses `INT`. This is valid but should be standardized if consistent identifier sizing is a project requirement.
6. **Constraint enforcement:** Use a MySQL version that enforces `CHECK` constraints; MySQL 8.0.16 or later is recommended.
7. **Security:** Credentials, authentication secrets, and other sensitive application data should not be stored in these tables without an explicit requirement and appropriate security design.

## Summary

This schema establishes the core relational structure for application registration, feature configuration, user roles, and role-to-feature associations.

Its primary goals are to maintain referential integrity, prevent duplicate configurations, validate rollout values, and maintain creation and modification timestamps.

The database is a foundation for a feature management backend. Runtime feature evaluation, percentage-based targeting, and endpoint authorization must be implemented and tested in the application layer.
