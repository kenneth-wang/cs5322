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

-- || Agent: Finds customer ID || --
-- Customer provides the Agent with his/her NRIC and the Agent looks for the Customer's CUSTOMER_ID
SELECT CUSTOMER_ID FROM SYSTEM.CUSTOMER WHERE CUSTOMER_NRIC = 'S1234567F';

-- || Agent: Verifies customer purchased plans || --
SELECT * FROM SYSTEM.PURCHASE WHERE CUSTOMER_ID = '1';

-- || Agent: Sees customer past claims || --
SELECT * FROM SYSTEM.CLAIM WHERE CLAIM_SUBMITTED_FOR = '1';

-- || Agent: Creates a claim on behalf of customer || --
INSERT INTO SYSTEM.CLAIM (  CLAIM_ID, PLAN_ID, CLAIM_SUBMITTED_BY, CLAIM_SUBMITTED_FOR, CLAIM_VALUE, CLAIM_JUSTIFICATION, CLAIM_SUBMITTED_DATE ) VALUES ( '8', '1', '5', '1', '200000', 'LOST AN EYELID IN ACCIDENT, SEE POLICE REPORT AND HOSPITAL INVOICE SENT VIA EMAIL', TO_DATE('14-01-2023 17:36:10', 'DD-MM-YYYY HH24:MI:SS') );
-- reminder to commit
SELECT * FROM SYSTEM.CLAIM;

-- || Financer: Sees unprocessed claims || --
SELECT * FROM SYSTEM.CLAIM WHERE CLAIM_APPROVED IS NULL;

-- || Financer: Sees customer purchases to verify if the claim should be approved|| --
 SELECT * FROM SYSTEM.PURCHASE WHERE CUSTOMER_ID = '1';

-- || Financer: Approves claim || --
UPDATE (SELECT * FROM SYSTEM.CLAIM WHERE CLAIM_ID='8') SET CLAIM_PROCESSED_BY = '1', CLAIM_PROCESSED_DATE = TO_DATE('21-01-2023 00:02:39', 'DD-MM-YYYY HH24:MI:SS'), CLAIM_PROCESSED_COMMENT = 'DOCUMENTS VERIFIED, SEE EMAIL THREAD FOR ADDITIONAL INFO', CLAIM_APPROVED = '1', CLAIM_DISIMBURSED_DATE = TO_DATE('21-01-2023 00:02:39', 'DD-MM-YYYY HH24:MI:SS'), CLAIM_DISIMBURSED = '1', CLAIM_DISIMBURSED_VIA = '11', BANK_TRANSACTION_ID = '4c7e3-2b61-44fa-a7bc1547';
-- reminder to commit
SELECT * FROM SYSTEM.CLAIM;

-- || Customer: Sees claim status || --
SELECT * FROM SYSTEM.CLAIM;
