<!DOCTYPE html>
<!-- Contributors: Bao Ho -->
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="web.dbbean.UserBean"%>

<%
  String message = "";
  UserBean userBean = new UserBean();
  
  if (request.getAttribute("errorMessage") != null) {
     message = request.getAttribute("errorMessage").toString();   
  }
  
  if (session.getAttribute("userBean") != null){
        userBean = (UserBean)session.getAttribute("userBean");             
  } 
  
  String getNewRecord      = "ControlServlet?action=getNewRecord&qaCycle=0";
  String getOnHoldRecords  = "ControlServlet?action=getOnHoldRecords";
  String getRefRecords     = "ControlServlet?action=getNewRecord&qaCycle=1";
  String getQCRecords      = "ControlServlet?action=getNewRecord&qaCycle=2";
  String getVerRecords      = "VerificationServlet?action=getNewRecord&qaCycle=0";
  String getWorkAssign     = "ControlServlet?action=getWorkAssign";
  String getReports        = "ControlServlet?action=getReports";
  String getUserAccounts   = "ControlServlet?action=getUserAccounts";
  String getRequestAccess  = "ControlServlet?action=getRequestAccess";
  String getOid            = "ControlServlet?action=getOid";
  String getMAF         = "ControlServlet?action=getMAF";


  
%>


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"></meta>
        <title>MaCS</title>
        <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/xyz_menu.css">        
        <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/xyz_navigation.css">
        <script language="javascript" type="text/javascript" src="${pageContext.request.contextPath}/js/xyz_menu.js"></script>
    </head>
    
     <body onload="Menu.getMessage('<%=message%>');" > 
       <jsp:include flush="true" page="xyz_header.jsp" />
       <span id="xyzScreen" style="display: none;">Menu</span>
        <form name="menu" method="post" action="" >    
            <!-- Navigation Bar -->
            <nav id="xyz_nav_wrap">
                <ul>
                  <li><a href="#">Record Review</a>
                    <ul>
                      <li><a href='<%=getNewRecord%>'>Record</a></li>
                      <li><a href='<%=getOnHoldRecords%>'>On Hold</a></li>
                    </ul>
                  </li>
                  <li><a href="#">Referral/QC</a>
                    <ul>
                      <li><a href='<%=getRefRecords%>'>Referral</a></li>
                      <li><a href='<%=getQCRecords%>'>QC</a></li>
                    </ul>
                  </li>
                  <li><a href="#">Supervisor</a>
                    <ul>
                      <li><a href='<%=getWorkAssign%>'>Work Assignment</a></li>
                      <li><a href='<%=getReports%>'>Reports</a></li>
                    </ul>
                  </li>
                  
                  <li><a href="#">Administrator</a>
                    <ul>                       
                        <li><a href='<%=getUserAccounts%>'>User Accounts</a></li>                      
                        <li><a href='<%=getRequestAccess%>'>Request Access</a></li> 
                        <%if (userBean.getUserType().equals("4")){ %>
                            <li><a href='${pageContext.request.pathInfo}/groupadmin/' target="_blank">OID Admin</a></li>
                        <%}else{%>
                            <li><a href='<%=getOid%>'>OID Admin</a></li>
                        <%}%>
                        
                    </ul>
                  </li>  
                  
                  <li><a href="#">Verifier</a>
                    <ul>                       
                        <li><a href='<%=getVerRecords%>'>Record</a></li>                      
                    </ul>
                  </li>
                  <li style="float:right;"><a href="#">v<c:out value='${initParam["macs_version"]}'/></a>
                  </li> 
                </ul>
            </nav>             
        </form>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                F
    </body>
</html>