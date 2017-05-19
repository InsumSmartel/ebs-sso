/*
-------------------------------------------------------------------------------
Name .................. xxoos_sso_apps_pk.sql
Purpose ............... SQL Script to create index on table xxoos_sso_apps for the
                        Oracle Open Source - Single Sign On for APEX
Environment ........... Oracle 11gR1 and above
Parameters ............
Arguments:
  Position 1: Name of XX schema
Called by  ............ xxoos_sso_indexes.sql
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

-- ------------------------------------------
-- Create Index
-- ------------------------------------------
prompt Creating Index xxoos_sso_apps_pk
prompt
CREATE UNIQUE INDEX ^XX_SCH..xxoos_sso_apps_pk
ON ^XX_SCH..xxoos_sso_apps (ID);



-- End of script xxoos_sso_apps_pk.sql
