-- https://stackoverflow.com/questions/66491075/how-to-generate-an-id-in-oracle

-- Scenario 1: COMM_1

-- Scenario 1a: See all available vehicles and items
SELECT SA_SESSION.LABEL('INVENTORY_OLS_POL') FROM DUAL; -- current user session label
SELECT SA_SESSION.ROW_LABEL('INVENTORY_OLS_POL') FROM DUAL; -- current data label to be applied
SELECT SA_SESSION.PRIVS('INVENTORY_OLS_POL') FROM DUAL; -- current list of privileges

SELECT * FROM INVENTORY.VEHICLE;
SELECT * FROM INVENTORY.ITEM;
SELECT * FROM INVENTORY.MISSION;
SELECT * FROM INVENTORY.MISSION_ITEMS;
SELECT * FROM INVENTORY.MISSION_VEHICLES;

-- Scenario 1b: Purchase and update all available vehicles and items
DECLARE
  user_label number(5) := SYS_CONTEXT('lbac$0_lab', 'lbac$default_row_tag');
BEGIN
  INSERT INTO INVENTORY.VEHICLE VALUES (
    NULL,
    'CH-47 Chinook',
    'aircraft',
    10,
    'The Boeing CH-47 Chinook is a tandem rotor helicopter developed by American rotorcraft company Vertol and manufactured by Boeing Vertol. ',
    user_label);
  INSERT INTO INVENTORY.ITEM VALUES (
    NULL,
    'nuclear weapon',
    'weapon',
    87,
    'A weapon using nuclear energy.',
    user_label);
  COMMIT;
END;
/
BEGIN
    DELETE FROM INVENTORY.VEHICLE WHERE "model" = 'CH-47 Chinook';
    DELETE FROM INVENTORY.ITEM WHERE "name" = 'nuclear weapon';
    COMMIT;
END;
/

-- Scenario 1c: Create mission & assign vehicles and items
DECLARE
    user_label number(5) := SYS_CONTEXT('lbac$0_lab', 'lbac$default_row_tag');
    
    mission_name varchar(30) := 'Mission Impossible';
    item_name varchar(30) := 'nuclear weapon';
    vehicle_model varchar(30) := 'CH-47 Chinook';
    item_count number := 9;
    vehicle_count number := 10;
    
    mission_id number;
    item_id number;
    vehicle_id number;
BEGIN
    INSERT INTO INVENTORY.MISSION 
    VALUES (NULL,'Mission Impossible','A combat mission that no one think is possible',user_label);
    
    SELECT "id"
    INTO mission_id
    FROM INVENTORY.MISSION
    WHERE "name" = mission_name
    FETCH FIRST 1 ROW ONLY;
    
    SELECT "id"
    INTO item_id
    FROM INVENTORY.ITEM
    WHERE "name" = item_name
    FETCH FIRST 1 ROW ONLY;
    
    SELECT "id"
    INTO vehicle_id
    FROM INVENTORY.VEHICLE
    WHERE "model" = vehicle_model
    FETCH FIRST 1 ROW ONLY;
    
    INSERT INTO INVENTORY.MISSION_ITEMS
    VALUES (mission_id, item_id, item_count, user_label);
    
    INSERT INTO INVENTORY.MISSION_VEHICLES
    VALUES (mission_id, vehicle_id, vehicle_count, user_label);
    
    COMMIT;
END;
/

-- Scenario 2: CHIEF_COMM

-- 2a: Increase sensitivity of Mission Impossible to top secret
SELECT "name", "description", LABEL_TO_CHAR(inventory_ols_pol_col) 
FROM INVENTORY.MISSION;

SELECT "name", "type", LABEL_TO_CHAR(inventory_ols_pol_col) 
FROM INVENTORY.ITEM 
WHERE "type" = 'weapon';

DECLARE
    previous_label number := CHAR_TO_LABEL('INVENTORY_OLS_POL','S:C,T,M:D1');
    new_label number := CHAR_TO_LABEL('INVENTORY_OLS_POL','TS:C,T,M:D1');
BEGIN
    UPDATE INVENTORY.ITEM
        SET INVENTORY_OLS_POL_COL = new_label
        WHERE "name" = 'nuclear weapon' 
        AND INVENTORY_OLS_POL_COL = previous_label;
        
    UPDATE INVENTORY.MISSION
        SET INVENTORY_OLS_POL_COL = new_label
        WHERE "name" = 'Mission Impossible' 
        AND INVENTORY_OLS_POL_COL = previous_label;
END;
/

-- 2b: Decrease sensitivity of Plasters to top secret
SELECT "name", "type", LABEL_TO_CHAR(inventory_ols_pol_col) 
FROM INVENTORY.ITEM 
WHERE "name" = 'plaster';

DECLARE
    previous_label number := CHAR_TO_LABEL('INVENTORY_OLS_POL','TS:M:');
    new_label number := CHAR_TO_LABEL('INVENTORY_OLS_POL','C:M:');
BEGIN
    UPDATE INVENTORY.ITEM
        SET INVENTORY_OLS_POL_COL = new_label
        WHERE "name" = 'plaster' 
        AND INVENTORY_OLS_POL_COL = previous_label;
END;
/
commit;


-- Scenario 3: COMM_4
SELECT SA_SESSION.LABEL('INVENTORY_OLS_POL') FROM DUAL; -- current user session label
SELECT SA_SESSION.ROW_LABEL('INVENTORY_OLS_POL') FROM DUAL; -- current data label to be applied
SELECT SA_SESSION.PRIVS('INVENTORY_OLS_POL') FROM DUAL; -- current list of privileges

SELECT 
    "model",
    SUM("count") as total_count
FROM INVENTORY.VEHICLE 
WHERE "type" = 'uav' 
GROUP BY "model";

