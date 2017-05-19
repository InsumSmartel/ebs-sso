/*
-------------------------------------------------------------------------------
Name .................. table_xxoos_sso_apps.sql
Purpose ............... SQL Script to create table xxoos_sso_apps for the
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

prompt Validating table xxoos_sso_info
prompt
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ^XX_SCH..xxoos_sso_apps';

EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('table_xxoos_sso_apps.sql: Table xxoos_sso_apps doesn''t exist and cannot be dropped.');
END;
/

prompt Creating table xxoos_sso_apps
prompt
CREATE TABLE ^XX_SCH..xxoos_sso_apps (
  ID NUMBER NOT NULL ENABLE,
	APPS_SESSION VARCHAR2(4000),
	APPS_USER_ID NUMBER,
	USER_NAME VARCHAR2(4000),
	APPS_RESPONSIBILITY_ID NUMBER,
	APPS_APPL_ID NUMBER,
	SWITCH_DATE DATE,
	SWITCH_GUID VARCHAR2(4000),
	APEX_SESSION NUMBER,
	APEX_LAST_VIEWED DATE,
	LOGIN_USED VARCHAR2(1),
	ITEM_LIST VARCHAR2(4000),
	VALUE_LIST VARCHAR2(4000),
	TARGET_PAGE_ID NUMBER,
	INFO_ID NUMBER NOT NULL ENABLE
   );


-- End of script table_xxoos_sso_apps.sql
