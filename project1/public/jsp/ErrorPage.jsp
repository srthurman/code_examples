<!DOCTYPE html>
<%@ page isErrorPage="true" %>
<%@ page contentType="text/html;charset=windows-1252"%>
<%
if (session != null) {
    session.invalidate();
} else {
    System.out.println("Session Not Found");
}  
%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
    <title>MaCs - Error</title>


<script type="text/javascript">
    var pagename = window.location.pathname.split("/").pop();
    
    history.pushState(null, null, pagename);
    window.addEventListener('popstate', function(event) {
        history.pushState(null, null, pagename);
    });
</script>
<!--<script language="JavaScript" type="text/javascript" >
   javascript:window.history.forward(1);
    javascript:window.history.backward(1);
</script>-->

</head>

<body>
  <form name="form1" method="get" action="/xyz">
  <table bgcolor="#FFFFFF" >
    <tr> 
    <td width="800" height="300" valign="top"> 
        <br>
        <p align="center" ><b><font size="+3"><span class="warningTtl">Error !!!</span></font></b></p><br>
        <div id="validationMessage" align="left" ></div><font size="+2" color="red" ><b>${errorMessage}</b></font>

<% 
  if(request.getParameter("errorMessage")==null) 
  {
    out.println("<h2 align=\"center\">User Logged Out</h2>");
    out.println("<h3 align=\"center\"><font color=red>" + "Please close browser and login again." + "</font></h3>");
  }
  else
  {
    out.println("<h2 align=\"center\"><font color=red>" + request.getParameter("errorMessage") + "</font></h2>"); 
    out.println("<h3 align=\"center\"><font color=red>" + "Please close browser and login again." + "</font></h3>");
  }
%>
        <p align="left" class="warningData"><br><br>
            Please contact xyz System Administrator 
            (<u style="color:Blue;">email@email.gov</u>) for any issues. </b>
        </p>
    </td> 
    </tr>
  </table>
  </form>
  </body>
</html>