-- Can add new plans
INSERT INTO SYSTEM.PLAN (PLAN_NAME, PLAN_CREATED_BY, DESCRIPTION) VALUES ('Motor Insurance 2.0', '1', 'Motor Insurance');

-- Can view all plans
select * from system.PLAN;

-- Can update plans
UPDATE SYSTEM.PLAN SET DESCRIPTION = 'Motor Insurance 2nd Generation' WHERE PLAN_ID = '21';
