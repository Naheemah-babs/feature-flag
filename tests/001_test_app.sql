-- Checks that the defaults on Applications fill in automatically.
USE FeatureFlagDb;

INSERT  INTO dbo.Applications (
    Name,
    ApplicationKey
)
VALUES                        ('Billing Portal', 'test-billing-portal');

SELECT *
FROM   dbo.Applications
WHERE  ApplicationKey = 'test-billing-portal';

DELETE dbo.Applications
WHERE  ApplicationKey = 'test-billing-portal';