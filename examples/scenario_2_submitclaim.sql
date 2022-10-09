-- Agent: Find customer ID
SELECT CUSTOMER_ID FROM SYSTEM.CUSTOMER WHERE CUSTOMER_NRIC = 'S2345678H';

-- Agent: Verify customer purchased plans
SELECT * FROM SYSTEM.PURCHASE WHERE CUSTOMER_ID = '7';

-- Agent: See customer past claims
SELECT * FROM SYSTEM.CLAIM WHERE CLAIM_SUBBMITED_FOR = '7';

-- Agent: Creates claims
INSERT INTO SYSTEM.CLAIM (  CLAIM_ID, PLAN_ID, CLAIM_SUBMITTED_BY, CLAIM_SUBMITTED_FOR, CLAIM_VALUE, CLAIM_JUSTIFICATION, CLAIM_SUBMITTED_DATE ) VALUES ( '2706', '21', '5', '7', '200000', 'LOST AN EYELID IN ACCIDENT, SEE POLICE REPORT AND HOSPITAL INVOICE SENT VIA EMAIL', TO_DATE('14-01-2023 17:36:10', 'DD-MM-YYYY HH24:MI:SS') );
SELECT * FROM SYSTEM.CLAIM;

-- Financer: See unprocessed claims
SELECT * FROM SYSTEM.CLAIM WHERE CLAIM_APPROVED IS NULL;

-- Financer: See customer purchases
 SELECT * FROM SYSTEM.PURCHASE WHERE CUSTOMER_ID = '7';

-- Financer: Update approved claim
UPDATE SYSTEM.CLAIM SET CLAIM_PROCESSED_BY = '3', CLAIM_PROCESSED_DATE = TO_DATE('21-01-2023 00:02:39', 'DD-MM-YYYY HH24:MI:SS'), CLAIM_PROCESSED_COMMENT = 'DOCUMENTS VERIFIED, SEE EMAIL THREAD FOR ADDITIONAL INFO', CLAIM_APPROVED = '1', CLAIM_DISIMBURSED_DATE = TO_DATE('21-01-2023 00:02:39', 'DD-MM-YYYY HH24:MI:SS'), CLAIM_DISIMBURSED = '1', CLAIM_DISIMBURSED_VIA = '11', BANK_TRANSACTION_ID = '4c7e3-2b61-44fa-a7bc1547' WHERE CLAIM_ID = '2706';
SELECT * FROM SYSTEM.CLAIM;

-- Customer: See claim status
SELECT * FROM SYSTEM.CLAIM;
