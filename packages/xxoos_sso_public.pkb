create or replace PACKAGE body ^APPS_SCH..xxoos_sso_public AS
/*
-------------------------------------------------------------------------------
Name .................. xxoos_sso_public.pkb
Purpose ............... SQL Script to create package body xxoos_sso_public for the
                        Oracle Open Source - Single Sign On for APEX
Environment ........... Oracle 11gR1 and above
Parameters ............
Arguments:
  None
Called by  ............ xxoos_sso_packages.sql
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

gc_colon      constant  varchar2(1) := ':';
gc_comma      constant  varchar2(1) := ',';
gc_N          constant  varchar2(1) := 'N';
gc_Y          constant  varchar2(1) := 'Y';


/* ----------------------------------------------------------------------------
 * Name            : log_msg
 * Author          : C2 Consulting, Inc.
 * Date            : 14-JUN-2009
 * Description     :
 * ---------------------------------------------------------------------------- */
procedure log_msg( p_msg in varchar2 ) is pragma AUTONOMOUS_TRANSACTION;

begin
  if gc_enable_debug = 'Y' then
    insert into xxoos_sso_log (log_time, message)
    values (sysdate, p_msg);
    commit;
  end if;

end log_msg;


/* ----------------------------------------------------------------------------
 * Name            : mark_switch_rec_used
 * Author          : C2 Consulting, Inc.
 * Date            : 14-JUN-2009
 * Description     :
 * ---------------------------------------------------------------------------- */
procedure mark_switch_rec_used( p_id      in number
                              , p_session in number )  is
  pragma AUTONOMOUS_TRANSACTION;

begin
  update xxoos_sso_apps
    set apex_session = p_session
      , login_used = gc_Y
    where id = p_id;
  commit;

end mark_switch_rec_used;


/* ----------------------------------------------------------------------------
 * Name            : set_session_state_private
 * Author          : C2 Consulting, Inc.
 * Date            : 14-JUN-2009
 * Description     :
 * ---------------------------------------------------------------------------- */
procedure set_session_state_private( p_item_list  in varchar2
                                   , p_value_list in varchar2 ) is

l_item_array          APEX_APPLICATION_GLOBAL.VC_ARR2;
l_value_array         APEX_APPLICATION_GLOBAL.VC_ARR2;
l_pos_no              number;

begin
  if p_item_list is not null then
    -- loop through and set session state
    l_item_array := APEX_UTIL.STRING_TO_TABLE(p_item_list, ',');
    l_value_array := APEX_UTIL.STRING_TO_TABLE(p_value_list, ',');

    for l_pos_no IN 1..l_item_array.count loop
      APEX_UTIL.SET_SESSION_STATE (
        p_name     => l_item_array(l_pos_no),
        p_value    => l_value_array(l_pos_no) );
    end loop;
  end if;

end set_session_state_private;


/* ----------------------------------------------------------------------------
 * Name            : get_url
 * Author          : C2 Consulting, Inc.
 * Date            : 14-JUN-2009
 * Description     :
 * ---------------------------------------------------------------------------- */
function get_url( p_id  in number
                , p_key in varchar2 ) return varchar2 is

e_invalid_logon       exception;
e_username_mismatch   exception;
l_current_proc        varchar2(240);
l_switch_rec          xxoos_sso_apps%rowtype;
l_info_rec            xxoos_sso_info%rowtype;

l_url                 varchar2(10000);
l_sso_session         number;
l_session             number;
l_current_user        varchar2(4000);

