  /*
-------------------------------------------------------------------------------
Name .................. xxoos_sso_apex_grants.sql
Function .............. SQL script to create the grants on sso tables for APPS for the
                        Oracle Open Source - Single Sign On for APEX
Environment ........... Oracle 11gR1 and above
Parameters ............
Arguments:
  Position 1: Name of APPS schema
  Position 2: Name of XX schema
Called by  ............ xxoos_sso_release_xx.sql
User .................. Connect as database user SYSTEM
Comments ..............

Change Log
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


prompt Start of script xxoos_sso_apex_grants.sql
prompt +++++++++++++++++++++++++++++++++++++++++++

set verify on

-- Grants to APPS schema for the custom tables
-- ======================================================
GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON
^XX_SCH..xxoos_sso_info_defaults TO ^APPS_SCH. WITH GRANT OPTION;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON
^XX_SCH..xxoos_sso_info TO ^APPS_SCH. WITH GRANT OPTION;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON
^XX_SCH..xxoos_sso_apps TO ^APPS_SCH. WITH GRANT OPTION;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON
^XX_SCH..xxoos_sso_log TO ^APPS_SCH. WITH GRANT OPTION;

commit;
set verify off

prompt End of script xxoos_sso_apex_grants.sql
prompt +++++++++++++++++++++++++++++++++++++++++



-- =========================================
-- End of script xxoos_sso_apex_grants.sql
-- =========================================
