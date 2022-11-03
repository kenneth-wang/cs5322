-------------------------
-- CREATE OLS POLICIES --
-------------------------

---- AS PROJECT2_DBA
-- Create OLS policy container that specifies how policies are added
-- Default column: {{ policy_name }}_COL
-- Policy enforcement: https://docs.oracle.com/en/database/oracle/oracle-database/19/olsag/implementing-policy-enforcement-options-and-labeling-functions.html
-- Note that policies are automatically enabled upon creation.
-- Revoke: SA_SYSDBA.DROP_POLICY('INVENTORY_OLS_POL', TRUE);
BEGIN
  SA_SYSDBA.CREATE_POLICY (
    policy_name => 'INVENTORY_OLS_POL',
    default_options => 'ALL_CONTROL');
END;
/

-- Verify policy created
SELECT * FROM ALL_SA_POLICIES;

-- EXTREMELY IMPORTANT WARNING - will save you a couple hours:
-- When policy is created, the definer will be automatically assigned a role to
-- administrate the policy, i.e. {{ policy_name }}_DBA. You *must* disconnect
-- from the database and connect again to enable this role, otherwise
-- 'ORA-12407: unauthorized operation for policy %s' will always be raised.
-- N.B. Reconnect in SQLDeveloper does *not* work. Do the full disconnect + connect.


---- AS LBACSYS/SYSTEM
-- Verify policy-specific role assigned
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE='PROJECT2_DBA';


---- AS PROJECT2_DBA
-- Create levels
BEGIN
  SA_COMPONENTS.CREATE_LEVEL (
    policy_name => 'INVENTORY_OLS_POL',
    level_num => 10,
    short_name => 'C',
    long_name => 'CONFIDENTIAL');
  SA_COMPONENTS.CREATE_LEVEL (
    policy_name => 'INVENTORY_OLS_POL',
    level_num => 20,
    short_name => 'S',
    long_name => 'SECRET');
  SA_COMPONENTS.CREATE_LEVEL (
    policy_name => 'INVENTORY_OLS_POL',
    level_num => 30,
    short_name => 'TS',
    long_name => 'TOP_SECRET');
END;
/
SELECT * FROM ALL_SA_LEVELS;

-- Create compartments
BEGIN
  SA_COMPONENTS.CREATE_COMPARTMENT (
    policy_name => 'INVENTORY_OLS_POL',
    comp_num => '1',
    short_name => 'C',
    long_name => 'COMBAT');
  SA_COMPONENTS.CREATE_COMPARTMENT (
    policy_name => 'INVENTORY_OLS_POL',
    comp_num => '2',
    short_name => 'T',
    long_name => 'TRANSPORT');
  SA_COMPONENTS.CREATE_COMPARTMENT (
    policy_name => 'INVENTORY_OLS_POL',
    comp_num => '3',
    short_name => 'M',
    long_name => 'MEDICAL');
END;
/
SELECT * FROM ALL_SA_COMPARTMENTS;

-- Create groups
BEGIN
  SA_COMPONENTS.CREATE_GROUP (
    policy_name => 'INVENTORY_OLS_POL',
    group_num => '0',
    short_name => 'JOINT',
    long_name => 'JOINT_COMMAND');
    
  SA_COMPONENTS.CREATE_GROUP (
    policy_name => 'INVENTORY_OLS_POL',
    group_num => '10',
    short_name => 'AIRFORCE',
    long_name => 'AIR_FORCE_SERVICE',
    parent_name => 'JOINT');
  SA_COMPONENTS.CREATE_GROUP (
    policy_name => 'INVENTORY_OLS_POL',
    group_num => '11',
    short_name => 'ARMY',
    long_name => 'ARMY_SERVICE',
    parent_name => 'JOINT');
    
  SA_COMPONENTS.CREATE_GROUP (
    policy_name => 'INVENTORY_OLS_POL',
    group_num => '20',
    short_name => 'D1',
    long_name => 'AIR_FORCE_DIVISION_1',
    parent_name => 'AIRFORCE');
  SA_COMPONENTS.CREATE_GROUP (
    policy_name => 'INVENTORY_OLS_POL',
    group_num => '21',
    short_name => 'D2',
    long_name => 'AIR_FORCE_DIVISION_2',
    parent_name => 'AIRFORCE');
  SA_COMPONENTS.CREATE_GROUP (
    policy_name => 'INVENTORY_OLS_POL',
    group_num => '22',
    short_name => 'D3',
    long_name => 'ARMY_DIVISION_3',
    parent_name => 'ARMY');
  SA_COMPONENTS.CREATE_GROUP (
    policy_name => 'INVENTORY_OLS_POL',
    group_num => '23',
    short_name => 'D4',
    long_name => 'ARMY_DIVISION_4',
    parent_name => 'ARMY');
