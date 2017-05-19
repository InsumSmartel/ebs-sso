<%@ page contentType="text/html;charset=UTF-8" %><%--
/* xxoos_sso_callapex.jsp */
--%><%@ page
import="java.io.*"
import="java.net.*"
import="java.sql.*"
import="javax.servlet.http.*"
import="java.util.Enumeration"
import="java.util.Properties"
import="java.lang.Math"
import="oracle.apps.fnd.common.VersionInfo"
import="oracle.apps.fnd.functionSecurity.Function"
import="oracle.apps.fnd.functionSecurity.RunFunction"
import="oracle.apps.fnd.common.WebAppsContext"
import="oracle.apps.fnd.common.AppsEnvironmentStore"
import="oracle.apps.fnd.common.WebRequestUtil"
import="oracle.apps.fnd.common.ResourceStore"
import="oracle.apps.fnd.security.CSS"
import="oracle.apps.fnd.common.Message"
import="oracle.jdbc.OracleConnection"
import="oracle.jdbc.OraclePreparedStatement"
import="oracle.jdbc.OracleResultSet" %><%
// Session has to be validated first
   WebAppsContext ctx = WebRequestUtil.validateContext(request, response);
     if (ctx==null) {
           return;  }
             String cookieName = ctx.getSessionCookieName();
             boolean validSession = ctx.validateSession(cookieName);
             WebRequestUtil.setClientEncoding(response, ctx);
%>
<html>
<head>
<title>Oracle Open Source - SSO for APEX</title>
<!-- xxoos_sso_callapex.jsp  -->
</head>
<body>
<%
// Parameters from the Function Definition
String p_partner_key = request.getParameter("partner_key");
p_partner_key = ( p_partner_key==null ? "NONE" : p_partner_key);

String p_target_page = request.getParameter("target_page");
p_target_page = ( p_target_page==null ? "1" : p_target_page);

String p_item_names = request.getParameter("item_names");
p_item_names = ( p_item_names==null ? "" : p_item_names);

String p_item_values = request.getParameter("item_values");
p_item_values = ( p_item_values==null ? "" : p_item_values);

// Get the known apps enviroment values
AppsEnvironmentStore l_env = (AppsEnvironmentStore) ctx.getEnvStore();

String l_user_name = "DUMMY";
String l_user_id   = l_env.getEnv("USER_ID");
String l_resp_id   = l_env.getEnv("RESP_ID");
String l_resp_appl_id   = l_env.getEnv("RESP_APPL_ID");
String l_session_id     = l_env.getEnv("ICX_SESSION_ID");
String l_partner_name   = ctx.getProfileStore().getProfile("APEX_SSO_PARTNER_NAME");
String l_url_designator = l_partner_name + "-" + p_partner_key;


// Prepare the call to the SSO function
String query_user = "SELECT USER_NAME FROM APPS.FND_USER WHERE USER_ID = :1";

String query = "SELECT xxoos_sso_partner_utils.APPS2APEX_GET_URL("
 + "  p_url_designator      => ? " // l_url_designator
 + ", p_partner_name        => ? " // l_partner_name
 + ", p_partner_key         => ? " // p_partner_key
 + ", p_user_id             => ? " // l_user_id
 + ", p_user_name           => ? " // l_user_name
 + ", p_target_page_id      => ? " // p_target_page
 + ", p_appl_id             => ? " // p_appl_id
 + ", p_responsibility_id   => ? " // l_resp_id
 + ", p_session_id          => ? " // l_session_id
 + ", p_item_list           => ? " // p_item_names
 + ", p_value_list          => ? " // p_item_values
 +") FROM DUAL";

%>

<%

Connection conn = ctx.getJDBCConnection();
try {
// Get USERNAME from USER_ID
  PreparedStatement stmt_user = conn.prepareStatement(query_user);
  stmt_user.setString(1, l_user_id);
  ResultSet rs_user = stmt_user.executeQuery();
  if (rs_user.next())
    l_user_name = rs_user.getString(1);
  rs_user.close();
  stmt_user.close();

// Get URL from SSO Partner details
  PreparedStatement stmt = conn.prepareStatement(query);
  stmt.setString(1, l_url_designator);
  stmt.setString(2, l_partner_name);
  stmt.setString(3, p_partner_key);
  stmt.setString(4, l_user_id);
  stmt.setString(5, l_user_name);
  stmt.setString(6, p_target_page);
  stmt.setString(7, l_resp_appl_id);
  stmt.setString(8, l_resp_id);
  stmt.setString(9, l_session_id);
  stmt.setString(10, p_item_names);
  stmt.setString(11, p_item_values);
  ResultSet rs = stmt.executeQuery();
  while (rs.next())
  {
    String l_launcher = rs.getString(1);

    rs.close();
    stmt.close();

    response.sendRedirect(l_launcher);
  }
}
catch(Exception e){
  out.println("Error occurred: " + e.getMessage());
  out.println("<pre>");
  out.println(query);
  e.printStackTrace(new java.io.PrintWriter(out));
  out.println("</pre>");
}

%>
</body>
</html>
