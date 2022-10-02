-- -------------------------------------------------------------
-- TablePlus 4.8.9(453)
--
-- https://tableplus.com/
--
-- Database: cs5322.comp.nus.edu.sg
-- Generation Time: 2022-10-02 22:17:05.9020
-- -------------------------------------------------------------

INSERT INTO SYSTEM.AGENT (AGENT_ID, USERNAME, PASSWORD, AGENT_NAME, MOBILE_NUMBER, EMAIL_ADDRESS)  VALUES ('1', 'sfreeman', 'l173DmTa+0', 'Stephen Freeman', '98765431', 'sfreeman@example.net');
INSERT INTO SYSTEM.AGENT (AGENT_ID, USERNAME, PASSWORD, AGENT_NAME, MOBILE_NUMBER, EMAIL_ADDRESS)  VALUES ('3', 'cklein', '+1yv&G5cDB', 'Courtney Klein', '98765432', 'cklein@example.net');
INSERT INTO SYSTEM.AGENT (AGENT_ID, USERNAME, PASSWORD, AGENT_NAME, MOBILE_NUMBER, EMAIL_ADDRESS)  VALUES ('4', 'mcurtis', 'fdsvdf', 'Matthew Curtis', '98765433', 'mcurtis@example.net');
INSERT INTO SYSTEM.AGENT (AGENT_ID, USERNAME, PASSWORD, AGENT_NAME, MOBILE_NUMBER, EMAIL_ADDRESS)  VALUES ('5', 'jhunter', 'sd22', 'James Hunter', '98765434', 'jhunter@example.net');
INSERT INTO SYSTEM.AGENT (AGENT_ID, USERNAME, PASSWORD, AGENT_NAME, MOBILE_NUMBER, EMAIL_ADDRESS)  VALUES ('6', 'kjackson', '323iuydb', 'Keith Jackson', '98765435', 'kjackson@example.net');
INSERT INTO SYSTEM.AGENT (AGENT_ID, USERNAME, PASSWORD, AGENT_NAME, MOBILE_NUMBER, EMAIL_ADDRESS)  VALUES ('7', 'ecarpenter', 'wef8*H', 'Eric Carpenter', '98765436', 'ecarpenter@example.net');
INSERT INTO SYSTEM.AGENT (AGENT_ID, USERNAME, PASSWORD, AGENT_NAME, MOBILE_NUMBER, EMAIL_ADDRESS)  VALUES ('2', 'amyers', 'qiw7eI*&', 'Amber Myers', '98765437', 'amyers@example.net');