begin
  l_current_proc := 'geturl: ';
  log_msg(l_current_proc||'* Starting '||l_current_proc||' *');

  l_sso_session := v('APEX_SESSION');
  log_msg(l_current_proc||'l_sso_session = <'||l_sso_session||'>');

  -- get the switch record
  select s.*
    into l_switch_rec
    from xxoos_sso_apps s
    where s.id = p_id
      and s.switch_guid = p_key
      and s.login_used = gc_N;

  -- get the switch_info
  select si.*
    into l_info_rec
    from xxoos_sso_info si
    where si.id = l_switch_rec.info_id;

  -- check to see if logged in within time allowed
  if l_switch_rec.switch_date + (l_info_rec.apex_switch_seconds / 86400) <= sysdate then
    log_msg(l_current_proc||'*** ERROR - Switch did not occurred within time allowed of <'||l_info_rec.apex_switch_seconds||'> seconds.');
    raise e_invalid_logon;
  end if;

  -- check if there is a valid APEX session for this user already
  -- need to set the application id
  log_msg(l_current_proc||'set app_id = <'||l_info_rec.apex_app_id||'>' );
  APEX_APPLICATION.g_flow_id := l_info_rec.apex_app_id;
  log_msg(l_current_proc||'APEX_APPLICATION.g_flow_id = <'||APEX_APPLICATION.g_flow_id||'>');


  -- Sylvain Martel - 2016-09-15
  -- ==========================================================================================================================================
  -- When an unexpected error occurs in APEX, the SSO reuses an APEX session ID of the moment the error got created.
  -- Which prevents from reading new values (User ID, Resp ID, Resp Appl ID) and wrongly re evaluate the Authorizations.
  -- Setting a new APEX session everytime APEX is called solves the issue.
  -- Regardless of this situation, we allow developers to set this application to reuse previous session state by reading the APEX New Session
  -- flag from the partnership entry in the SSO application.
  if NVL(l_info_rec.apex_new_session,'N') = 'Y' then
    l_session := NULL;
    log_msg(l_current_proc||'Set a new session based on l_info_rec.apex_new_session = <'||l_info_rec.apex_new_session||'>');
  else
    l_session := APEX_CUSTOM_AUTH.GET_SESSION_ID_FROM_COOKIE;
    log_msg(l_current_proc||'l_session = <'||l_session||'>');
  end if;
  -- ==========================================================================================================================================

  -- if the user has a session
  if l_session is not null then

    log_msg(l_current_proc||'l_session is not null = <'||l_session||'>');

    APEX_CUSTOM_AUTH.SET_SESSION_ID(p_session_id => l_session);

    l_current_user :=  APEX_CUSTOM_AUTH.GET_USERNAME;
    log_msg(l_current_proc||'app_user = <' || l_current_user ||'>');

    if l_current_user not in ('nobody','APEX_PUBLIC_USER') then
      if l_switch_rec.user_name != l_current_user then
        log_msg(l_current_proc||'*** ERROR - Username mismatch <'||l_switch_rec.user_name||'> / <'||l_current_user||'>');
        raise e_username_mismatch;
      end if;
    end if;

    -- check to see if it is really a valid session
    if l_current_user in ('nobody','APEX_PUBLIC_USER') then
      log_msg(l_current_proc||'l_current_user = <'||l_current_user||'> so l_session is assigned the value NULL.');
      l_session := null;
    end if;
  end if;

  -- l_session is still not null then there is a valid user session
  if l_session is not null then

    -- if we don't need to pass session state, just redirect to the requested page
    if l_switch_rec.item_list is null then
      l_url := l_info_rec.apex_url || 'f?p=' || l_info_rec.apex_app_id || gc_colon || nvl(l_switch_rec.target_page_id, l_info_rec.default_page_id)
             || gc_colon || l_session ;

    else -- redirect to the public page to set session state

      l_url := l_info_rec.apex_url || 'f?p=' || l_info_rec.apex_app_id || gc_colon || l_info_rec.public_page_id
             || gc_colon || l_session || gc_colon || 'C2SSS' || gc_colon || gc_colon || gc_colon
             || 'F_C2SSO_ID,F_C2SSO_KEY' || gc_colon || p_id || gc_comma || p_key;
    end if;
  else  -- the user does not have a session

    -- redirect to the public page
    log_msg(l_current_proc||'l_session is null');

    l_url := l_info_rec.apex_url || 'f?p=' || l_info_rec.apex_app_id || gc_colon || l_info_rec.public_page_id || gc_colon || gc_colon
            || 'C2AL' || gc_colon || gc_colon || gc_colon || 'F_C2SSO_ID,F_C2SSO_KEY' || gc_colon || p_id || gc_comma || p_key;
  end if;

  -- set the sso id back to the SSO app_id
  APEX_CUSTOM_AUTH.SET_SESSION_ID(p_session_id    => l_sso_session);

  -- set the application id back to the SSO app_id
  APEX_APPLICATION.g_flow_id := l_info_rec.workspace_sso_app_id;

  log_msg(l_current_proc||'return l_url = <'||l_url||'>');
  return l_url;

  log_msg(l_current_proc||'* Done with '||l_current_proc||' *');


