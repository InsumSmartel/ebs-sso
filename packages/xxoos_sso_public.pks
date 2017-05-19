create or replace PACKAGE ^APPS_SCH..xxoos_sso_public AS
/*
-------------------------------------------------------------------------------
Name .................. xxoos_sso_public.pks
Purpose ............... SQL Script to create package specification xxoos_sso_public for the
                        Oracle Open Source - Single Sign On for APEX
Environment ........... Oracle 11gR1 and above
Parameters ............
Arguments:
  None
Called by  ............ sso_packages.sql
User .................. Connect as database user APPS
Comments ..............


Changes
=====================================================================================================
Date          Rev.	Author		              Comments
=====================================================================================================
14-JUN-2009	  1.0.0   C2 Consulting, Inc.  	Initial Release
02-MAY-2016	  2.0.0   Insum-Sylvain Martel	Initial Public Release
08-AUG-2016   2.1.0   Insum-Sylvain Martel  Review for file names standardization
22-MAR-2017   2.2.0   Insum-Sylvain Martel  Added redirect to Error page in Redirect when Partner Name is not found.
-----------------------------------------------------------------------------------------------------
*/


-- If the login takes too long or the key is invalid, redirect to this url.
-- The value is set in the package body from the xxoos_sso_info_defaults table
gc_invalid_login_url        varchar2(4000);

-- If the key is valid but the user is already logged into the APEX application as a different user, this would
-- cause the user to invalidate the current session and get logged in as the new user. Instead of doing that
-- redirect to the URL stored in the global variable below.
-- The value is set in the package body from the xxoos_sso_info_defaults table
gc_username_mismatch_url    varchar2(4000);

gc_enable_debug             varchar2 (1);



function get_url ( p_id  in number
                 , p_key in varchar2) return varchar2;

procedure set_session_state_redirect( p_id  in number
                                    , p_key in varchar2);

procedure do_auto_login( p_id  in number
                       , p_key in varchar2);

end xxoos_sso_public;
/

-- End of script xxoos_sso_public.pks