END;
/
SELECT * FROM ALL_SA_GROUPS;

---- Drop policy and restart...!
--BEGIN
--  SA_SYSDBA.DROP_POLICY('INVENTORY_OLS_POL', TRUE);
--END;
--/


-- Create data labels
-- Looping: https://stackoverflow.com/questions/2242024/for-each-string-execute-a-function-procedure
-- To enable DBMS_OUTPUT in SQLDeveloper for debugging,
--   enable 'View > Dbms Output' and enable DBMS output for the specified connection.
--   Then add the line 'DBMS_OUTPUT.PUT_LINE(COMPARTMENTS(IDX));'
DECLARE
  TYPE STRLIST IS TABLE OF VARCHAR2(100);
  SINGLE_COMPARTMENTS STRLIST;
  MULTI_COMPARTMENTS STRLIST;
  S_TS_LEVELS STRLIST;
  ALL_LEVELS STRLIST;
  G1_GROUPS STRLIST;
  G2_GROUPS STRLIST;
  ALL_GROUPS STRLIST;
  IDX_COUNTER BINARY_INTEGER;
BEGIN
  IDX_COUNTER := 0;
  SINGLE_COMPARTMENTS := STRLIST('C','T','M','');
  MULTI_COMPARTMENTS := STRLIST('C,T','C,M','T,M','C,T,M');
  S_TS_LEVELS := STRLIST('S','TS');
  ALL_LEVELS := STRLIST('C','S','TS');
  G1_GROUPS := STRLIST('AIRFORCE','ARMY');
  G2_GROUPS := STRLIST('D1','D2','D3','D4');
  ALL_GROUPS := STRLIST('JOINT','AIRFORCE','ARMY','D1','D2','D3','D4');
  
  ---------------------------------------------------------------------------
  -- Joint-level user labels, necessarily TS
  FOR IDX IN MULTI_COMPARTMENTS.FIRST..MULTI_COMPARTMENTS.LAST
  LOOP
    IDX_COUNTER := IDX_COUNTER + 1;
    SA_LABEL_ADMIN.CREATE_LABEL (
      policy_name => 'INVENTORY_OLS_POL',
      label_tag => IDX_COUNTER,
      label_value => 'TS:'||MULTI_COMPARTMENTS(IDX)||':JOINT',
      data_label => FALSE);
  END LOOP;

  -- Joint-level data labels, necessarily TS, only one of each compartment
  FOR IDX IN SINGLE_COMPARTMENTS.FIRST..SINGLE_COMPARTMENTS.LAST
  LOOP
    IDX_COUNTER := IDX_COUNTER + 1;
    SA_LABEL_ADMIN.CREATE_LABEL (
      policy_name => 'INVENTORY_OLS_POL',
      label_tag => IDX_COUNTER,
      label_value => 'TS:'||SINGLE_COMPARTMENTS(IDX)||':JOINT',
      data_label => TRUE);
  END LOOP;
  
  ---------------------------------------------------------------------------
  -- Service-level user labels, necessarily S and above
  FOR GIDX IN G1_GROUPS.FIRST..G1_GROUPS.LAST
  LOOP
    FOR CIDX IN MULTI_COMPARTMENTS.FIRST..MULTI_COMPARTMENTS.LAST
    LOOP
      FOR LIDX IN S_TS_LEVELS.FIRST..S_TS_LEVELS.LAST
      LOOP
        IDX_COUNTER := IDX_COUNTER + 1;
        SA_LABEL_ADMIN.CREATE_LABEL (
          policy_name => 'INVENTORY_OLS_POL',
          label_tag => IDX_COUNTER,
          label_value => S_TS_LEVELS(LIDX)||':'||MULTI_COMPARTMENTS(CIDX)||':'||G1_GROUPS(GIDX),
          data_label => FALSE);
      END LOOP;
    END LOOP;
  END LOOP;
  
  -- Service-level data labels, necessarily S and above, only one of each compartment
  FOR GIDX IN G1_GROUPS.FIRST..G1_GROUPS.LAST
  LOOP
    FOR CIDX IN SINGLE_COMPARTMENTS.FIRST..SINGLE_COMPARTMENTS.LAST
    LOOP
      FOR LIDX IN S_TS_LEVELS.FIRST..S_TS_LEVELS.LAST
      LOOP
        IDX_COUNTER := IDX_COUNTER + 1;
        SA_LABEL_ADMIN.CREATE_LABEL (
          policy_name => 'INVENTORY_OLS_POL',
          label_tag => IDX_COUNTER,
          label_value => S_TS_LEVELS(LIDX)||':'||SINGLE_COMPARTMENTS(CIDX)||':'||G1_GROUPS(GIDX),
          data_label => TRUE);
      END LOOP;
    END LOOP;
  END LOOP;
  
  ---------------------------------------------------------------------------
  -- Division-level user labels
  FOR GIDX IN G2_GROUPS.FIRST..G2_GROUPS.LAST
  LOOP
    FOR CIDX IN MULTI_COMPARTMENTS.FIRST..MULTI_COMPARTMENTS.LAST
    LOOP
      FOR LIDX IN ALL_LEVELS.FIRST..ALL_LEVELS.LAST
      LOOP
        IDX_COUNTER := IDX_COUNTER + 1;
        SA_LABEL_ADMIN.CREATE_LABEL (
          policy_name => 'INVENTORY_OLS_POL',
          label_tag => IDX_COUNTER,
          label_value => ALL_LEVELS(LIDX)||':'||MULTI_COMPARTMENTS(CIDX)||':'||G2_GROUPS(GIDX),
          data_label => FALSE);
      END LOOP;
    END LOOP;
  END LOOP;
  
  -- Division-level data labels, only one of each compartment
  FOR GIDX IN G2_GROUPS.FIRST..G2_GROUPS.LAST
  LOOP
    FOR CIDX IN SINGLE_COMPARTMENTS.FIRST..SINGLE_COMPARTMENTS.LAST
    LOOP
      FOR LIDX IN ALL_LEVELS.FIRST..ALL_LEVELS.LAST
      LOOP
        IDX_COUNTER := IDX_COUNTER + 1;
        SA_LABEL_ADMIN.CREATE_LABEL (
          policy_name => 'INVENTORY_OLS_POL',
          label_tag => IDX_COUNTER,
          label_value => ALL_LEVELS(LIDX)||':'||SINGLE_COMPARTMENTS(CIDX)||':'||G2_GROUPS(GIDX),
          data_label => TRUE);
      END LOOP;
    END LOOP;
  END LOOP;
END;
/
SELECT * FROM ALL_SA_LABELS;

-- Drop all labels and restart...!
BEGIN
  FOR ROW IN (SELECT * FROM ALL_SA_LABELS)
  LOOP
    SA_LABEL_ADMIN.DROP_LABEL (
      policy_name => 'INVENTORY_OLS_POL',
      label_value => ROW.LABEL);
  END LOOP;
END;
/

