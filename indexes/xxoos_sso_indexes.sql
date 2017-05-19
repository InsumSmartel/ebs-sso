/*
-------------------------------------------------------------------------------
Name .................. xxoos_sso_indexes.sql
Purpose ............... SQL Script calling the create indexes scripts for the Insum-C2 APEX SSO
Environment ........... Oracle 11gR1 / 11gR2
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

prompt Start of script xxoos_sso_indexes.sql
prompt +++++++++++++++++++++++++++++++++++++++

-- The scripts required in the approrpiate order for your deployement
-- Always use relative paths

-- ============================
-- Indexes
-- ============================
@../indexes/xxoos_sso_apps_pk.sql ^XX_SCH;
@../indexes/xxoos_sso_info_pk.sql ^XX_SCH;
@../indexes/xxoos_sso_info_uk1.sql ^XX_SCH;
commit;


prompt End of script xxoos_sso_indexes.sql
prompt +++++++++++++++++++++++++++++++++++++++


-- End of script xxoos_sso_indexes.sql
