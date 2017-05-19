/*
-------------------------------------------------------------------------------
Name .................. xxoos_sso_info_biu.trg
Purpose ............... SQL Script to create trigger on table xxoos_sso_info for the
                        Oracle Open Source - Single Sign On for APEX
Environment ........... Oracle 11gR1 and above
Parameters ............
Arguments:
  Position 1: Name of XX schema
Called by  ............ xxoos_sso_triggers.sql
User .................. Connect as database user SYSTEM
Comments ..............


Changes
=====================================================================================================
Date          Rev.	Author		            Comments
=====================================================================================================
14-JUN-2009	  1.0   C2 Consulting, Inc.  	Initial Release
02-MAY-2016	  2.0   Insum-Sylvain Martel	Initial Public Release
25-MAY-2016   2.01  Insum-Sylvain Martel  Review for standardization
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
-- Create Trigger
-- ------------------------------------------
prompt Creating Trigger xxoos_sso_info_biu
prompt
CREATE OR REPLACE TRIGGER ^XX_SCH..xxoos_sso_info_biu  -- EDITIONABLE for release 12c and up
  before insert or update on ^XX_SCH..xxoos_sso_info
  for each row
  begin

    if inserting then
      if :NEW.ID is null then
        select ^XX_SCH..xxoos_sso_info_s.nextval into :NEW.ID from dual;
      end if;

      :NEW.CREATED := localtimestamp;
      :NEW.CREATED_BY := nvl(v('APP_USER'),USER);
      :NEW.UPDATED := localtimestamp;
      :NEW.UPDATED_BY := nvl(v('APP_USER'),USER);
    end if;

    if updating then
      :NEW.UPDATED := localtimestamp;
      :NEW.UPDATED_BY := nvl(v('APP_USER'),USER);
    end if;
  end;
/

ALTER TRIGGER ^XX_SCH..xxoos_sso_info_biu ENABLE;


-- End of script xxoos_sso_info_biu.trg
