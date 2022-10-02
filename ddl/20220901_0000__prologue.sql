CREATE USER ken IDENTIFIED BY password;

CREATE USER rai IDENTIFIED BY password;

GRANT CREATE SESSION TO ken,
rai;

CREATE TABLE agent_kenneth (
    agent_no NUMBER(4),
    agent_email VARCHAR2(20),
    agent_name VARCHAR2(20)
);

INSERT INTO
    agent_kenneth
VALUES
    (1234, 'KEN', 'Ken');

INSERT INTO
    agent_kenneth
VALUES
    (5678, 'RAI', 'Rai');

GRANT READ ON agent_kenneth TO sysadmin_vpd;

CREATE TABLE customers_kenneth (
    cust_no NUMBER(4),
    cust_name VARCHAR2(20),
    agent_no NUMBER(4)
);

INSERT INTO
    customers_kenneth
VALUES
    (9876, 'ken_customer', 1234);

INSERT INTO
    customers_kenneth
VALUES
    (5432, 'raimi_customer', 5678);

GRANT READ ON customers_kenneth TO sysadmin_vpd;

GRANT READ ON agent_kenneth TO ken,
rai;

GRANT READ ON customers_kenneth TO ken,
rai;

SELECT
    *
FROM
    agent_kenneth;