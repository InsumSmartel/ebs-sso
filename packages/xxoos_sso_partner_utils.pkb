create or replace PACKAGE BODY ^APPS_SCH..xxoos_sso_partner_utils AS
/*
-------------------------------------------------------------------------------
Name .................. xxoos_sso_partner_utils.pkb
Purpose ............... SQL Script to create package body xxoos_sso_partner_utils for the
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


gc_space     constant varchar2(1) := ' ';
gc_amp       constant varchar2(1) := '&';
gc_N         constant varchar2(1) := 'N';
gc_Y         constant varchar2(1) := 'Y';
gc_dot       constant varchar2(1) := '.';

gc_redirect_proc  constant varchar2(240) := 'xxoos_sso_public.doredirect?pid=#PID#&pkey=#KEY#';


/* ----------------------------------------------------------------------------
 * Name            : get_url
 * Author          : C2 Consulting, Inc.
 * Date            : 14-JUN-2009
 * Description     :
 * ---------------------------------------------------------------------------- */
function get_url( p_url_designator      in varchar2
                , p_partner_name        in varchar2
                , p_partner_key         in varchar2
                , p_user_id             in varchar2 default null
                , p_user_name           in varchar2 default null
                , p_target_page_id      in number
                , p_appl_id             in number default null
                , p_responsibility_id   in number default null
                , p_session_id          in number default null
                , p_item_list           in varchar2 default null
                , p_value_list          in varchar2 default null) return varchar2 is
  PRAGMA AUTONOMOUS_TRANSACTION;

l_url               varchar2(4000);
l_guid              varchar2(4000);
l_info_rec          xxoos_sso_info%rowtype;
l_id                xxoos_sso_apps.id%type;

begin

  select s.*
    into l_info_rec
    from xxoos_sso_info s
    where s.url_designator = p_url_designator
      and s.partner_name = p_partner_name
      and s.partner_key = p_partner_key;

  l_guid := replace(replace(SYS_GUID(), gc_amp, null), gc_space, null) || to_char(systimestamp, 'FF');

  -- validate list of items passed in here

  insert into xxoos_sso_apps (apps_user_id, user_name, apps_responsibility_id, apps_appl_id, switch_date, switch_guid, login_used, item_list, value_list, target_page_id, info_id)
  values (p_user_id, p_user_name, p_responsibility_id, p_appl_id, sysdate, l_guid, gc_N, p_item_list, p_value_list, p_target_page_id, l_info_rec.id )
  returning id into l_id;

  commit;

  l_url := l_info_rec.apex_url || 'f?p=' || l_info_rec.workspace_sso_app_id  || ':' ||
                                            l_info_rec.workspace_sso_page_id || ':0::::P1_ID,P1_KEY:' || l_id ||',' || l_guid;

  return l_url;

exception when no_data_found then
  -- invalid combination of url_designator, partner_name, partner_key
  -- Redirect to Invalid Partner Error Page
  return gc_invalid_partner_url;

end get_url;


/* ----------------------------------------------------------------------------
 * Name            : apps2apex_get_url
 * Author          : C2 Consulting, Inc.
 * Date            : 14-JUN-2009
 * Description     : used specifically for oracle applications (E-Business Suite)
 * ---------------------------------------------------------------------------- */
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
                          ) return varchar2 is

l_url       varchar2(4000);

begin

  l_url := get_url( p_url_designator      => p_url_designator
                  , p_partner_name        => p_partner_name
                  , p_partner_key         => p_partner_key
                  , p_user_id             => p_user_id
                  , p_user_name           => p_user_name
                  , p_target_page_id      => p_target_page_id
                  , p_appl_id             => p_appl_id
                  , p_responsibility_id   => p_responsibility_id
                  , p_session_id          => p_session_id
                  , p_item_list           => p_item_list
                  , p_value_list          => p_value_list);



  return l_url;

end apps2apex_get_url;


/* ----------------------------------------------------------------------------
 * Name            : apps2apex_get_url
 * Author          : C2 Consulting, Inc.
 * Date            : 14-JUN-2009
 * Description     : used for generic applications
 * ---------------------------------------------------------------------------- */
function partner2apex_get_url(  p_url_designator      in varchar2
                              , p_partner_name        in varchar2
                              , p_partner_key         in varchar2
                              , p_user_name           in varchar2
                              , p_target_page_id      in number default null
                              , p_item_list           in varchar2 default null
                              , p_value_list          in varchar2 default null
                              ) return varchar2 is

l_url varchar2(4000);

begin

  l_url := get_url( p_url_designator      => p_url_designator
                  , p_partner_name        => p_partner_name
                  , p_partner_key         => p_partner_key
                  --, p_user_id             => p_user_id
                  , p_user_name           => p_user_name
                  , p_target_page_id      => p_target_page_id
                  --, p_appl_id             => p_appl_id
                  --, p_responsibility_id   => p_responsibility_id
                  --, p_session_id          => p_session_id
                  , p_item_list           => p_item_list
                  , p_value_list          => p_value_list);



  return l_url;

end partner2apex_get_url;



/* ----------------------------------------------------------------------------
 * Name            : -
 * Author          : Sylvain Martel
 * Date            : 05-FEB-2016
 * Description     : Set the values for URL redirect in case of invalid Login or username mismatch.
 * ---------------------------------------------------------------------------- */
BEGIN

  SELECT DEBUG_FLAG, INVALID_LOGIN_URL, USERNAME_MISMATCH_URL, INVALID_PARTNER_URL
  INTO gc_enable_debug, gc_invalid_login_url, gc_username_mismatch_url, gc_invalid_partner_url
  FROM xxoos_sso_info_defaults
  WHERE ID = 1001;  -- There is only 1 record for the default values, so we can hard code this record ID.


END xxoos_sso_partner_utils;
/
show errors

-- End of script xxoos_sso_partner_utils.pkb
