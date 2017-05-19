/*
-------------------------------------------------------------------------------
Name .................. xxoos_create_sso_tables.sql
Purpose ............... SQL Script calling the create tables scripts for the
                        Oracle Open Source - Single Sign On for APEX
Environment ........... Oracle 11gR1 and above
Parameters ............
Arguments:
  Position 1: Name of APPS schema
  Position 2: Name of XX schema
Called by  ............ xxoos_sso_release_xx.sql
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

define APPS_SCH = '^1'
define XX_SCH   = '^2'

-- To stop the script's execution if it encounters an error
whenever oserror exit
whenever sqlerror exit


prompt Start of script xxoos_create_sso_tables.sql
prompt +++++++++++++++++++++++++++++++++++++++++++++

-- The scripts required in the approrpiate order for your deployement
-- Always use relative paths

-- ============================
-- Tables
-- ============================
@table_xxoos_sso_info.sql ^XX_SCH;
@table_xxoos_sso_info_defaults.sql ^XX_SCH;
@table_xxoos_sso_apps.sql ^XX_SCH;
@table_xxoos_sso_log.sql ^XX_SCH;
commit;

prompt End of script xxoos_create_sso_tables.sql
prompt +++++++++++++++++++++++++++++++++++++++++++



-- End of script xxoos_create_sso_tables.sql
