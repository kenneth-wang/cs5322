CREATE TABLE Agents (
    id number(10)   NOT NULL,
    username varchar2(50)   NOT NULL,
    password varchar2(50)   NOT NULL,
    name varchar2(50)   NOT NULL,
    mobile_number varchar2(50)   NOT NULL,
    email_address varchar2(50)   NOT NULL,
    CONSTRAINT pk_Agents PRIMARY KEY (
        id
     ),
    CONSTRAINT uc_Agents_username UNIQUE (
        username
    )
);

CREATE TABLE Payment_methods (
    id number(10)   NOT NULL,
    -- specific to this method
    full_name varchar2(50)   NOT NULL,
    -- assume Singapore numbers
    mobile_number varchar2(50)   NOT NULL,
    bank_name varchar2(50)   NOT NULL,
    branch_name varchar2(50)   NOT NULL,
    account_number number(10)   NOT NULL,
    bank_code number(3)   NOT NULL,
    CONSTRAINT pk_Payment_methods PRIMARY KEY (
        id
     )
);

CREATE TABLE insurance_plans (
    id number(10)   NOT NULL,
    value number(10)   NOT NULL,
    policy_description varchar2(100)   NOT NULL,
    CONSTRAINT pk_insurance PRIMARY KEY (
        id
     )
);

CREATE TABLE Customers (
    id int   NOT NULL,
    username varchar2(50)   NOT NULL,
    password varchar2(50)   NOT NULL,
    name varchar2(50)   NOT NULL,
    nric nchar(9)   NOT NULL,
    monthly_salary number(10)   NOT NULL,
    monthly_expenses number(10)   NOT NULL,
    mobile_number varchar2(50)   NOT NULL,
    email_address varchar2(50)   NOT NULL,
    payment_method_id number(10)   NOT NULL,
    agent_id number(10)   NOT NULL,
    CONSTRAINT pk_Customer PRIMARY KEY (
        id
     ),
    CONSTRAINT uc_Customer_username UNIQUE (
        username
    ),
    CONSTRAINT uc_Customer_nric UNIQUE (
        nric
    )
);

DROP TABLE insurance_plans;
CREATE TABLE insurance_plans (
    id number(10)   NOT NULL,
    value number(10)   NOT NULL,
    policy_description varchar2(100)   NOT NULL,
    CONSTRAINT pk_insurance_plans PRIMARY KEY (
        id
     )
);

CREATE TABLE insurance_premiums (
    id number(10)   NOT NULL,
    plan_id number(10)   NOT NULL,
    customer_id number(10)   NOT NULL,
    payment_date date   NOT NULL,
    payment_value_usd float(10)   NOT NULL,
    CONSTRAINT pk_insurance_premiums PRIMARY KEY (
        id
     )
);

CREATE TABLE customer_assignments (
    agent_id number(10)   NOT NULL,
    customer_id number(10)   NOT NULL
);

CREATE TABLE insurance_purchases (
    id number(10)   NOT NULL,
    plan_id number(10)   NOT NULL,
    agent_id number(10)   NOT NULL,
    customer_id number(10)   NOT NULL,
    purchase_date date   NOT NULL,
    purchase_value float(10)   NOT NULL,
    policy_start_date date   NOT NULL,
    -- determines if policy in effect
    policy_end_date date   NOT NULL,
    CONSTRAINT pk_insurance_purchases PRIMARY KEY (
        id
     )
);

CREATE TABLE insurance_claims (
    id number(10)   NOT NULL,
    plan_id number(10)   NOT NULL,
    customer_id number(10)   NOT NULL,
    claim_justification varchar2(100)   NOT NULL,
    claim_value float(10)   NOT NULL,
    -- default: `today()`
    claim_submitted_date date   NULL,
    claim_approved number(1,0)   NOT NULL,
    claim_processed_date date   NOT NULL,
    comments varchar2(100)   NOT NULL,
    claim_disimbursed number(1,0)   NOT NULL,
    claim_disimbursed_date date   NOT NULL,
    bank_transaction_id varchar2(50)   NOT NULL,
    CONSTRAINT pk_insurance_claims PRIMARY KEY (
        id
     )
);
