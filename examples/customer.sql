-- Check in env var are initialized
SELECT SYS_CONTEXT('customer_ctx', 'customer_id') customerid FROM DUAL;

EXEC DBMS_SESSION.SET_IDENTIFIER('customer');

SELECT SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER') AS END_USER FROM DUAL;

-- Can view their own plan only
SELECT * FROM SYSTEM.CUSTOMER;

-- Can view their own claims only
SELECT * FROM SYSTEM.CLAIM;

-- Can update their own username and email address
UPDATE SYSTEM.CUSTOMER SET USERNAME = 'CSKINNER', EMAIL_ADDRESS = 'c@example.com' WHERE CUSTOMER_ID = '4';

-- Can update their own password
UPDATE SYSTEM.CUSTOMER SET PASSWORD = '^JV%0y$sz41' WHERE CUSTOMER_ID = '4';
