
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








grant update table to raimi;
ALTER USER raimi quota unlimited on USERS;
grant read on agents to raimi;


SELECT 
    username, 
    default_tablespace, 
    profile, 
    authentication_type
FROM
    dba_users
WHERE 
    account_status = 'OPEN';
  

DBMS_SESSION.SET_CONTEXT('agent_ctx', 'agent_id', 1);
  
  

  
GRANT CREATE SESSION TO raimi;
GRANT READ ON system.customers TO sysadmin_vpd;
GRANT READ ON system.agents TO sysadmin_vpd;
GRANT READ ON system.agents TO raimi;
GRANT READ ON system.customers TO raimi;
  
  
  
  
  
  -- Create orders_ctx application context
CREATE OR REPLACE CONTEXT customers_ctx USING customers_ctx_pkg;

-- Create a PL/SQL package to set the application context
CREATE OR REPLACE PACKAGE customers_ctx_pkg IS 
  PROCEDURE set_agentnum;
 END;
/

CREATE OR REPLACE PACKAGE BODY customers_ctx_pkg IS
  PROCEDURE set_agentnum
  AS
    agentnum NUMBER;
  BEGIN
     SELECT agent_no INTO agentnum FROM system.AGENT_KENNETH
        WHERE agent_email = SYS_CONTEXT('USERENV', 'SESSION_USER');
     DBMS_SESSION.SET_CONTEXT('customers_ctx', 'agent_no', agentnum);
  EXCEPTION
   WHEN NO_DATA_FOUND THEN NULL;
  END set_agentnum;
END;
/

-- Create a logon trigger to run the application context PL/SQL package
CREATE OR REPLACE TRIGGER set_agentno_kenneth_ctx_trig AFTER LOGON ON DATABASE
 BEGIN
  customers_ctx_pkg.set_agentnum;
 END;
/

-- Create a PL/SQL policy function to limit user access to their orders
CREATE OR REPLACE FUNCTION get_customers(
  schema_p   IN VARCHAR2,
  table_p    IN VARCHAR2)
 RETURN VARCHAR2
 AS
  customers_pred VARCHAR2 (400);
 BEGIN
  customers_pred := 'agent_no = SYS_CONTEXT(''customers_ctx'', ''agent_no'')'; 
 RETURN customers_pred;
END;
/

-- Create the new security policy
BEGIN
 DBMS_RLS.ADD_POLICY (
  object_schema    => 'system', 
  object_name      => 'customers_kenneth', 
  policy_name      => 'customers_policy', 
  policy_function  => 'get_customers',
  statement_types  => 'select',
  policy_type      => DBMS_RLS.CONTEXT_SENSITIVE,
  namespace        => 'customers_ctx',
  attribute        => 'agent_no');
END;
/

-- Used to delete the security policy (use only when needed)
BEGIN
 DBMS_RLS.DROP_POLICY (
  object_schema    => 'system', 
  object_name      => 'customers_kenneth', 
  policy_name      => 'customers_policy');
END;
/