----------------------------------------------------
-- AUTHORIZE OLS USERS AND ASSIGN POLICY TO TABLE --
----------------------------------------------------

---- AS PROJECT2_DBA
-- Set user levels, compartments, and groups
-- See: https://docs.oracle.com/en/database/oracle/oracle-database/19/olsag/creating-an-oracle-label-security-policy.html#GUID-180AE22F-C31A-48A9-AE4A-2CAB334746E8
-- Important note: Privileges are *bypasses*, not part of usual policy.
-- See: Slide 21 on https://www.comp.nus.edu.sg/~tankl/cs5322/slides/ols.pdf
--   - READ: Read all rows regardless of policy, e.g. data exporters
--   - FULL: READ privilege + ability to write to *all* data, e.g. data owner
--   - COMPACCESS: Allow access independent of user's groups (but with caveats)
--   - PROFILE_ACCESS: Allow proxy access as other users
--   - WRITEUP/WRITEDOWN: Change sensitivity (by default cannot change once set)
--   - WRITEACROSS: Change compartments/groups, while sensitivity remains the same
DECLARE
  TYPE STRLIST IS TABLE OF VARCHAR2(100);
  ASSIGNMENTS STRLIST;
  USERNAME VARCHAR(100);
  SENS VARCHAR(100);
  COMPS VARCHAR(100);
  GROUPS VARCHAR(100);
  PRIVL VARCHAR(100);
  N BINARY_INTEGER;
BEGIN
  N := 5; -- number of columns in 'ASSIGNMENTS'
  ASSIGNMENTS := STRLIST (
    'PROJECT2_TEST_TS','TS','C','JOINT','', -- GCHQ combat staff
    'PROJECT2_TEST_S','S','T','AIRFORCE','', -- senior commander in air force
    'PROJECT2_TEST_C','C','C,M,T','D1','', -- inventory manager for division 1
    'PROJECT2_TEST_COMM1','TS','C,M,T','D1','WRITEUP', -- secret independent unit mission commander
    'PROJECT2_TEST_COMM2','C','M,T','D2','', -- regular humanitarian mission planner
    'PROJECT2_TEST_COMM3','S','C,M,T','JOINT','WRITEDOWN,WRITEACROSS', -- inventory declassifier (up to S only, no deletion)
    'PROJECT2_TEST_COMM4','C','C,M,T','JOINT','READ', -- inventory auditor (read-only table access as well)
    'PROJECT2_TEST_OTHER1','TS','C,M,T','JOINT','FULL' -- defence minister
  );
  
  -- Drop everything first before writing, just to be safe
  FOR ROW IN (SELECT * FROM DBA_SA_USER_LEVELS)
  LOOP
    SA_USER_ADMIN.DROP_USER_ACCESS (
      policy_name => 'INVENTORY_OLS_POL',
      user_name => ROW.USER_NAME);
  END LOOP;
  
  -- Set levels
  FOR IDX IN ASSIGNMENTS.FIRST..(ASSIGNMENTS.LAST/N)
  LOOP
    USERNAME := ASSIGNMENTS(N*(IDX-1)+1);
    SENS := ASSIGNMENTS(N*(IDX-1)+2);
    COMPS := ASSIGNMENTS(N*(IDX-1)+3);
    GROUPS := ASSIGNMENTS(N*(IDX-1)+4);
    PRIVL := ASSIGNMENTS(N*(IDX-1)+5);
    SA_USER_ADMIN.SET_LEVELS (
      policy_name => 'INVENTORY_OLS_POL',
      user_name => USERNAME,
      max_level => SENS); -- defaults to highest as well
    SA_USER_ADMIN.SET_COMPARTMENTS (
      policy_name => 'INVENTORY_OLS_POL',
      user_name => USERNAME,
      read_comps => COMPS);
    SA_USER_ADMIN.SET_GROUPS (
      policy_name => 'INVENTORY_OLS_POL',
      user_name => USERNAME,
      read_groups => GROUPS);
    SA_USER_ADMIN.SET_USER_PRIVS (
      policy_name => 'INVENTORY_OLS_POL',
      user_name => USERNAME,
      privileges => PRIVL);
  END LOOP;
END;
/
SELECT * FROM DBA_SA_USER_LEVELS;
SELECT * FROM DBA_SA_USER_COMPARTMENTS;
SELECT * FROM DBA_SA_USER_GROUPS;
SELECT * FROM DBA_SA_USER_PRIVS;

-- EXTREMELY IMPORTANT WARNING (again):
-- Once OLS privileges have been assigned, commit, reset your connection again,
-- and save yourself another hour or so. If resetting doesn't change anything,
-- consider resetting all existing connections as well.
