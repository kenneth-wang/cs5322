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
            WHEN 'financer' THEN
                DBMS_SESSION.SET_CONTEXT('user_ctx', 'policy_group', 'FINANCER_GROUP');
            WHEN 'planner' THEN
                DBMS_SESSION.SET_CONTEXT('user_ctx', 'policy_group', 'PLANNER_GROUP');
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

GRANT EXECUTE ON USER_PACKAGE TO SFREEMAN, CKLEIN, MCURTIS, JHUNTER, KJACKSON, ECARPENTER, AMYERS;
GRANT EXECUTE ON USER_PACKAGE TO AARONAUSTIN, CASTILLOMICHAEL, SOSAKAITLYN, COREYSKINNER, KRISTEN73;
GRANT EXECUTE ON USER_PACKAGE TO ROGEROLIVER, TNGUYEN, JOSHUATHOMPSON, BRENDA96, UKOCH;
GRANT EXECUTE ON USER_PACKAGE TO STACEYGONZALEZ, SAUNDERSROGER, MONTOYAMARTIN, WEBERJOSEPH, KATHRYNFOX;


-- -------------------------------------------------------------
-- Create policy group for "Plan" table
-- -------------------------------------------------------------

-- Customer
CREATE OR REPLACE FUNCTION CUSTOMER_PLAN(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')) = 'customer' 
        THEN PRED := 'plan_id in (select plan_id from system.purchase)';
    ELSE NULL;
    END IF;
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_GROUPED_POLICY(
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'plan',
        POLICY_GROUP => 'customer_group',
        POLICY_NAME => 'filter_plan',
        POLICY_FUNCTION => 'customer_plan',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'user_ctx',
        ATTRIBUTE => 'user_group'
    );
END;
/

-- Planner
CREATE OR REPLACE FUNCTION PLANNER_PLAN(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')) = 'planner' 
        THEN PRED := 'plan_created_by = SYS_CONTEXT(''planner_ctx'', ''planner_id'')';
    ELSE NULL;
    END IF;
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_GROUPED_POLICY(
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'plan',
        POLICY_GROUP => 'planner_group',
        POLICY_NAME => 'filter_plan',
        POLICY_FUNCTION => 'planner_plan',
        STATEMENT_TYPES => 'update',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'user_ctx',
        ATTRIBUTE => 'user_group'
    );
END;
/


-- -------------------------------------------------------------
-- Create policy group for "Customer" table
-- -------------------------------------------------------------


-- Agent
CREATE OR REPLACE FUNCTION AGENT_CUSTOMER(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')) = 'agent' 
        THEN PRED := 'agent_id = SYS_CONTEXT(''agent_ctx'', ''agent_id'')';
    ELSE NULL;
    END IF;
    RETURN PRED;
END;
/

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

-- Customer
CREATE OR REPLACE FUNCTION CUSTOMER_CUSTOMER(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    IF LOWER(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')) = 'customer' 
        THEN PRED := 'customer_id = SYS_CONTEXT(''customer_ctx'', ''customer_id'')';
    ELSE NULL;
    END IF;
    RETURN PRED;
END;
/

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

-- Agent
CREATE OR REPLACE FUNCTION AGENT_PAYMENT(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    PRED := 'payment_id in (select payment_method_id from system.customer)';
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_GROUPED_POLICY(
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'payment',
        POLICY_GROUP => 'agent_group',
        POLICY_NAME => 'filter_payment',
        POLICY_FUNCTION => 'agent_payment',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'user_ctx',
        ATTRIBUTE => 'user_group'
    );
END;
/

-- Customer
CREATE OR REPLACE FUNCTION CUSTOMER_PAYMENT(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    PRED := 'payment_id in (select payment_method_id from system.customer)';
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_GROUPED_POLICY(
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'payment',
        POLICY_GROUP => 'customer_group',
        POLICY_NAME => 'filter_payment',
        POLICY_FUNCTION => 'customer_payment',
        STATEMENT_TYPES => 'select,update',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'user_ctx',
        ATTRIBUTE => 'user_group'
    );
END;
/


-- -------------------------------------------------------------
-- Create policy group for "Premium" table
-- -------------------------------------------------------------

-- Agent
CREATE OR REPLACE FUNCTION AGENT_PREMIUM(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    PRED := 'customer_id in (select customer_id from system.customer)';
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_GROUPED_POLICY(
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'premium',
        POLICY_GROUP => 'agent_group',
        POLICY_NAME => 'filter_premium',
        POLICY_FUNCTION => 'agent_premium',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'user_ctx',
        ATTRIBUTE => 'user_group'
    );
END;
/

-- Customer
CREATE OR REPLACE FUNCTION CUSTOMER_PREMIUM(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    PRED := 'customer_id in (select customer_id from system.customer)';
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_GROUPED_POLICY(
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'premium',
        POLICY_GROUP => 'customer_group',
        POLICY_NAME => 'filter_premium',
        POLICY_FUNCTION => 'customer_premium',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'user_ctx',
        ATTRIBUTE => 'user_group'
    );
END;
/

-- -------------------------------------------------------------
-- Create policy group for "Purchase" table
-- -------------------------------------------------------------

-- Agent
CREATE OR REPLACE FUNCTION AGENT_PURCHASE(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    PRED := 'customer_id in (select customer_id from system.customer)';
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_GROUPED_POLICY(
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'purchase',
        POLICY_GROUP => 'agent_group',
        POLICY_NAME => 'filter_purchase',
        POLICY_FUNCTION => 'agent_purchase',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'user_ctx',
        ATTRIBUTE => 'user_group'
    );
END;
/

-- Customer
CREATE OR REPLACE FUNCTION CUSTOMER_PURCHASE(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    PRED := 'customer_id in (select customer_id from system.customer)';
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_GROUPED_POLICY(
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'purchase',
        POLICY_GROUP => 'customer_group',
        POLICY_NAME => 'filter_purchase',
        POLICY_FUNCTION => 'customer_purchase',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'user_ctx',
        ATTRIBUTE => 'user_group'
    );
END;
/

-- -------------------------------------------------------------
-- Create policy group for "Claim" table
-- -------------------------------------------------------------

-- Agent
CREATE OR REPLACE FUNCTION AGENT_CLAIM(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    PRED := 'claim_submitted_for in (select customer_id from system.customer)';
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_GROUPED_POLICY(
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'claim',
        POLICY_GROUP => 'agent_group',
        POLICY_NAME => 'filter_claim',
        POLICY_FUNCTION => 'agent_claim',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'user_ctx',
        ATTRIBUTE => 'user_group'
    );
END;
/

-- Customer
CREATE OR REPLACE FUNCTION CUSTOMER_CLAIM(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    PRED := 'claim_submitted_for in (select customer_id from system.customer)';
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_GROUPED_POLICY(
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'claim',
        POLICY_GROUP => 'customer_group',
        POLICY_NAME => 'filter_claim',
        POLICY_FUNCTION => 'customer_claim',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'user_ctx',
        ATTRIBUTE => 'user_group'
    );
END;
/



-- Financer
CREATE OR REPLACE FUNCTION FINANCER_CLAIM(
    SCHEMA_P IN VARCHAR2,
    TABLE_P IN VARCHAR2
) RETURN VARCHAR2 AS
    PRED VARCHAR2 (400);
BEGIN
    PRED := 'claims_processed_by SYS_CONTEXT(''financer_ctx'', ''financer_id'')';
    RETURN PRED;
END;
/

BEGIN
    DBMS_RLS.ADD_GROUPED_POLICY(
        OBJECT_SCHEMA => 'system',
        OBJECT_NAME => 'claim',
        POLICY_GROUP => 'financer_group',
        POLICY_NAME => 'filter_claim',
        POLICY_FUNCTION => 'financer_claim',
        STATEMENT_TYPES => 'select',
        POLICY_TYPE => DBMS_RLS.CONTEXT_SENSITIVE,
        NAMESPACE => 'user_ctx',
        ATTRIBUTE => 'user_group'
    );
END;
/