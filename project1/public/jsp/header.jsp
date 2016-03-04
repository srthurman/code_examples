<!-- Contributors: Bao Ho -->
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="web.dbbean.UserBean"%>
<%
    //String logout = "ControlServlet?action=logout";
    String userName = "NEW USER";

    UserBean userbean = new UserBean();
    if (session.getAttribute("userBean") != null){
        userbean = (UserBean)session.getAttribute("userBean");             
        userName = userbean.getUsername().toUpperCase();
    } else if (session.getAttribute("newUserBean") != null){
        userbean = (UserBean)session.getAttribute("newUserBean");
        userName = userbean.getUsername().toUpperCase();
    }

%>
    <script language="javascript" type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-2.1.4.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-ui_1.11.2.js"></script>
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui_1.11.2.css"></link>
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/xyz_header.css">
    <script language="javascript" type="text/javascript" src="${pageContext.request.contextPath}/js/xyz_header.js"></script>
    

    <!-- Header -->
    <div id = "header">
        <a href="#" class="xyz-brand" style="width:120px">
            <span id="applogo">MaCS</span>           
        </a>
        <div id="header_title">
            <input class="right" id="userId" name="userId" type="hidden" value="<%=userbean.getUsername()%>"/>  
            <input class="right" id="userType" name="userType" type="hidden" value="<%=userbean.getUserType()%>"/> 
            <div class="right">Welcome, <i><%=userName%></i>.</div>
            <div><span id="line_one">Matching and</span></div>          
            <a class="rightSideHeader" href='javascript:xyzHeader.logout()'><b><i>Log Out</i></b></a></li>
            <div><span id="line_two">Coding Software</span></div>
        </div>        
    </div>
    
    <jsp:include flush="true" page="IdleTimer.jsp" />