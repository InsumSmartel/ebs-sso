/*
-------------------------------------------------------------------------------
Name .................. table_xxoos_sso_info.sql
Purpose ............... SQL Script to create table xxoos_sso_info for the
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
   EXECUTE IMMEDIATE 'DROP TABLE ^XX_SCH..xxoos_sso_info';

EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('table_xxoos_sso_info.sql: Table xxoos_sso_info doesn''t exist and cannot be dropped.');
END;
/

prompt Creating table xxoos_sso_info
prompt
CREATE TABLE ^XX_SCH..xxoos_sso_info (
  ID NUMBER NOT NULL ENABLE,
  SSO_USED_WITH_EBS VARCHAR2(1),
	URL_DESIGNATOR VARCHAR2(256 BYTE) NOT NULL ENABLE,
	APEX_URL VARCHAR2(4000 BYTE) NOT NULL ENABLE,
	APEX_SWITCH_SECONDS NUMBER NOT NULL ENABLE,
	APEX_IDLE_MINUTES NUMBER,
  APEX_NEW_SESSION VARCHAR2(1),
	PARTNER_NAME VARCHAR2(256 BYTE) NOT NULL ENABLE,
	PARTNER_KEY VARCHAR2(256 BYTE) NOT NULL ENABLE,
	ALLOWABLE_ITEMS VARCHAR2(4000 BYTE),
	APEX_APP_ID NUMBER NOT NULL ENABLE,
	DEFAULT_PAGE_ID NUMBER NOT NULL ENABLE,
	PUBLIC_PAGE_ID NUMBER NOT NULL ENABLE,
	WORKSPACE_SSO_APP_ID NUMBER,
	WORKSPACE_SSO_PAGE_ID NUMBER,
  APPLICATION_USAGE VARCHAR2(2000 BYTE),
  CREATED  TIMESTAMP (6) WITH LOCAL TIME ZONE,
  CREATED_BY VARCHAR2(255 BYTE),
  UPDATED  TIMESTAMP (6) WITH LOCAL TIME ZONE,
  UPDATED_BY VARCHAR2(255 BYTE)
   );


-- End of script table_xxoos_sso_info.sql
