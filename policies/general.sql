-- -------------------------------------------------------------
-- Commonly used
-- -------------------------------------------------------------

-- Delete the context trigger
DROP TRIGGER SET_AGENTID_CTX_TRIG;


-- Delete the grouped security policy
BEGIN
    DBMS_RLS.DROP_GROUPED_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'customer',
        POLICY_GROUP => 'agent_group',
        POLICY_NAME => 'filter_agent'
    );
END;
/

BEGIN
    DBMS_RLS.DROP_GROUPED_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'customer',
        POLICY_GROUP => 'customer_group',
        POLICY_NAME => 'filter_customer'
    );
END;
/


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
-- Create user package
-- -------------------------------------------------------------

-- Create policy groups
BEGIN
    DBMS_RLS.CREATE_POLICY_GROUP(
        OBJECT_SCHEMA => 'customer',
        OBJECT_NAME => 'agent',
        POLICY_GROUP => 'agent_group'
    );
END;
/

BEGIN
    DBMS_RLS.CREATE_POLICY_GROUP(
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'customer',
        POLICY_GROUP => 'customer_group'
    );
END;
/

-- Create application context
CREATE OR REPLACE CONTEXT USER_CTX USING USER_PACKAGE;

-- Create the PL/SQL package for the application context
CREATE OR REPLACE PACKAGE USER_PACKAGE IS
    PROCEDURE SET_USER_CONTEXT (
        POLICY_GROUP VARCHAR2 DEFAULT NULL
    );
END;
/

CREATE OR REPLACE PACKAGE BODY USER_PACKAGE AS
    PROCEDURE SET_USER_CONTEXT (
        POLICY_GROUP VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        CASE LOWER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'))
            WHEN 'agent' THEN
                DBMS_SESSION.SET_CONTEXT('user_ctx', 'policy_group', 'AGENT_GROUP');
            WHEN 'customer' THEN
                DBMS_SESSION.SET_CONTEXT('user_ctx', 'policy_group', 'CUSTOMER_GROUP');
        END CASE;
    END SET_USER_CONTEXT;
END;
/

-- Associate the application context with the table, and then provide a name
BEGIN
    DBMS_RLS.ADD_POLICY_CONTEXT(
        OBJECT_SCHEMA =>'system',
        OBJECT_NAME =>'customer',
        NAMESPACE =>'user_ctx',
        ATTRIBUTE =>'policy_group'
    );
END;
/

GRANT EXECUTE ON USER_PACKAGE TO SFREEMAN;



-- -------------------------------------------------------------
-- Create policy group for "Customer" table
-- -------------------------------------------------------------


-- Agent's customer policy function
CREATE OR REPLACE FUNCTION AGENT_CUSTOMER(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    CUSTOMER_PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')) = 'agent' 
        THEN CUSTOMER_PRED := 'agent_id = SYS_CONTEXT(''agent_ctx'', ''agent_id'')';
    ELSE NULL;
    END IF;
    RETURN CUSTOMER_PRED;
END;
/

-- Customer's customer policy function
CREATE OR REPLACE FUNCTION CUSTOMER_CUSTOMER(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    CUSTOMER_PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')) = 'customer' 
        THEN CUSTOMER_PRED := 'customer_id = SYS_CONTEXT(''customer_ctx'', ''customer_id'')';
    ELSE NULL;
    END IF;
    RETURN CUSTOMER_PRED;
END;
/




-- agent_customer policy group
BEGIN
    DBMS_RLS.ADD_GROUPED_POLICY(
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'customer',
        POLICY_GROUP => 'agent_group',
        POLICY_NAME => 'filter_agent',
        POLICY_FUNCTION => 'agent_customer',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'user_ctx',
        ATTRIBUTE => 'user_group'
    );
END;
/

-- customer_customer policy group
BEGIN
    DBMS_RLS.ADD_GROUPED_POLICY(
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'customer',
        POLICY_GROUP => 'customer_group',
        POLICY_NAME => 'filter_customer',
        POLICY_FUNCTION => 'customer_customer',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'user_ctx',
        ATTRIBUTE => 'user_group'
    );
END;
/



-- -------------------------------------------------------------
-- Create policy group for "Payment" table
-- -------------------------------------------------------------

-- Payment policy function
CREATE OR REPLACE FUNCTION AGENT_PAYMENT(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PAYMENT_PRED VARCHAR2 (400);
BEGIN
    PAYMENT_PRED := 'payment_id in (select payment_method_id from system.customer)';
    RETURN PAYMENT_PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'payment',
        POLICY_NAME => 'agent_payment_policy',
        POLICY_FUNCTION => 'agent_payment',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'agent_ctx',
        ATTRIBUTE => 'agent_id'
    );
END;
/



-- -------------------------------------------------------------
-- Create policy group for "Premium" table
-- -------------------------------------------------------------

-- Premium policy function
CREATE OR REPLACE FUNCTION AGENT_PREMIUM(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PREMIUM_PRED VARCHAR2 (400);
BEGIN
    PREMIUM_PRED := 'customer_id in (select customer_id from system.customer)';
    RETURN PREMIUM_PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'premium',
        POLICY_NAME => 'agent_premium_policy',
        POLICY_FUNCTION => 'agent_premium',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'agent_ctx',
        ATTRIBUTE => 'agent_id'
    );
END;
/


-- -------------------------------------------------------------
-- Create policy group for "Purchase" table
-- -------------------------------------------------------------

-- Purchase policy function
CREATE OR REPLACE FUNCTION AGENT_PURCHASE(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PURCHASE_PRED VARCHAR2 (400);
BEGIN
    PURCHASE_PRED := 'customer_id in (select customer_id from system.customer)';
    RETURN PURCHASE_PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'purchase',
        POLICY_NAME => 'agent_purchase_policy',
        POLICY_FUNCTION => 'agent_purchase',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'agent_ctx',
        ATTRIBUTE => 'agent_id'
    );
END;
/


-- -------------------------------------------------------------
-- Create policy group for "Claim" table
-- -------------------------------------------------------------

-- Claim policy function
CREATE OR REPLACE FUNCTION AGENT_CLAIM(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    CLAIM_PRED VARCHAR2 (400);
BEGIN
    CLAIM_PRED := 'claim_submitted_for in (select customer_id from system.customer)';
    RETURN CLAIM_PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY (
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'claim',
        POLICY_NAME => 'agent_claim_policy',
        POLICY_FUNCTION => 'agent_claim',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'agent_ctx',
        ATTRIBUTE => 'agent_id'
    );
END;
/