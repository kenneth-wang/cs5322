-- https://stackoverflow.com/questions/66491075/how-to-generate-an-id-in-oracle

-- Scenario 1: PROJECT2_TEST_COMM1 --

-- Scenario 1a: See all available vehicles and items
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

-- Scenario 2
UPDATE INVENTORY.VEHICLE
SET INVENTORY_OLS_POL_COL = CHAR_TO_LABEL('INVENTORY_OLS_POL','C:C:D1')
  	WHERE VEHICLE_ID IN (2, 3);


-- Scenario 3
SELECT "model", SUM("count") as "count" FROM INVENTORY.VEHICLE WHERE "type" = 'uav' GROUP BY "model";
