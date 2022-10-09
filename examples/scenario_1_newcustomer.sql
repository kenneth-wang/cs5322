-- Agent: See list of plans
SELECT PLAN_ID, PLAN_NAME, DESCRIPTION FROM SYSTEM.PLAN;

-- Agent: Create new customer
INSERT INTO SYSTEM.CUSTOMER ( CUSTOMER_ID, USERNAME, PASSWORD, CUSTOMER_NAME, CUSTOMER_NRIC, DATE_OF_BIRTH, DATE_JOINED, ADDRESS, MONTHLY_SALARY, MONTHLY_EXPENSES, MOBILE_NUMBER, EMAIL_ADDRESS, PAYMENT_METHOD_ID, AGENT_ID ) VALUES ( '7', 'Sheryl', 'o7ytw2Zc&%', 'Sheryl', 'S2345678H', TO_DATE('07-12-1990 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '9665 Sheryl Crest\nHarrisonview, SD 65795', '3000', '300', '91234568', 'sheryl@sheryl.com', '1', '5' );

-- Customer: Create new payment method
INSERT INTO SYSTEM.PAYMENT (  PAYMENT_ID, PAYEE_NAME, MOBILE_NUMBER, BANK_NAME, BRANCH_NAME, ACCOUNT_NUMBER, BANK_CODE ) VALUES ( '11', 'Payee', '91110000', 'POSB', 'Jurong Point', '100889', '1' );

-- Agent: Assign payment method to customer
UPDATE SYSTEM.CUSTOMER SET PAYMENT_ID = '11' WHERE CUSTOMER_ID = '7';

-- Agent: Create a new insurance purchase by customer
INSERT INTO SYSTEM.PURCHASE ( PLAN_ID, CUSTOMER_ID, AGENT_ID, PLAN_DETAILS, PURCHASE_DATE, PURCHASE_VALUE_SGD, POLICY_START_DATE, POLICY_END_DATE ) VALUES ( '21', '7', '5', 'This plan lasts for 2 years', TO_DATE('6/10/2022', 'DD-MM-YYYY HH24:MI:SS'), '50000', TO_DATE('06-10-2022', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('06-10-2024', 'DD-MM-YYYY HH24:MI:SS') );

-- Customer: See purchases
SELECT * FROM SYSTEM.PURCHASE;

-- Financer: Lookup contact information of customer
SELECT NAME, MOBILE_NUMBER, EMAIL_ADDRESS FROM SYSTEM.CUSTOMER WHERE CUSTOMER_ID = '7';

-- Financer: See plans that customer has
SELECT * FROM SYSTEM.PLAN WHERE CUSTOMER_ID = '7';

-- Financer: Log premium purchases made by customer
INSERT INTO SYSTEM.PREMIUM ( PREMIUM_ID, CUSTOMER_ID, PAYMENT_DATE, PAYMENT_VALUE_SGD, BANK_TRANSACTION_ID ) VALUES ( '7', '6', TO_DATE('06-10-2022', 'DD-MM-YYYY HH24:MI:SS'), '20000', 'e2db0-8a45-42a7-04b5b416' );

-- Customer: Verify premiums paid
SELECT * FROM SYSTEM.PREMIUM;
