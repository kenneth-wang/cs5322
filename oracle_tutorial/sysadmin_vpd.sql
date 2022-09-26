-- Allow scott to create table
GRANT CREATE TABLE TO scott;
ALTER USER scott quota unlimited on USERS;

-- Create orders_ctx application context
CREATE OR REPLACE CONTEXT orders_ctx USING orders_ctx_pkg;

-- Create a PL/SQL package to set the application context
CREATE OR REPLACE PACKAGE orders_ctx_pkg IS 
  PROCEDURE set_custnum;
 END;
/
CREATE OR REPLACE PACKAGE BODY orders_ctx_pkg IS
  PROCEDURE set_custnum
  AS
    custnum NUMBER;
  BEGIN
     SELECT cust_no INTO custnum FROM SCOTT.CUSTOMERS
        WHERE cust_email = SYS_CONTEXT('USERENV', 'SESSION_USER');
     DBMS_SESSION.SET_CONTEXT('orders_ctx', 'cust_no', custnum);
  EXCEPTION
   WHEN NO_DATA_FOUND THEN NULL;
  END set_custnum;
END;
/

-- Create a logon trigger to run the application context PL/SQL package
CREATE TRIGGER set_custno_ctx_trig AFTER LOGON ON DATABASE
 BEGIN
  orders_ctx_pkg.set_custnum;
 END;
/

-- Create a PL/SQL policy function to limit user access to their orders
CREATE OR REPLACE FUNCTION get_user_orders(
  schema_p   IN VARCHAR2,
  table_p    IN VARCHAR2)
 RETURN VARCHAR2
 AS
  orders_pred VARCHAR2 (400);
 BEGIN
  orders_pred := 'cust_no = SYS_CONTEXT(''orders_ctx'', ''cust_no'')'; 
 RETURN orders_pred;
END;
/

-- Create the new security policy
BEGIN
 DBMS_RLS.ADD_POLICY (
  object_schema    => 'scott', 
  object_name      => 'orders_tab', 
  policy_name      => 'orders_policy', 
  policy_function  => 'get_user_orders',
  statement_types  => 'select',
  policy_type      => DBMS_RLS.CONTEXT_SENSITIVE,
  namespace        => 'orders_ctx',
  attribute        => 'cust_no');
END;
/

-- Used to delete the security policy (use only when needed)
BEGIN
 DBMS_RLS.DROP_POLICY (
  object_schema    => 'scott', 
  object_name      => 'orders_tab', 
  policy_name      => 'orders_policy');
END;
/

SELECT * FROM SCOTT.ORDERS_TAB;