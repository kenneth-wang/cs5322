--- SYSTEM
CREATE TABLE INVENTORY.ITEM (
    "id" number DEFAULT ON  NULL to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') NOT NULL,
    "name" varchar2(256)   NOT NULL,
    "type" varchar2(256)   NOT NULL,
    "count" number(3)   NOT NULL,
    "description" varchar2(256)   NOT NULL,
    CONSTRAINT "pk_INVENTORY_ITEM" PRIMARY KEY (
        "id"
     )
);
DROP TABLE INVENTORY.ITEM;

CREATE TABLE INVENTORY.VEHICLE (
    "id" number DEFAULT ON  NULL to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') NOT NULL,
    "model" varchar2(256)   NOT NULL,
    "type" varchar2(256)   NOT NULL,
    "count" number(3)   NOT NULL,
    "description" varchar2(256)   NOT NULL,
    CONSTRAINT "pk_INVENTORY_VEHICLE" PRIMARY KEY (
        "id"
     )
);
DROP TABLE INVENTORY.VEHICLE;

CREATE TABLE INVENTORY.MISSION (
    "id" number DEFAULT ON  NULL to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') NOT NULL,
    "name" varchar2(256)   NOT NULL,
    "description" varchar2(256)   NOT NULL,
    CONSTRAINT "pk_MISSION" PRIMARY KEY (
        "id"
     )
);
DROP TABLE INVENTORY.MISSION;

CREATE TABLE "INVENTORY"."MISSION_ITEMS" (
    "mission_id" number   NOT NULL,
    "item_id" number   NOT NULL,
    "count" number(3)   NOT NULL
);
DROP TABLE INVENTORY.MISSION_ITEMS;

CREATE TABLE "INVENTORY"."MISSION_VEHICLES" (
    "mission_id" number   NOT NULL,
    "vehicle_id" number   NOT NULL,
    "count" number(3)   NOT NULL
);
DROP TABLE INVENTORY.MISSION_VEHICLES;
