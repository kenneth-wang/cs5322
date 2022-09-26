-- Create customers table
CREATE TABLE customers (
 cust_no    NUMBER(4), 
 cust_email VARCHAR2(20),
 cust_name  VARCHAR2(20));

INSERT INTO customers VALUES (1234, 'TBROOKE', 'Thadeus Brooke');
INSERT INTO customers VALUES (5678, 'OWOODS', 'Oberon Woods');

GRANT READ ON customers TO sysadmin_vpd;

-- Create orders table
CREATE TABLE orders_tab (
  cust_no  NUMBER(4),
  order_no NUMBER(4));

INSERT INTO orders_tab VALUES (1234, 9876);
INSERT INTO orders_tab VALUES (5678, 5432);
INSERT INTO orders_tab VALUES (5678, 4592);

-- Read from orders table to check that rows are inserted
SELECT * FROM orders_tab;

-- ALlow tbrooke and owoods to read the orders table
GRANT READ ON orders_tab TO tbrooke, owoods;