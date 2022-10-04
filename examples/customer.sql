-- Check in env var are initialized
SELECT SYS_CONTEXT('customer_ctx', 'customer_id') customerid FROM DUAL;

EXEC DBMS_SESSION.SET_IDENTIFIER('customer');

SELECT SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER') AS END_USER FROM DUAL;
