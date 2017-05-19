/*
-------------------------------------------------------------------------------
Name .................. xxoos_sso_release_xx.sql
Purpose ............... SQL Script to install the database components (tables) for the
                        Oracle Open Source - Single Sign On for APEX
Environment ........... Oracle 11gR1 and above
Parameters ............
Arguments:
  Position 1: Name of APPS schema
  Position 2: Name of XX schema
Called by  ............ xxoos_sso_release.sql
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

-- The scripts required in the approrpiate order for your deployement
-- Always use relative paths

-- ==========================================
-- Install script for each database object
-- ==========================================

prompt ==========================================
prompt Start of script xxoos_sso_release_xx.sql
prompt ==========================================
prompt

@xxoos_create_sso_tables.sql ^APPS_SCH ^XX_SCH;
@../indexes/xxoos_sso_indexes.sql ^APPS_SCH ^XX_SCH;
@../sequences/xxoos_sso_sequences.sql ^APPS_SCH ^XX_SCH;
@../triggers/xxoos_sso_triggers.sql ^APPS_SCH ^XX_SCH;
@xxoos_sso_apex_grants.sql ^APPS_SCH ^XX_SCH;
commit;

prompt
prompt ========================================
prompt End of script xxoos_sso_release_xx.sql
prompt ========================================


-- End of script xxoos_sso_release_xx.sql
