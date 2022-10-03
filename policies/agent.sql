-- -------------------------------------------------------------
-- Agent
-- -------------------------------------------------------------

-- Create application context
CREATE OR REPLACE CONTEXT AGENT_CTX USING AGENT_CTX_PKG;

-- Create a PL/SQL package to set the application context
CREATE OR REPLACE PACKAGE AGENT_CTX_PKG IS
    PROCEDURE SET_AGENTID;
END;
/

CREATE OR REPLACE PACKAGE BODY AGENT_CTX_PKG IS
    PROCEDURE SET_AGENTID AS
        AGENTID NUMBER;
    BEGIN
        SELECT
            AGENT_ID INTO AGENTID
        FROM
            SYSTEM.AGENT
        WHERE
            USERNAME = SYS_CONTEXT('USERENV',
            'SESSION_USER');
        DBMS_SESSION.SET_CONTEXT('agent_ctx', 'agent_id', AGENTID);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END SET_AGENTID;
END;
/

-- Create a logon trigger to run the application context PL/SQL package
CREATE TRIGGER SET_AGENTID_CTX_TRIG AFTER LOGON ON DATABASE
BEGIN
    AGENT_CTX_PKG.SET_AGENTID;
END;
/

-- Customer policy function
CREATE OR REPLACE FUNCTION GET_CUSTOMERS_BY_AGENT_ID(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    AGENT_ID_PRED VARCHAR2 (400);
BEGIN
    AGENT_ID_PRED := 'agent_id = SYS_CONTEXT(''agent_ctx'', ''agent_id'')';
    RETURN AGENT_ID_PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'customer',
        POLICY_NAME => 'view_customers_policy',
        POLICY_FUNCTION => 'get_customers_by_agent_id',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'agent_ctx',
        ATTRIBUTE => 'agent_id'
    );
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'customer',
        POLICY_NAME => 'view_customers_policy',
        POLICY_FUNCTION => 'get_customers_by_agent_id',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'agent_ctx',
        ATTRIBUTE => 'agent_id'
    );
END;
/

-- Used to delete the agent context trigger (use only when needed)
DROP TRIGGER SET_AGENTID_CTX_TRIG;


-- Payment policy function
CREATE OR REPLACE FUNCTION AGENT_PAYMENT(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PAYMENT_ID_PRED VARCHAR2 (400);
BEGIN
    PAYMENT_ID_PRED := 'payment_id in (select payment_method_id from system.customer)';
    RETURN PAYMENT_ID_PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'payment',
        POLICY_NAME => 'view_payments_policy',
        POLICY_FUNCTION => 'agent_payment',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'agent_ctx',
        ATTRIBUTE => 'agent_id'
    );
END;
/

-- Used to delete the security policy (use only when needed)
BEGIN
    DBMS_RLS.DROP_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'payment',
        POLICY_NAME => 'view_payments_policy'
    );
END;
/
