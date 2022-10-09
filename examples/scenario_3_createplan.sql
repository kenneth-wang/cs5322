-- Planner: 
INSERT INTO SYSTEM.PLAN ( PLAN_NAME, PLAN_CREATED_BY, DESCRIPTION ) VALUES ( 'Motor Insurance 2.0', '1', 'Loss Damage Waiver for sportbikes up to 1000cc. In the event of...' );

-- Agent: See new plan
SELECT PLAN_ID, PLAN_NAME, DESCRIPTION FROM SYSTEM.PLAN;
