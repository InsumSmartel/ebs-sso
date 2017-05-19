/*
-------------------------------------------------------------------------------
Name .................. sso_apps_grants.sql
Function .............. SQL script to create grants for the PL/SQL packages to the DB schema having the tables for the
                        Oracle Open Source - Single Sign On for APEX
Environment ........... Oracle 11gR1 and above
Parameters ............
Arguments:
  Position 1: Name of APPS schema
  Position 2: Name of XX schema
Called by  ............ sso_release_apps.sql
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


prompt Start of script sso_apps_grants.sql
prompt +++++++++++++++++++++++++++++++++++++++

-- Create grants for the common PL/SQL packages
-- ====================================================
GRANT EXECUTE ON ^APPS_SCH..xxoos_sso_partner_utils TO ^XX_SCH.;
GRANT EXECUTE ON ^APPS_SCH..xxoos_sso_public TO ^XX_SCH.;

prompt End of script sso_apps_grants.sql
prompt +++++++++++++++++++++++++++++++++++++++



-- =========================================
-- End of script sso_apps_grants.sql
-- =========================================
