/*
-------------------------------------------------------------------------------
Name .................. sso_triggers.sql
Purpose ............... SQL Script calling the create triggers scripts for the
                        Oracle Open Source - Single Sign On for APEX
Environment ........... Oracle 11gR1 and above
Parameters ............
Arguments:
  Position 1: Name of APPS schema
  Position 2: Name of XX schema
Called by  ............ sso_release_xx.sql
User .................. Connect as database user SYSTEM
Comments ..............


Changes
=====================================================================================================
Date          Rev.	Author		            Comments
=====================================================================================================
14-JUN-2009	  1.0   C2 Consulting, Inc.  	Initial Release
02-MAY-2016   2.0   Insum-Sylvain Martel  Initial Public Release
25-MAY-2016   2.01  Insum-Sylvain Martel  Review for standardization
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

prompt Start of script sso_triggers.sql
prompt +++++++++++++++++++++++++++++++++++++++

-- The scripts required in the approrpiate order for your deployement
-- Always use relative paths

-- ============================
-- Triggers
-- ============================
@../triggers/xxoos_sso_info_biu.trg ^XX_SCH;
@../triggers/xxoos_sso_apps_bi.trg ^XX_SCH;
@../triggers/xxoos_sso_info_def_bu.trg ^XX_SCH;
@../triggers/xxoos_sso_log_bi.trg ^XX_SCH;
commit;

prompt End of script sso_triggers.sql
prompt +++++++++++++++++++++++++++++++++++++++


-- End of script sso_triggers.sql
