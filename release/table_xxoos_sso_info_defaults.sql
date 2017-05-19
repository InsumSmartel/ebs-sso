/*
-------------------------------------------------------------------------------
Name .................. table_xxoos_sso_info_defaults.sql
Purpose ............... SQL Script to create table xxoos_sso_info_defaults for the Insum-C2 APEX SSO
                        Oracle Open Source - Single Sign On for APEX
Environment ........... Oracle 11gR1 and above
Parameters ............
Arguments:
  Position 1: Name of XX schema
Called by  ............ create_sso_tables.sql
User .................. Connect as database user SYSTEM
Comments ..............


Changes
=====================================================================================================
Date          Rev.	Author		              Comments
=====================================================================================================
14-JUN-2009	  1.0.0   C2 Consulting, Inc.  	Initial Release
02-MAY-2016	  2.0.0   Insum-Sylvain Martel	Initial Public Release
08-AUG-2016   2.1.0   Insum-Sylvain Martel  Review for file names standardization
-----------------------------------------------------------------------------------------------------
*/

set define '^'
set concat on
set concat .
set verify off
-- To generate the log properly
set serveroutput on;

define XX_SCH = '^1'

-- To stop the script's execution if it encounters an error
whenever oserror exit
whenever sqlerror exit

prompt Validating table xxoos_sso_info_defaults
prompt
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ^XX_SCH..xxoos_sso_info_defaults';

EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('table_xxoos_sso_info_defaults.sql: Table xxoos_sso_info_defaults doesn''t exist and cannot be dropped.');
END;
/

prompt Creating table xxoos_sso_info_defaults
prompt
CREATE TABLE ^XX_SCH..xxoos_sso_info_defaults (
  ID NUMBER NOT NULL ENABLE,
	APEX_URL VARCHAR2(4000 BYTE),
	APEX_SWITCH_SECONDS NUMBER,
	APEX_IDLE_MINUTES NUMBER,
  APEX_NEW_SESSION VARCHAR2(1),
  SSO_USED_WITH_EBS VARCHAR2(1),
	PUBLIC_PAGE_ID NUMBER,
	WORKSPACE_SSO_APP_ID NUMBER,
	WORKSPACE_SSO_PAGE_ID NUMBER,
	INVALID_LOGIN_URL VARCHAR2(4000 BYTE),
	USERNAME_MISMATCH_URL VARCHAR2(4000 BYTE),
  INVALID_PARTNER_URL VARCHAR2(4000 BYTE),
  DEFAULT_PAGE_ID NUMBER,
  DEBUG_FLAG VARCHAR2(1),
  CREATED TIMESTAMP (6) WITH LOCAL TIME ZONE,
  CREATED_BY VARCHAR2(255 BYTE),
  UPDATED TIMESTAMP (6) WITH LOCAL TIME ZONE,
  UPDATED_BY VARCHAR2(255 BYTE)
   );


INSERT INTO ^XX_SCH..xxoos_sso_info_defaults
 (ID,
  APEX_URL,
  APEX_SWITCH_SECONDS,
  APEX_IDLE_MINUTES,
  APEX_NEW_SESSION,
  SSO_USED_WITH_EBS,
  PUBLIC_PAGE_ID,
  WORKSPACE_SSO_APP_ID,
  WORKSPACE_SSO_PAGE_ID,
  INVALID_LOGIN_URL,
  USERNAME_MISMATCH_URL,
  INVALID_PARTNER_URL,
  DEFAULT_PAGE_ID,
  DEBUG_FLAG,
  CREATED,
  CREATED_BY,
  UPDATED,
  UPDATED_BY)
VALUES
 (1001,
  'http://yourserver:8080/apex/',
  5,
  10,
  'Y',
  'Y',
  102,
  99999,
  1,
  'http://yourserver:8080/apex/f?p=SSO_SWITCH:INVALID_LOGIN',
  'http://yourserver:8080/apex/f?p=SSO_SWITCH:INVALID_USERNAME',
  'http://yourserver:8080/apex/f?p=SSO_SWITCH:INVALID_PARTNER',
  1,
  null,
  to_timestamp('01-JAN-16 12.00.00.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),
  'SYLVAIN.MARTEL',
  to_timestamp('01-JAN-16 12.00.00.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),
  'SYLVAIN.MARTEL'
 );
COMMIT;

-- End of script table_xxoos_sso_info_defaults.sql
