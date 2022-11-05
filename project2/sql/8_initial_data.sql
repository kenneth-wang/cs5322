-- PROJECT2_TEST_OTHER1
DECLARE
  user_label number(5) := SYS_CONTEXT('lbac$0_lab', 'lbac$default_row_tag');
BEGIN
    INSERT INTO INVENTORY.VEHICLE VALUES (NULL,'CH-47 Chinook','aircraft','90','The Boeing CH-47 Chinook is a tandem rotor helicopter developed by American rotorcraft company Vertol and manufactured by Boeing Vertol. ',CHAR_TO_LABEL('INVENTORY_OLS_POL','C:T:D2'));
    INSERT INTO INVENTORY.VEHICLE VALUES (NULL,'UH-1 Iroquois','aircraft','69','The Bell UH-1 Iroquois is a utility military helicopter designed and produced by the American aerospace company Bell Helicopter.',CHAR_TO_LABEL('INVENTORY_OLS_POL','C:T:D2'));
    INSERT INTO INVENTORY.VEHICLE VALUES (NULL,'AH-64 Apache','aircraft','36','The Boeing AH-64 Apache is an American twin-turboshaft attack helicopter with a tailwheel-type landing gear arrangement and a tandem cockpit for a crew of two. ',CHAR_TO_LABEL('INVENTORY_OLS_POL','S:C:'));
    INSERT INTO INVENTORY.VEHICLE VALUES (NULL,'5-tonner','land','83','The 5-tonner is a Singapore military heave truck.',CHAR_TO_LABEL('INVENTORY_OLS_POL','C::D3'));
    INSERT INTO INVENTORY.VEHICLE VALUES (NULL,'Tank 1','land','88','The Tank 1 is a third-generation main battle tank.',CHAR_TO_LABEL('INVENTORY_OLS_POL','S:C:'));
    INSERT INTO INVENTORY.VEHICLE VALUES (NULL,'LSV','land','35','The Light Strike Vehicle (LSV) is a light fast attack vehicle used by the Singapore Army.',CHAR_TO_LABEL('INVENTORY_OLS_POL','S:C:D3'));
    INSERT INTO INVENTORY.VEHICLE VALUES (NULL,'H-450 Hermes','uav','81','The Elbit Hermes 450 is an Israeli medium-sized multi-payload unmanned aerial vehicle (UAV) designed for tactical long endurance missions. ',CHAR_TO_LABEL('INVENTORY_OLS_POL','S:C:AIRFORCE'));
    INSERT INTO INVENTORY.VEHICLE VALUES (NULL,'Skyblade III','uav','65','The Skyblade III Mini Unmanned Aerial Vehicle (UAV) is used by scout teams to conduct recce operations with both day-use and night-use cameras. ',CHAR_TO_LABEL('INVENTORY_OLS_POL','C:C:D3'));
    INSERT INTO INVENTORY.VEHICLE VALUES (NULL,'Skyblade III','uav','92','The Skyblade III Mini Unmanned Aerial Vehicle (UAV) is used by scout teams to conduct recce operations with both day-use and night-use cameras. ',CHAR_TO_LABEL('INVENTORY_OLS_POL','C:C:D4'));
    INSERT INTO INVENTORY.VEHICLE VALUES (NULL,'IAI Heron 1','uav','40','The IAI Heron (Machatz-1) is a medium-altitude long-endurance unmanned aerial vehicle (UAV) developed by the Malat (UAV) division of Israel Aerospace Industries. ',CHAR_TO_LABEL('INVENTORY_OLS_POL','C::D1'));
    INSERT INTO INVENTORY.VEHICLE VALUES (NULL,'M142 HIMARS','artillery','73','The M142 HIMARS is a light multiple rocket launcher developed in the late 1990s for the United States Army and mounted on a standard United States Army Family of Medium Tactical Vehicles truck frame.',CHAR_TO_LABEL('INVENTORY_OLS_POL','C:C:D3'));
    INSERT INTO INVENTORY.VEHICLE VALUES (NULL,'H-450 Hermes','uav','62','The Elbit Hermes 450 is an Israeli medium-sized multi-payload unmanned aerial vehicle (UAV) designed for tactical long endurance missions. ',CHAR_TO_LABEL('INVENTORY_OLS_POL','TS:C:AIRFORCE'));
    INSERT INTO INVENTORY.VEHICLE VALUES (NULL,'Mobile Swab Station','medical','82','The MSS is an integrated platform using the Singapore Armed Forces (SAF) Cross Country Ambulance, modified to be mounted with a similar swab protection screen used by Singapore General Hospitals SG Swab Assurance for Everyone (SG SAFE) system.',CHAR_TO_LABEL('INVENTORY_OLS_POL','C:M:'));
    INSERT INTO INVENTORY.VEHICLE VALUES (NULL,'Battalion Casualty Station','medical','93','The BCS is a fully equipped medical station mounted on a military 5-ton truck. It can provide triage and treatment for casualties.',CHAR_TO_LABEL('INVENTORY_OLS_POL','C:M:D4'));

    INSERT INTO INVENTORY.ITEM VALUES (NULL,'ak-47','weapon','70','A very lethal gun.',CHAR_TO_LABEL('INVENTORY_OLS_POL','S:C:'));
    INSERT INTO INVENTORY.ITEM VALUES (NULL,'plaster','medical','19','An adhesive strip of material for covering cuts and wounds.',CHAR_TO_LABEL('INVENTORY_OLS_POL','C:M:'));
    INSERT INTO INVENTORY.ITEM VALUES (NULL,'carbine','weapon','16','A firearm similar to a lightweight rifle but with a shorter barrel.',CHAR_TO_LABEL('INVENTORY_OLS_POL','S:C:'));
    INSERT INTO INVENTORY.ITEM VALUES (NULL,'iodine','medical','89','A solution of iodine in alcohol, used as a mild antiseptic.',CHAR_TO_LABEL('INVENTORY_OLS_POL','C:M:'));
    INSERT INTO INVENTORY.ITEM VALUES (NULL,'nuclear weapon','weapon','97','A weapon using nuclear energy.',CHAR_TO_LABEL('INVENTORY_OLS_POL','TS:C:'));
    INSERT INTO INVENTORY.ITEM VALUES (NULL,'spare tyre','transport','97','A tyre for the weak.',CHAR_TO_LABEL('INVENTORY_OLS_POL','C:T:'));
    INSERT INTO INVENTORY.ITEM VALUES (NULL,'car battery','transport','49','Batteries to power up your car.',CHAR_TO_LABEL('INVENTORY_OLS_POL','C:M:'));
    INSERT INTO INVENTORY.ITEM VALUES (NULL,'winter tyres','transport','48','Battle-tested tyres that can brave through the cold winter.',CHAR_TO_LABEL('INVENTORY_OLS_POL','S:T:'));
    
    INSERT INTO INVENTORY.MISSION VALUES (NULL,'Operation Nightmare','An operation that gives people nightmares',user_label);
  COMMIT;
END;
/
