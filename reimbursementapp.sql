/* Drop the database if it exists */

DROP USER reimbursementapp CASCADE;

/* Create the db */
CREATE USER reimbursementapp
IDENTIFIED BY p4ssw0rd
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE temp
QUOTA 10M ON USERS;

/* Grant user persons */ 

GRANT CONNECT TO reimbursementapp;
GRANT RESOURCE TO reimbursementapp;
GRANT CREATE SESSION TO reimbursementapp;
GRANT CREATE TABLE TO reimbursementapp;
GRANT CREATE VIEW TO reimbursementapp;

/* Connect as the new user */
CONNECT reimbursementapp/p4ssw0rd

/* Create tables */


/* All tables names drop the 'ers.ers_' from diagram.
   ers.ers_users becomes uusers because can't use 'users' */

CREATE TABLE uusers (
    u_id          NUMBER(*, 0) PRIMARY KEY,
    u_username    VARCHAR2(40) UNIQUE NOT NULL,
    u_password    VARCHAR2(40) NOT NULL,
    u_firstname   VARCHAR2(30),
    u_lastname    VARCHAR2(30),
    u_email       VARCHAR(100) UNIQUE,
    ur_id         NUMBER(*,0) NOT NULL
);

CREATE TABLE user_roles (
    ur_id         NUMBER(*, 0) PRIMARY KEY,
    ur_role       VARCHAR2(40)
);

CREATE TABLE reimbursement_status (
    rs_id         NUMBER(*, 0) PRIMARY KEY,
    rs_status     VARCHAR2(30) NOT NULL
);

CREATE TABLE reimbursement_type (
    rt_id         NUMBER(*, 0) PRIMARY KEY,
    rt_type       VARCHAR2(30) NOT NULL
);

CREATE TABLE reimbursements (
    r_id          NUMBER(*, 0) PRIMARY KEY,
    r_amount      NUMBER(22, 2) NOT NULL,
    r_description VARCHAR2(100),
    r_receipt     BLOB,
    r_submitted   TIMESTAMP NOT NULL,
    r_resolved    TIMESTAMP,
    u_id_author   NUMBER(*, 0) NOT NULL,
    u_id_resolver NUMBER(*, 0),
    rt_type       NUMBER(*, 0) NOT NULL,
    rt_status     NUMBER(*, 0) NOT NULL
);

/* Foreign key constraints */

/* Constraint names will be with pattern <table-name>_<extra-info>_fk */

ALTER TABLE uusers ADD
    CONSTRAINT user_roles_fk
    FOREIGN KEY (ur_id)
    REFERENCES user_roles (ur_id);
    
ALTER TABLE reimbursements ADD
    CONSTRAINT uusers_author_fk
    FOREIGN KEY (u_id_author)
    REFERENCES uusers (u_id);
    
ALTER TABLE reimbursements ADD
    CONSTRAINT uusers_resolver_fk
    FOREIGN KEY (u_id_resolver)
    REFERENCES uusers (u_id);
    
ALTER TABLE reimbursements ADD
    CONSTRAINT reimbursement_type_fk
    FOREIGN KEY (rt_type)
    REFERENCES reimbursement_type (rt_id);
    
ALTER TABLE reimbursements ADD
    CONSTRAINT reimbursement_status_fk
    FOREIGN KEY (rt_status)
    REFERENCES reimbursement_status (rs_id);
    
    
/* Add Sequences */

/* Primary key sequence names will be with pattern sq_<table-name>_pk */

CREATE SEQUENCE sq_uusers_pk
    START WITH 1 INCREMENT BY 1;
    
CREATE SEQUENCE sq_user_roles_pk
    START WITH 1 INCREMENT BY 1;
    
CREATE SEQUENCE sq_reimbursement_status_pk
    START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE sq_reimbursement_type_pk
    START WITH 1 INCREMENT BY 1;
    
CREATE SEQUENCE sq_reimbursements_pk
    START WITH 1 INCREMENT BY 1;
    
/* Add Triggers */

/* All triggers start with 'tr_' */

/* Primary key triggers will be with pattern <table-name>_pk */

CREATE OR REPLACE TRIGGER tr_uusers_pk
BEFORE INSERT ON uusers
FOR EACH ROW
BEGIN
    SELECT sq_uusers_pk.NEXTVAL
    INTO :NEW.u_id
    FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER tr_user_roles_pk
BEFORE INSERT ON user_roles
FOR EACH ROW
BEGIN
    SELECT sq_user_roles_pk.NEXTVAL
    INTO :NEW.ur_id
    FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER tr_reimbursement_status_pk
BEFORE INSERT ON reimbursement_status
FOR EACH ROW
BEGIN
    SELECT sq_reimbursement_status_pk.NEXTVAL
    INTO :NEW.rs_id
    FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER tr_reimbursement_type_pk
BEFORE INSERT ON reimbursement_type
FOR EACH ROW
BEGIN
    SELECT sq_reimbursement_type_pk.NEXTVAL
    INTO :NEW.rt_id
    FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER tr_reimbursements_pk
BEFORE INSERT ON reimbursements
FOR EACH ROW
BEGIN
    SELECT sq_reimbursements_pk.NEXTVAL
    INTO :NEW.r_id
    FROM DUAL;
END;
/

/* Create Procedures */






/* Populate Database */
    


