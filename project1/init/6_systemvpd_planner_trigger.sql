-- Create application context
CREATE OR REPLACE CONTEXT PLANNER_CTX USING PLANNER_CTX_PKG;

-- Create a PL/SQL package to set the application context
CREATE OR REPLACE PACKAGE PLANNER_CTX_PKG IS
    PROCEDURE SET_PLANNERID;
END;
/

CREATE OR REPLACE PACKAGE BODY PLANNER_CTX_PKG IS
    PROCEDURE SET_PLANNERID AS
        PLANNERID NUMBER;
    BEGIN
        SELECT
            PLANNER_ID INTO PLANNERID
        FROM
            SYSTEM.PLANNER
        WHERE
            USERNAME = SYS_CONTEXT('USERENV',
            'SESSION_USER');
        DBMS_SESSION.SET_CONTEXT('planner_ctx', 'planner_id', PLANNERID);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END SET_PLANNERID;
END;
/

-- Create a logon trigger to run the application context PL/SQL package
CREATE TRIGGER SET_PLANNERID_CTX_TRIG AFTER LOGON ON DATABASE
BEGIN
    PLANNER_CTX_PKG.SET_PLANNERID;
END;
/

-- Used to delete the context trigger (use only when needed)
DROP TRIGGER SET_PLANNERID_CTX_TRIG;