exception
  when no_data_found then
    log_msg(l_current_proc||'*** EXCEPTION no_data_found');
    return gc_invalid_login_url;

  when e_invalid_logon then
    log_msg(l_current_proc||'*** EXCEPTION e_invalid_logon');
    return gc_invalid_login_url;

  when e_username_mismatch then
    log_msg(l_current_proc||'*** EXCEPTION e_username_mismatch');
    return gc_username_mismatch_url;
end get_url;


/* ----------------------------------------------------------------------------
 * Name            : set_session_state_redirect
 * Author          : C2 Consulting, Inc.
 * Date            : 14-JUN-2009
 * Description     :
 * ---------------------------------------------------------------------------- */
procedure set_session_state_redirect( p_id  in number
                                    , p_key in varchar2 ) is

e_invalid_logon       exception;
l_currect_proc        varchar2(240);
l_switch_rec          xxoos_sso_apps%rowtype;
l_info_rec            xxoos_sso_info%rowtype;

begin

  l_current_proc := 'set_session_state_redirect: ';
  log_msg(l_current_proc||'* Starting '||l_current_proc||' *');

  -- get the switch record
  select s.*
    into l_switch_rec
    from xxoos_sso_apps s
    where s.id = p_id
      and s.switch_guid = p_key
      and s.login_used = gc_N;

  -- get the switch_info
  select si.*
    into l_info_rec
    from xxoos_sso_info si
    where si.id = l_switch_rec.info_id;

  -- check to see if logged in within time allowed
  if l_switch_rec.switch_date + (l_info_rec.apex_switch_seconds / 86400) <= sysdate then
    log_msg(l_current_proc||'*** ERROR - Switch did not occurred within time allowed of <'||l_info_rec.apex_switch_seconds||'> seconds.');
    raise e_invalid_logon;
  end if;


  -- Added by Sylvain Martel
  log_msg(l_current_proc||'Exceuting apex_authorization.reset_cache');
  apex_authorization.reset_cache;

  set_session_state_private(p_item_list  => l_switch_rec.item_list
                          , p_value_list => l_switch_rec.value_list );

  APEX_UTIL.SET_SESSION_STATE (
        p_name     => 'F_C2SSO_ID',
        p_value    => null );

  APEX_UTIL.SET_SESSION_STATE (
        p_name     => 'F_C2SSO_KEY',
        p_value    => null );

  -- mark the record as used
  mark_switch_rec_used( p_id => l_switch_rec.id
                      , p_session => v('APP_SESSION'));

  -- redirect to target page
  owa_util.redirect_url('f?p=' || l_info_rec.apex_app_id ||gc_colon || nvl(l_switch_rec.target_page_id, l_info_rec.default_page_id)
        ||gc_colon || v('APP_SESSION'), true);
  apex_application.stop_apex_engine;

  log_msg(l_current_proc||'* Done with '||l_current_proc||' *');


exception
  when no_data_found then
    log_msg(l_current_proc||'*** EXCEPTION no_data_found');
    owa_util.redirect_url(gc_invalid_login_url, true);
    apex_application.stop_apex_engine;

  when e_invalid_logon then
    log_msg(l_current_proc||'*** EXCEPTION e_invalid_logon');
    owa_util.redirect_url(gc_invalid_login_url, true);
    apex_application.stop_apex_engine;
end set_session_state_redirect;


/* ----------------------------------------------------------------------------
 * Name            : do_auto_login
 * Author          : C2 Consulting, Inc.
 * Date            : 14-JUN-2009
 * Description     :
 * ---------------------------------------------------------------------------- */
