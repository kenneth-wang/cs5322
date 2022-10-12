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

-- || Planner: Inserts a new plan || --
INSERT INTO SYSTEM.PLAN ( PLAN_ID, PLAN_NAME, PLAN_CREATED_BY, DESCRIPTION ) VALUES ('6', 'Motor Insurance 2.0', '1', 'Loss Damage Waiver for sportbikes up to 1000cc. In the event of...' );

-- || Agent: Sees new plan || --
SELECT PLAN_ID, PLAN_NAME, DESCRIPTION FROM SYSTEM.PLAN;
