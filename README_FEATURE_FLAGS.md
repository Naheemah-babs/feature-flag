# Feature Flag Management Database

A MySQL schema for managing applications, feature flags, environments,
and user-specific feature overrides.

## Overview

The database contains six tables:

-   `Applications` --- registered applications.
-   `Features` --- feature flags owned by applications.
-   `Environments` --- environments belonging to applications, such as
    development, staging, and production.
-   `Feature_Settings` --- the enabled/disabled state of a feature for
    an application environment.
-   `Users` --- users who can receive individual feature overrides.
-   `User_Feature_Settings` --- per-user feature settings for an
    environment.

The schema stores feature settings; the backend service determines how
those settings are evaluated when deciding whether a feature should be
available.

## Requirements and Setup

Use MySQL with support for generated stored columns, `UUID()`, and
fractional-second timestamps. MySQL 8.0 or a compatible version is
recommended.

1.  Start MySQL and connect using MySQL Workbench or another SQL client.

2.  Create and select a database if needed:

    ``` sql
    CREATE DATABASE feature_flag_management;
    USE feature_flag_management;
    ```

3.  Run the `CREATE TABLE` statements in this order: `Applications`,
    `Features`, `Environments`, `Feature_Settings`, `Users`,
    `User_Feature_Settings`.

4.  Verify the tables:

    ``` sql
    SHOW TABLES;
    ```

The script does not create or select a database by itself.

## Tables and Relationships

### `Applications`

Stores an application's `Id`, `Name`, and `ApplicationKey`, along with
creation/update timestamps and `IsDeleted`.

-   `Id` is the primary key and defaults to `UUID()`.
-   `ActiveApplicationKey` is generated from `ApplicationKey` while the
    record is active; it is `NULL` when `IsDeleted = 1`.
-   A unique constraint on `ActiveApplicationKey` prevents duplicate
    keys among active applications while allowing a key to be reused
    after soft deletion.

### `Features`

Stores `Name` and `FeatureKey` for a feature, linked to its owning
application through `ApplicationId`.

-   `Id` is the primary key; `ApplicationId` references `Applications`.
-   `ActiveFeatureKey` is generated from `FeatureKey` for active
    records.
-   A unique constraint on `(ApplicationId, ActiveFeatureKey)` makes
    active feature keys unique within each application.
-   A unique constraint on `(Id, ApplicationId)` supports composite
    foreign-key checks from `Feature_Settings`.

### `Environments`

Stores environment names and keys for an application.

-   `ApplicationId` references `Applications`.
-   `ActiveEnvironmentKey` is generated from `EnvironmentKey` for active
    records.
-   A unique constraint on `(ApplicationId, ActiveEnvironmentKey)` makes
    active environment keys unique within each application.
-   A unique constraint on `(Id, ApplicationId)` supports composite
    foreign-key checks from `Feature_Settings`.

### `Feature_Settings`

Stores the application-level state of a feature in an environment.

-   `FeatureId`, `EnvironmentId`, and `ApplicationId` form the composite
    primary key.
-   `IsEnabled` defaults to `1` (`1` = enabled, `0` = disabled).
-   Composite foreign keys ensure the feature and environment both
    belong to the specified application.
-   `UpdatedAt` refreshes automatically when the row is updated.

There can be one setting for each feature/environment/application
combination.

### `Users`

Stores user details: `Name`, `Email`, optional `DateOfBirth`,
timestamps, and `IsDeleted`.

-   `Id` is the primary key and defaults to `UUID()`.
-   `ActiveEmail` is generated from `Email` while the user is active and
    becomes `NULL` after soft deletion.
-   A unique constraint on `ActiveEmail` prevents duplicate active email
    values while allowing a deleted user's email to be reused.

### `User_Feature_Settings`

Stores a user's feature state in an environment.

-   The composite primary key is `(UserId, FeatureId, EnvironmentId)`.
-   `IsEnabled` defaults to `1` (`1` = enabled, `0` = disabled).
-   Foreign keys require the user, feature, and environment to exist.
-   There can be one user-specific setting per user, feature, and
    environment.

## How Feature Settings Work

-   **Application setting:** `Feature_Settings` defines whether a
    feature is enabled in an environment for the application.
-   **User override:** `User_Feature_Settings` stores a user-specific
    enabled/disabled value.
-   **Evaluation policy:** The schema does not define precedence. A
    common backend policy is to use a matching user override when one
    exists, otherwise use the application/environment setting. Your
    service should define what happens if neither setting exists.

## Example Queries

The `?` symbols below are prepared-statement placeholders. Bind actual
IDs in the application or SQL client.

### List active applications

``` sql
SELECT Id, Name, ApplicationKey
FROM Applications
WHERE IsDeleted = 0;
```

### List active features for an application

``` sql
SELECT Id, Name, FeatureKey
FROM Features
WHERE ApplicationId = ?
  AND IsDeleted = 0;
```

### List active environments for an application

``` sql
SELECT Id, Name, EnvironmentKey
FROM Environments
WHERE ApplicationId = ?
  AND IsDeleted = 0;
```

### Read a feature's application/environment setting

``` sql
SELECT IsEnabled, UpdatedAt
FROM Feature_Settings
WHERE ApplicationId = ?
  AND FeatureId = ?
  AND EnvironmentId = ?;
```

### Read a user's override

``` sql
SELECT IsEnabled, UpdatedAt
FROM User_Feature_Settings
WHERE UserId = ?
  AND FeatureId = ?
  AND EnvironmentId = ?;
```

### Create an application

``` sql
INSERT INTO Applications (Name, ApplicationKey)
VALUES ('My Application', 'my-application');
```

### Create a feature

``` sql
INSERT INTO Features (ApplicationId, Name, FeatureKey)
VALUES (?, 'New Dashboard', 'new-dashboard');
```

### Set an application/environment feature state

``` sql
INSERT INTO Feature_Settings
    (FeatureId, EnvironmentId, ApplicationId, IsEnabled)
VALUES (?, ?, ?, 1)
ON DUPLICATE KEY UPDATE
    IsEnabled = VALUES(IsEnabled);
```

### Set or update a user override

``` sql
INSERT INTO User_Feature_Settings
    (UserId, FeatureId, EnvironmentId, IsEnabled)
VALUES (?, ?, ?, 0)
ON DUPLICATE KEY UPDATE
    IsEnabled = VALUES(IsEnabled);
```

### Soft-delete an application

``` sql
UPDATE Applications
SET IsDeleted = 1
WHERE Id = ?;
```

Soft deletion marks the record; it does not physically delete it or
automatically soft-delete related records.

## Important Notes

-   **Soft deletes:** `Applications`, `Features`, `Environments`, and
    `Users` use `IsDeleted`. Queries should filter deleted records when
    appropriate. The settings tables do not have an `IsDeleted` column.
-   **User-setting consistency:** `User_Feature_Settings` has no
    `ApplicationId` and its feature/environment foreign keys are
    separate. The database therefore does not guarantee that the feature
    and environment belong to the same application. Enforce this in
    backend logic or consider adding `ApplicationId` with composite
    foreign keys.
-   **No automatic setting rows:** Creating a feature does not
    automatically create settings for every environment. Your service
    should create needed rows or define behavior when a setting is
    missing.
-   **Soft deletion is not cascading:** Marking an application deleted
    does not automatically mark its features or environments as deleted.
-   **Key scope:** Active feature keys and environment keys are unique
    per application, not globally.
-   **Restoring records:** Restoring a deleted application, feature,
    environment, or user may fail if its active key or email is already
    used by another active record.
-   **Transactions:** Use transactions when several related writes must
    succeed or fail together.