procedure do_auto_login( p_id in number
                       , p_key in varchar2 ) is

e_invalid_logon       exception;
l_current_proc        varchar2(240);
l_switch_rec          xxoos_sso_apps%rowtype;
l_info_rec            xxoos_sso_info%rowtype;

begin

  l_current_proc := 'do_auto_login: ';
  log_msg(l_current_proc||'* Starting '||l_current_proc||' *');

  -- get the switch record
  select s.*
    into l_switch_rec
    from xxoos_sso_apps s
    where s.id = p_id
      and s.switch_guid = p_key
      and s.login_used = gc_N;

  -- get the switch_info
  select si.*
    into l_info_rec
    from xxoos_sso_info si
    where si.id = l_switch_rec.info_id;

  -- check to see if logged in within time allowed
  if l_switch_rec.switch_date + (l_info_rec.apex_switch_seconds / 86400) <= sysdate then
    log_msg(l_current_proc||'*** ERROR - Switch did not occurred within time allowed of <'||l_info_rec.apex_switch_seconds||'> seconds.');
    raise e_invalid_logon;
  end if;

  APEX_UTIL.RESET_AUTHORIZATIONS;

  set_session_state_private(p_item_list  => l_switch_rec.item_list
                          , p_value_list => l_switch_rec.value_list );

  APEX_UTIL.SET_SESSION_STATE (
        p_name     => 'F_C2SSO_ID',
        p_value    => null );

  APEX_UTIL.SET_SESSION_STATE (
        p_name     => 'F_C2SSO_KEY',
        p_value    => null );

  -- set Oracle EBS requirements if appropriate
  if l_switch_rec.apps_appl_id is not null then
    APEX_UTIL.SET_SESSION_STATE (
          p_name     => 'F_APPL_ID',
          p_value    => l_switch_rec.apps_appl_id );
  end if;

  if l_switch_rec.apps_user_id is not null then
    APEX_UTIL.SET_SESSION_STATE (
          p_name     => 'F_USER_ID',
          p_value    => l_switch_rec.apps_user_id );
  end if;

  if l_switch_rec.apps_responsibility_id is not null then
    APEX_UTIL.SET_SESSION_STATE (
          p_name     => 'F_RESP_ID',
          p_value    => l_switch_rec.apps_responsibility_id );
  end if;


  -- mark the record as used
  mark_switch_rec_used( p_id => l_switch_rec.id
                      , p_session => v('APP_SESSION'));

  log_msg(l_current_proc||'Executing apex_custom_auth.post_login');

  apex_custom_auth.post_login(
    P_UNAME       => l_switch_rec.user_name,
    P_SESSION_ID  => V('APP_SESSION'),
    P_APP_PAGE => l_info_rec.apex_app_id ||gc_colon || nvl(l_switch_rec.target_page_id, l_info_rec.default_page_id),
    p_preserve_case => FALSE
  );

  log_msg(l_current_proc||'* Done with '||l_current_proc||' *');


exception
  when no_data_found then
    log_msg(l_current_proc||'*** EXCEPTION no_data_found');
    owa_util.redirect_url(gc_invalid_login_url, true);
    apex_application.stop_apex_engine;

  when e_invalid_logon then
    log_msg(l_current_proc||'*** EXCEPTION e_invalid_logon');
    owa_util.redirect_url(gc_invalid_login_url, true);
    apex_application.stop_apex_engine;
end do_auto_login;



/* ----------------------------------------------------------------------------
 * Name            : -
 * Author          : Sylvain Martel
 * Date            : 05-FEB-2016
 * Description     : Set the values for URL redirect in case of invalid Login or username mismatch.
 * ---------------------------------------------------------------------------- */
BEGIN

  SELECT DEBUG_FLAG, INVALID_LOGIN_URL, USERNAME_MISMATCH_URL
  INTO gc_enable_debug, gc_invalid_login_url, gc_username_mismatch_url
  FROM xxoos_sso_info_defaults
  WHERE ID = 1001;  -- There is only 1 record for the default values, so we can hard code this record ID.


end xxoos_sso_public;
/
show errors
-- End of script xxoos_sso_public.pkb
