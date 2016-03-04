//Sara
<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="java.util.*, javax.servlet.*, javax.servlet.http.* "%>
<%@ page import="web.dbbean.RefListBean"%>

<%
 RefListBean rb =  new RefListBean();
 String message = "";

    if (session.getAttribute("refBean") != null) {
        rb = (RefListBean)session.getAttribute("refBean");    
    }
    
    String selStreet = rb.getSelStreet();
    String selIntStreet = rb.getSelIntStreet();
    String selZip = rb.getSelZip();

    //out.println("Street is : " + selStreet + " Int Street is: " + selIntStreet + " Zip is: " + selZip);
%> 
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
        <title>MaCS - Map</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/leaflet.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/xyz_map.css"/>        
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/xyz_header.css"/>
        <script language="javascript" type="text/javascript"
                src="${pageContext.request.contextPath}/js/jquery-2.1.4.min.js"></script>
        <script language="javascript" type="text/javascript"
                src="${pageContext.request.contextPath}/js/jquery-ui_1.11.2.js"></script>
    </head>
    <body>

        <span id="xyzScreen" style="display: none;">Map</span>

        <div id = "header">
            <a href="#" class="xyz-brand">MaCS</a>
            <div id="header_title">
                <div>Matching and</div>         
                <div>Coding Software</div>
            </div>        
        </div>
        
        
        <div id="mapContainer">
            <div id="map"></div>
            <div id="LOWER_DISPLAY">
                <div id="SEARCH_DISPLAY"></div>
                <div id="ADDRESS_TABLE" class="ADDRESS_TABLE"></div>
                <div id="BUTTON_DISPLAY">
                    <input class="button" id="importBlockIdBtn" type="button" value="Import Block ID"></input>
                </div>
            </div>

        </div>
        <script src="${pageContext.request.contextPath}/js/leaflet.js"></script>
        <script src="${pageContext.request.contextPath}/js/esri-leaflet.js"></script>
        <script src="${pageContext.request.contextPath}/js/xyz_map.js"></script>
        
        <script type="text/javascript">
        <% if (!selStreet.isEmpty() && !selIntStreet.isEmpty() && !selZip.isEmpty()) {
        %>
            xyzMap.streetIntSearch('<%=selStreet%>', '<%=selIntStreet%>', '<%=selZip%>');
        <%
           }
           else if (!selZip.isEmpty())
           {
        %>  
           xyzMap.streetZipSearch('<%=selStreet%>', '<%=selZip%>');
        <%
           }
        %>
        </script>

    </body>
</html>