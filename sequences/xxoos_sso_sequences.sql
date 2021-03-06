/*
-------------------------------------------------------------------------------
Name .................. xxoos_sso_sequences.sql
Purpose ............... SQL Script to create sequences for the
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

prompt Start of script xxoos_sso_sequences.sql
prompt +++++++++++++++++++++++++++++++++++++++++

-- The scripts required in the approrpiate order for your deployement
-- Always use relative paths

-- ============================
-- Sequences
-- ============================
@../sequences/xxoos_sso_info_s.seq ^XX_SCH;
@../sequences/xxoos_sso_apps_s.seq ^XX_SCH;
@../sequences/xxoos_sso_log_s.seq ^XX_SCH;
commit;


prompt End of script xxoos_sso_sequences.sql
prompt +++++++++++++++++++++++++++++++++++++++



-- End of script xxoos_sso_sequences.sql