INSERT INTO SYSTEM.CUSTOMER (CUSTOMER_ID, USERNAME, PASSWORD, CUSTOMER_NAME, CUSTOMER_NRIC, DATE_OF_BIRTH, DATE_JOINED, ADDRESS, MONTHLY_SALARY, MONTHLY_EXPENSES, MOBILE_NUMBER, EMAIL_ADDRESS, PAYMENT_METHOD_ID, AGENT_ID)  VALUES ('1', 'aaronaustin', 'o7ytw2Zc&%', 'Aaron', 'S1234567F', TO_DATE('07-12-1990 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '9665 Sheryl Crest\nHarrisonview, SD 65795', '3000', '300', '91234567', 'aaronaustin@example.com', '1', '1');
INSERT INTO SYSTEM.CUSTOMER (CUSTOMER_ID, USERNAME, PASSWORD, CUSTOMER_NAME, CUSTOMER_NRIC, DATE_OF_BIRTH, DATE_JOINED, ADDRESS, MONTHLY_SALARY, MONTHLY_EXPENSES, MOBILE_NUMBER, EMAIL_ADDRESS, PAYMENT_METHOD_ID, AGENT_ID)  VALUES ('2', 'castillomichael', 'enh+U0!u$5', 'Castillo Michael', 'S1234568F', TO_DATE('07-12-1990 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '09645 Steven Crossroad Apt. 567\nLake Davidbury, OR 69179', '4000', '400', '91234568', 'castillomichael@example.com', '1', '2');
INSERT INTO SYSTEM.CUSTOMER (CUSTOMER_ID, USERNAME, PASSWORD, CUSTOMER_NAME, CUSTOMER_NRIC, DATE_OF_BIRTH, DATE_JOINED, ADDRESS, MONTHLY_SALARY, MONTHLY_EXPENSES, MOBILE_NUMBER, EMAIL_ADDRESS, PAYMENT_METHOD_ID, AGENT_ID)  VALUES ('3', 'sosakaitlyn', 'vA7fP5fwC+', 'Sosa Kaitlyn', 'S1234569F', TO_DATE('07-12-1990 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '251 Diana Squares\nSouth Melissa, VT 58689', '5000', '500', '91234569', 'sosakaitlyn@example.com', '1', '3');
INSERT INTO SYSTEM.CUSTOMER (CUSTOMER_ID, USERNAME, PASSWORD, CUSTOMER_NAME, CUSTOMER_NRIC, DATE_OF_BIRTH, DATE_JOINED, ADDRESS, MONTHLY_SALARY, MONTHLY_EXPENSES, MOBILE_NUMBER, EMAIL_ADDRESS, PAYMENT_METHOD_ID, AGENT_ID)  VALUES ('4', 'coreyskinner', '^JV%0y$sz4', 'Corey Skinner', 'S1234560G', TO_DATE('07-12-1990 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '094 Lori Union\nNew Christopher, MD 86960', '6000', '600', '91234570', 'coreyskinner@example.com', '1', '4');
INSERT INTO SYSTEM.CUSTOMER (CUSTOMER_ID, USERNAME, PASSWORD, CUSTOMER_NAME, CUSTOMER_NRIC, DATE_OF_BIRTH, DATE_JOINED, ADDRESS, MONTHLY_SALARY, MONTHLY_EXPENSES, MOBILE_NUMBER, EMAIL_ADDRESS, PAYMENT_METHOD_ID, AGENT_ID)  VALUES ('5', 'kristen73', '_gZ6IdQKaH', 'Kristen Kristian', 'S1234561G', TO_DATE('07-12-1990 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '2398 Deborah Canyon\nNew Robert, NV 15599', '7000', '800', '91234571', 'kristen73@example.com', '1', '5');

INSERT INTO SYSTEM.FINANCER (FINANCER_ID, USERNAME, PASSWORD)  VALUES ('1', 'rogeroliver', 'l^8BHXqcRr');
INSERT INTO SYSTEM.FINANCER (FINANCER_ID, USERNAME, PASSWORD)  VALUES ('2', 'tnguyen', 'qr@oh3Kf3e');
INSERT INTO SYSTEM.FINANCER (FINANCER_ID, USERNAME, PASSWORD)  VALUES ('3', 'joshuathompson', 'VX4%Xyz2$0');
INSERT INTO SYSTEM.FINANCER (FINANCER_ID, USERNAME, PASSWORD)  VALUES ('4', 'brenda96', 'R7F*AgZN(a');
INSERT INTO SYSTEM.FINANCER (FINANCER_ID, USERNAME, PASSWORD)  VALUES ('5', 'ukoch', 'PDoBczkP!3');

INSERT INTO SYSTEM.PAYMENT (PAYMENT_ID, PAYEE_NAME, MOBILE_NUMBER, BANK_NAME, BRANCH_NAME, ACCOUNT_NUMBER, BANK_CODE)  VALUES ('1', '1', '1', '1', '1', '1', '1');

INSERT INTO SYSTEM.PAYMENT_METHODS (ID, FULL_NAME, MOBILE_NUMBER, BANK_NAME, BRANCH_NAME, ACCOUNT_NUMBER, BANK_CODE)  VALUES ('1', 'SANDRA', '90765432', 'POSB', 'SUNTEC', '11223344', '23');

INSERT INTO SYSTEM.PLAN (PLAN_ID, PLAN_NAME, PLAN_CREATED_BY, DESCRIPTION)  VALUES ('2', 'Pro Achiever 1.0', '1', 'Investment');
INSERT INTO SYSTEM.PLAN (PLAN_ID, PLAN_NAME, PLAN_CREATED_BY, DESCRIPTION)  VALUES ('3', 'Pro Achiever 2.0', '2', 'Investment');
INSERT INTO SYSTEM.PLAN (PLAN_ID, PLAN_NAME, PLAN_CREATED_BY, DESCRIPTION)  VALUES ('4', 'Life Insurance', '3', 'Life Insurance');
INSERT INTO SYSTEM.PLAN (PLAN_ID, PLAN_NAME, PLAN_CREATED_BY, DESCRIPTION)  VALUES ('5', 'Motor Insurance', '4', 'Motor Insurance');
INSERT INTO SYSTEM.PLAN (PLAN_ID, PLAN_NAME, PLAN_CREATED_BY, DESCRIPTION)  VALUES ('6', 'House Insurance', '5', 'House Insurance');
INSERT INTO SYSTEM.PLAN (PLAN_ID, PLAN_NAME, PLAN_CREATED_BY, DESCRIPTION)  VALUES ('1', 'Mortgage Insurance', '5', 'Mortgage Insurance');

INSERT INTO SYSTEM.PLANNER (PLANNER_ID, USERNAME, PASSWORD)  VALUES ('1', 'staceygonzalez', '7+Yi8lY');
INSERT INTO SYSTEM.PLANNER (PLANNER_ID, USERNAME, PASSWORD)  VALUES ('2', 'saundersroger', '1XE(HSko(V');
INSERT INTO SYSTEM.PLANNER (PLANNER_ID, USERNAME, PASSWORD)  VALUES ('3', 'montoyamartin', 'TKL@*LBf^6');
INSERT INTO SYSTEM.PLANNER (PLANNER_ID, USERNAME, PASSWORD)  VALUES ('4', 'weberjoseph', 'N@7C9nBfkg');
INSERT INTO SYSTEM.PLANNER (PLANNER_ID, USERNAME, PASSWORD)  VALUES ('5', 'kathrynfox', '%9D*q&6A5l');

INSERT INTO SYSTEM.PREMIUM (PREMIUM_ID, CUSTOMER_ID, PAYMENT_DATE, PAYMENT_VALUE_SGD, BANK_TRANSACTION_ID)  VALUES ('1', '1', TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '8000', 'f2c26462-eb01-4b80-a1c0-a757dcd1d932');
INSERT INTO SYSTEM.PREMIUM (PREMIUM_ID, CUSTOMER_ID, PAYMENT_DATE, PAYMENT_VALUE_SGD, BANK_TRANSACTION_ID)  VALUES ('2', '2', TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '9000', 'ea3b61b7-e76c-4778-ad15-e96083f66da4');
INSERT INTO SYSTEM.PREMIUM (PREMIUM_ID, CUSTOMER_ID, PAYMENT_DATE, PAYMENT_VALUE_SGD, BANK_TRANSACTION_ID)  VALUES ('3', '3', TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '10000', 'c61bc8a0-8e85-4f16-91ec-4279b45e62af');
INSERT INTO SYSTEM.PREMIUM (PREMIUM_ID, CUSTOMER_ID, PAYMENT_DATE, PAYMENT_VALUE_SGD, BANK_TRANSACTION_ID)  VALUES ('4', '4', TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '11000', 'b736f7f0-50da-40d9-8596-427dd1dcebfd');
INSERT INTO SYSTEM.PREMIUM (PREMIUM_ID, CUSTOMER_ID, PAYMENT_DATE, PAYMENT_VALUE_SGD, BANK_TRANSACTION_ID)  VALUES ('5', '5', TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '12000', '8894768b-ed04-4e5b-b488-7e5f96bc0f86');

INSERT INTO SYSTEM.PURCHASE (PURCHASE_ID, PLAN_ID, CUSTOMER_ID, AGENT_ID, PLAN_DETAILS, PURCHASE_DATE, PURCHASE_VALUE_SGD, POLICY_START_DATE, POLICY_END_DATE)  VALUES ('1', '1', '1', '1', 'Some deets', TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '10000', TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('02-10-2042 00:00:00', 'DD-MM-YYYY HH24:MI:SS'));
INSERT INTO SYSTEM.PURCHASE (PURCHASE_ID, PLAN_ID, CUSTOMER_ID, AGENT_ID, PLAN_DETAILS, PURCHASE_DATE, PURCHASE_VALUE_SGD, POLICY_START_DATE, POLICY_END_DATE)  VALUES ('2', '2', '2', '2', 'Some deets', TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '11000', TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('02-10-2042 00:00:00', 'DD-MM-YYYY HH24:MI:SS'));
INSERT INTO SYSTEM.PURCHASE (PURCHASE_ID, PLAN_ID, CUSTOMER_ID, AGENT_ID, PLAN_DETAILS, PURCHASE_DATE, PURCHASE_VALUE_SGD, POLICY_START_DATE, POLICY_END_DATE)  VALUES ('3', '3', '3', '3', 'Some deets', TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '30000', TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('02-10-2042 00:00:00', 'DD-MM-YYYY HH24:MI:SS'));
INSERT INTO SYSTEM.PURCHASE (PURCHASE_ID, PLAN_ID, CUSTOMER_ID, AGENT_ID, PLAN_DETAILS, PURCHASE_DATE, PURCHASE_VALUE_SGD, POLICY_START_DATE, POLICY_END_DATE)  VALUES ('4', '4', '4', '4', 'Some deets', TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '50000', TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('02-10-2042 00:00:00', 'DD-MM-YYYY HH24:MI:SS'));
INSERT INTO SYSTEM.PURCHASE (PURCHASE_ID, PLAN_ID, CUSTOMER_ID, AGENT_ID, PLAN_DETAILS, PURCHASE_DATE, PURCHASE_VALUE_SGD, POLICY_START_DATE, POLICY_END_DATE)  VALUES ('5', '5', '5', '5', 'Some deets', TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), '40000', TO_DATE('02-10-2022 00:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('02-10-2042 00:00:00', 'DD-MM-YYYY HH24:MI:SS'));