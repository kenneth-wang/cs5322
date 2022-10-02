-- Allow scott to create table
GRANT CREATE TABLE TO scott;
ALTER USER scott quota unlimited on USERS;

-- Create orders_ctx application context
CREATE OR REPLACE CONTEXT agent_ctx USING agent_ctx_pkg;

-- Create a PL/SQL package to set the application context
CREATE OR REPLACE PACKAGE agent_ctx_pkg IS 
  PROCEDURE set_agentnum;
 END;
/
CREATE OR REPLACE PACKAGE BODY agent_ctx_pkg IS
  PROCEDURE set_agentnum
  AS
    agentnum NUMBER;
  BEGIN
     SELECT id INTO agentnum FROM SYSTEM.AGENTS
        WHERE name = SYS_CONTEXT('USERENV', 'SESSION_USER');
     DBMS_SESSION.SET_CONTEXT('agent_ctx', 'agent_id', agentnum);
  EXCEPTION
   WHEN NO_DATA_FOUND THEN NULL;
  END set_agentnum;
END;
/

-- Create a logon trigger to run the application context PL/SQL package
CREATE TRIGGER set_custno_ctx_trig AFTER LOGON ON DATABASE
 BEGIN
  agent_ctx_pkg.set_agentnum;
 END;
/

-- Create a PL/SQL policy function to limit user access to their orders
CREATE OR REPLACE FUNCTION get_customers_by_agent_id(
  schema_p   IN VARCHAR2,
  table_p    IN VARCHAR2)
 RETURN VARCHAR2
 AS
  orders_pred VARCHAR2 (400);
 BEGIN
  orders_pred := 'agent_id = SYS_CONTEXT(''agent_ctx'', ''agent_id'')'; 
 RETURN orders_pred;
END;
/

-- Create the new security policy
BEGIN
 DBMS_RLS.ADD_POLICY (
  object_schema    => 'system', 
  object_name      => 'customers', 
  policy_name      => 'view_customers_policy', 
  policy_function  => 'get_customers_by_agent_id',
  statement_types  => 'select',
  policy_type      => DBMS_RLS.CONTEXT_SENSITIVE,
  namespace        => 'agent_ctx',
  attribute        => 'agent_id');
END;
/

-- Used to delete the security policy (use only when needed)
BEGIN
 DBMS_RLS.DROP_POLICY (
  object_schema    => 'system', 
  object_name      => 'customers', 
  policy_name      => 'view_customers_policy');
END;
/
