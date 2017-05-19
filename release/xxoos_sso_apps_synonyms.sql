/*
-------------------------------------------------------------------------------
Name .................. xxoos_sso_apps_synonyms.sql
Function .............. SQL script to create APPS synonyms for the SSO tables for the
                        Oracle Open Source - Single Sign On for APEX
Environment ........... Oracle 11gR1 and above
Parameters ............
Arguments:
  Position 1: Name of APPS schema
  Position 2: Name of XX schema
Called by  ............ xxoos_sso_release_apps.sql
User .................. Connect as database user SYSTEM
Comments ..............

Change Log
=====================================================================================================
Date          Rev.	Author		              Comments
=====================================================================================================
14-JUN-2009	  1.0.0   C2 Consulting, Inc.  	Initial Release
02-MAY-2016	  2.0.0   Insum-Sylvain Martel	Initial Public Release
08-AUG-2016   2.1.0   Insum-Sylvain Martel  Review for file names standardization
----------------------------------------------------------------------------------------------------
*/

set define '^'
set concat on
set concat .
set verify off
-- To generate the log properly
set serveroutput on;

define APPS_SCH = '^1'
define XX_SCH   = '^2'

-- To stop the script's execution if it encounters an error
whenever oserror exit
whenever sqlerror exit


prompt Start of script xxoos_sso_apps_synonyms.sql
prompt +++++++++++++++++++++++++++++++++++++++++++++

set verify on

-- Create synonym for the custom tables
-- ====================================================
CREATE OR REPLACE SYNONYM ^APPS_SCH..xxoos_sso_info_defaults FOR ^XX_SCH..xxoos_sso_info_defaults;
CREATE OR REPLACE SYNONYM ^APPS_SCH..xxoos_sso_info FOR ^XX_SCH..xxoos_sso_info;
CREATE OR REPLACE SYNONYM ^APPS_SCH..xxoos_sso_apps FOR ^XX_SCH..xxoos_sso_apps;
CREATE OR REPLACE SYNONYM ^APPS_SCH..xxoos_sso_log FOR ^XX_SCH..xxoos_sso_log;

set verify off

prompt End of script xxoos_sso_apps_synonyms.sql
prompt +++++++++++++++++++++++++++++++++++++++++++



-- ===========================================
-- End of script xxoos_sso_apps_synonyms.sql
-- ===========================================
