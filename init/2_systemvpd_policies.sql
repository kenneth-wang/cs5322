-- -------------------------------------------------------------
-- Commonly used commands
-- -------------------------------------------------------------

-- Delete the context trigger
DROP TRIGGER SET_AGENTID_CTX_TRIG;

-- Delete the security policy
BEGIN
    DBMS_RLS.DROP_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'customer',
        POLICY_NAME => 'agent_customer_policy'
    );
END;
/

-- To view all policies
SELECT * FROM DBA_POLICIES;


-- -------------------------------------------------------------
-- Policy functions
-- -------------------------------------------------------------


-- Plan policy function
CREATE OR REPLACE FUNCTION GET_PLAN(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) = 'customer'
        THEN PRED := 'plan_id in (select plan_id from system.purchase)';
    ELSE NULL;
    END IF;
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'plan',
        POLICY_NAME => 'plan_policy',
        POLICY_FUNCTION => 'get_plan',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE
    );
END;
/



-- Customer policy function
CREATE OR REPLACE FUNCTION GET_CUSTOMER(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) = 'agent'
        THEN PRED := 'agent_id = SYS_CONTEXT(''agent_ctx'', ''agent_id'')';
    ELSIF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) = 'customer'
        THEN PRED := 'customer_id = SYS_CONTEXT(''customer_ctx'', ''customer_id'')';
    ELSE NULL;
    END IF;
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'customer',
        POLICY_NAME => 'customer_policy',
        POLICY_FUNCTION => 'get_customer',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE
    );
END;
/

CREATE OR REPLACE FUNCTION HIDE_COLS_CUSTOMER(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) <> 'customer'
        THEN PRED := '1=2';
    ELSE NULL;
    END IF;
    RETURN PRED;
END;
/


BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'customer',
        POLICY_NAME => 'hide_cols_customer_policy',
        POLICY_FUNCTION => 'hide_cols_customer',
        SEC_RELEVANT_COLS => 'username,password',
        SEC_RELEVANT_COLS_OPT => DBMS_RLS.ALL_ROWS,
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE
    );
END;
/



-- Payment policy function
CREATE OR REPLACE FUNCTION GET_PAYMENT(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) = 'agent'
        THEN PRED := 'payment_id in (select payment_method_id from system.customer)';
    ELSIF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) = 'customer'
        THEN PRED := 'payment_id in (select payment_method_id from system.customer)';
    ELSE NULL;
    END IF;
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'payment',
        POLICY_NAME => 'payment_policy',
        POLICY_FUNCTION => 'get_payment',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE
    );
END;
/


-- Premium policy function
CREATE OR REPLACE FUNCTION GET_PREMIUM(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) = 'agent'
        THEN PRED := 'customer_id in (select customer_id from system.customer)';
    ELSIF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) = 'customer'
        THEN PRED := 'customer_id in (select customer_id from system.customer)';
    ELSE NULL;
    END IF;
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'premium',
        POLICY_NAME => 'premium_policy',
        POLICY_FUNCTION => 'get_premium',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE
    );
END;
/


-- Purchase policy function
CREATE OR REPLACE FUNCTION GET_PURCHASE(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) = 'agent'
        THEN PRED := 'customer_id in (select customer_id from system.customer)';
    ELSIF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) = 'customer'
        THEN PRED := 'customer_id in (select customer_id from system.customer)';
    ELSE NULL;
    END IF;
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'purchase',
        POLICY_NAME => 'purchase_policy',
        POLICY_FUNCTION => 'get_purchase',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE
    );
END;
/


-- Claim policy function
CREATE OR REPLACE FUNCTION GET_CLAIM(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) = 'agent'
        THEN PRED := 'claim_submitted_for in (select customer_id from system.customer)';
    ELSIF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) = 'customer'
        THEN PRED := 'claim_submitted_for in (select customer_id from system.customer)';
    ELSIF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) = 'financer'
        THEN PRED := 'claims_processed_by SYS_CONTEXT(''financer_ctx'', ''financer_id'')';
    ELSE NULL;
    END IF;
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'claim',
        POLICY_NAME => 'claim_policy',
        POLICY_FUNCTION => 'get_claim',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE
    );
END;
/


-- financer policy function
CREATE OR REPLACE FUNCTION GET_FINANCER(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) = 'financer'
        THEN PRED := 'financer_id = SYS_CONTEXT(''financer_ctx'', ''financer_id'')';
    ELSE NULL;
    END IF;
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'financer',
        POLICY_NAME => 'financer_policy',
        POLICY_FUNCTION => 'get_financer',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE
    );
END;
/


-- Planner policy function
CREATE OR REPLACE FUNCTION GET_PLANNER(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) = 'planner'
        THEN PRED := 'planner_id = SYS_CONTEXT(''planner_ctx'', ''planner_id'')';
    ELSE NULL;
    END IF;
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'planner',
        POLICY_NAME => 'planner_policy',
        POLICY_FUNCTION => 'get_planner',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE
    );
END;
/

-- Agent policy function
CREATE OR REPLACE FUNCTION GET_AGENT(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')) = 'agent'
        THEN PRED := 'agent_id = SYS_CONTEXT(''agent_ctx'', ''agent_id'')';
    ELSE NULL;
    END IF;
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'agent',
        POLICY_NAME => 'agent_policy',
        POLICY_FUNCTION => 'get_agent',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE
    );
END;
/