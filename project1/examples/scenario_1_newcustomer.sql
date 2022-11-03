-- || Check if env var are initialized || --
SELECT SYS_CONTEXT('agent_ctx', 'agent_id') agentid FROM DUAL;
SELECT SYS_CONTEXT('customer_ctx', 'customer_id') customerid FROM DUAL;
SELECT SYS_CONTEXT('financer_ctx', 'financer_id') financerid FROM DUAL;
SELECT SYS_CONTEXT('planner_ctx', 'planner_id') plannerid FROM DUAL;

EXEC DBMS_SESSION.SET_IDENTIFIER('agent');
EXEC DBMS_SESSION.SET_IDENTIFIER('customer');
EXEC DBMS_SESSION.SET_IDENTIFIER('financer');
EXEC DBMS_SESSION.SET_IDENTIFIER('planner');

SELECT SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER') AS END_USER FROM DUAL;


-- || Agent: Sees list of plans || --
SELECT PLAN_ID, PLAN_NAME, DESCRIPTION FROM SYSTEM.PLAN;

-- || Agent: Creates new customer || --
-- Note that agent does not need to specify agent_id. agent_id will be set automatically
INSERT INTO SYSTEM.CUSTOMER ( CUSTOMER_ID, USERNAME, PASSWORD, CUSTOMER_NAME, CUSTOMER_NRIC, DATE_OF_BIRTH, DATE_JOINED, ADDRESS, MONTHLY_SALARY, MONTHLY_EXPENSES, MOBILE_NUMBER, EMAIL_ADDRESS, PAYMENT_METHOD_ID ) VALUES ( '7', 'Sheryl', 'o7ytw2Zc&%', 'Sheryl', 'S2345678H', TO_DATE('07-12-1990 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '9665 Sheryl Crest\nHarrisonview, SD 65795', '3000', '300', '91234568', 'sheryl@sheryl.com', '1' );
-- reminder to commit
SELECT * FROM SYSTEM.CUSTOMER;

-- || Customer: Creates new payment method || --
-- for demo purposes, let's assume that Customer with customer_id == '1' as the new customer
INSERT INTO SYSTEM.PAYMENT (  PAYMENT_ID, PAYEE_NAME, MOBILE_NUMBER, BANK_NAME, BRANCH_NAME, ACCOUNT_NUMBER, BANK_CODE ) VALUES ( '11', 'Payee', '91110000', 'POSB', 'Jurong Point', '100889', '1' );
-- reminder to commit

-- || Agent: Assigns payment method to customer || --
-- Agent is able to update the row of his/her own customer
UPDATE (SELECT PAYMENT_METHOD_ID, CUSTOMER_ID FROM SYSTEM.CUSTOMER WHERE CUSTOMER_ID='1') SET PAYMENT_METHOD_ID = '11';
-- reminder to commit
-- Agent is unable to do the same for other customers
UPDATE (SELECT PAYMENT_METHOD_ID, CUSTOMER_ID FROM SYSTEM.CUSTOMER WHERE CUSTOMER_ID='2') SET PAYMENT_METHOD_ID = '11';
-- reminder to commit
SELECT * FROM SYSTEM.CUSTOMER;

-- || Agent: Creates a new insurance purchase by customer || --
INSERT INTO SYSTEM.PURCHASE ( PURCHASE_ID, PLAN_ID, CUSTOMER_ID, AGENT_ID, PLAN_DETAILS, PURCHASE_DATE, PURCHASE_VALUE_SGD, POLICY_START_DATE, POLICY_END_DATE ) VALUES ( '6', '1', '1', '1', 'This plan lasts for 2 years', TO_DATE('6/10/2022', 'DD-MM-YYYY HH24:MI:SS'), '50000', TO_DATE('06-10-2022', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('06-10-2024', 'DD-MM-YYYY HH24:MI:SS') );
-- reminder to commit
SELECT * FROM SYSTEM.PURCHASE;

-- || Customer: Sees purchases || --
-- Customer is able view only his/her own information
SELECT * FROM SYSTEM.PURCHASE;

-- || Financer: Lookups contact information of customer || --
SELECT * FROM SYSTEM.CUSTOMER WHERE CUSTOMER_ID = '1';

-- || Financer: Sees plans that customer has || --
SELECT * FROM SYSTEM.PURCHASE WHERE CUSTOMER_ID = '1';

-- || Financer: Logs premium payments made by customer || --
INSERT INTO SYSTEM.PREMIUM ( PREMIUM_ID, CUSTOMER_ID, PAYMENT_DATE, PAYMENT_VALUE_SGD, BANK_TRANSACTION_ID ) VALUES ( '7', '1', TO_DATE('06-10-2022', 'DD-MM-YYYY HH24:MI:SS'), '20000', 'e2db0-8a45-42a7-04b5b416' );
-- reminder to commit
SELECT * FROM SYSTEM.PREMIUM;

-- || Customer: Verifies premiums paid || --
-- Customer is able to view only his/her own information
SELECT * FROM SYSTEM.PREMIUM;
