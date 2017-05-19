/*
-------------------------------------------------------------------------------
Name .................. xxoos_sso_release.sql
Purpose ............... SQL Script to install database objects (tables and PL/SQL packages)
                        for the Oracle Open Source - Single Sign On for APEX
Environment ........... Oracle 11gR1 and above
Parameters ............
Arguments:
  Position 1: Name of APPS schema
  Position 2: Name of XX schema
Called by  ............ Manually
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


-- To stop the script's execution if it encounters an error
whenever oserror exit
whenever sqlerror exit

set verify off
set echo off
set define &
column logfile new_val logfile
 select 'xxoos_sso_release_install_' || to_char(sysdate, 'YYYYMMDDHH24MISS') || '.log' logfile
 from dual;
spool &logfile

set define '^'
set concat on
set concat .
-- To generate the log properly
set serveroutput on;

define APPS_SCH = '^1'
define XX_SCH   = '^2'


-- The scripts required in the approrpiate order for your deployement
-- Always use relative paths

-- ==========================================
-- Install script for each database object
-- ==========================================
prompt
prompt
prompt
prompt
prompt ======================================
prompt Insum EBS-APEX SSO Installation
prompt Parameters:
prompt APPS schema is: ^APPS_SCH
prompt Custom schema is: ^XX_SCH
prompt ======================================
prompt
prompt

prompt =======================================
prompt Start of script xxoos_sso_release.sql
prompt =======================================
prompt

prompt
prompt Calling script xxoos_sso_release_xx.sql
prompt +++++++++++++++++++++++++++++++++++++++++
prompt
@@xxoos_sso_release_xx.sql ^APPS_SCH ^XX_SCH;

prompt
prompt
prompt Calling script xxoos_sso_release_apps.sql
prompt +++++++++++++++++++++++++++++++++++++++++++
prompt
@@xxoos_sso_release_apps.sql ^APPS_SCH ^XX_SCH;


-- ======================================
-- INSTALLATION SUMMARY
-- ======================================
set linesize 240
set pagesize 66

prompt
prompt
prompt Summary - List of SSO Tables
prompt +++++++++++++++++++++++++++++++++++++
select OWNER, TABLE_NAME, TABLESPACE_NAME
from all_tables
where UPPER(table_name) like 'XXOOS%SSO%'
;

prompt
prompt
prompt Summary - List of SSO Indexes
prompt +++++++++++++++++++++++++++++++++++++
select OWNER, INDEX_NAME, TABLE_NAME
from all_indexes
where UPPER(index_name) like 'XXOOS%SSO%'
;

prompt
prompt
prompt Summary - List of SSO Sequences
prompt +++++++++++++++++++++++++++++++++++++
select SEQUENCE_OWNER, SEQUENCE_NAME
from all_sequences
where UPPER(sequence_name) like 'XXOOS%SSO%'
;

prompt
prompt
prompt Summary - List of SSO Triggers
prompt +++++++++++++++++++++++++++++++++++++
select OWNER, TRIGGER_NAME
from all_triggers
where UPPER(trigger_name) like 'XXOOS%SSO%'
;

prompt
prompt
prompt Summary - List of SSO Grants
prompt +++++++++++++++++++++++++++++++++++++
select *
  from dba_tab_privs
 where owner in (^APPS_SCH,^XX_SCH)
   and table_name like 'XXOOS%SSO%'
   and privilege in ('EXECUTE','SELECT')
 order by grantee, owner, table_name
;

prompt
prompt
prompt Summary - List of SSO Synonyms
prompt +++++++++++++++++++++++++++++++++++++
select OWNER, SYNONYM_NAME, TABLE_OWNER as OBJECT_OWNER, TABLE_NAME as OBJECT_NAME
from all_synonyms
where UPPER(synonym_name) like 'XXOOS%SSO%'
;




prompt
prompt
prompt ======================================
prompt End of script xxoos_sso_release.sql
prompt ======================================

-- Close the spool
spool off;

-- End of script xxoos_sso_release.sql
