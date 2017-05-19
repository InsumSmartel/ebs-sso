create or replace PACKAGE ^APPS_SCH..xxoos_sso_partner_utils AS
/*
-------------------------------------------------------------------------------
Name .................. xxoos_sso_partner_utils.pks
Purpose ............... SQL Script to create package specification xxoos_sso_partner_utils for the
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

-- If the call to the SSO engine doesn't return a valid partner name and partner key combination, redirect to this url.
-- The value is set in the package body from the xxoos_sso_info_defaults table
gc_invalid_partner_url    varchar2(4000);


gc_enable_debug             varchar2 (1);


-- Used specifically for oracle E-Business Suite calls to APEX applications
function apps2apex_get_url( p_url_designator      in varchar2
                          , p_partner_name        in varchar2
                          , p_partner_key         in varchar2
                          , p_user_id             in number
                          , p_user_name           in varchar2
                          , p_target_page_id      in number default null
                          , p_appl_id             in number default null
                          , p_responsibility_id   in number default null
                          , p_session_id          in number default null
                          , p_item_list           in varchar2 default null
                          , p_value_list          in varchar2 default null
                          ) return varchar2;


-- Used for any generic partner/system calling an APEX application
function partner2apex_get_url(  p_url_designator      in varchar2
                              , p_partner_name        in varchar2
                              , p_partner_key         in varchar2
                              , p_user_name           in varchar2
                              , p_target_page_id      in number default null
                              , p_item_list           in varchar2 default null
                              , p_value_list          in varchar2 default null
                              ) return varchar2;


END xxoos_sso_partner_utils;
/
-- End of script xxoos_sso_partner_utils.pks
