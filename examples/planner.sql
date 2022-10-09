-- Check if env var are initialized
SELECT SYS_CONTEXT('planner_ctx', 'planner_id') agentid FROM DUAL;

EXEC DBMS_SESSION.SET_IDENTIFIER('planner');

SELECT SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER') AS END_USER FROM DUAL;

-- Can add new plans
INSERT INTO SYSTEM.PLAN (PLAN_NAME, PLAN_CREATED_BY, DESCRIPTION) VALUES ('Motor Insurance 2.0', '1', 'Motor Insurance');

-- Can view all plans
select * from system.PLAN;

-- Can update plans
UPDATE SYSTEM.PLAN SET DESCRIPTION = 'Motor Insurance 2nd Generation' WHERE PLAN_ID = '21';
