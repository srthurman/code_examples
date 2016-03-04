<%@ page import="java.util.ArrayList"%>
<%@ page import="web.dbbean.RefListBean"%>

<%
 RefListBean rb =  new RefListBean();
 ArrayList getAddrResList = rb.getAmList();
 String message = "";
 int resultSize = 0;

    if (session.getAttribute("refBean") != null) {
        rb = (RefListBean)session.getAttribute("refBean");    
        getAddrResList = rb.getAmList();
    }
    if(!getAddrResList.isEmpty()){
        resultSize = getAddrResList.size();
    }
%> 
        <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/xyz_addressResults.css">     
        
        <div class="recordInfo">
        <%
             if ( rb.getAmList().size() <= 0 ) {
                message = "<span class=\"fldtext\" style=\"color: red; font-size: small;\"><b><i>"+ rb.getErrorMessageAm() +"</i></b></span>";   
                out.println(message);
             }else{
        %>
        <div id="AddressResults" class="AddressResults">

            <table id="DISP_AR_TAB" class="DISP_AR_TAB">
                <thead>
                    <tr>
                        <th style="min-width:100px; max-width:100px;">House Number</th>
                        <th style="min-width:100px; max-width:100px;">Unit No</th>
                        <th style="min-width:400px; max-width:400px;">Street Name</th>
                        <th style="min-width:100px; max-width:100px;">ZIP Code</th>
                        <th style="min-width:100px; max-width:100px;">MAF ID</th>
                        <th width="10px" style="display:none"></th>
                    </tr>
                </thead>
            </table>
            
            <table class="DISP_AR_TAB" id="tblAddrRes">
                <tbody class="scrollContent2">
                    <%
                        for(java.util.Iterator it = getAddrResList.iterator(); it.hasNext(); ) { 
                        RefListBean dispList = (RefListBean) it.next();
                    %>
                    <input type="hidden" id="selAddrRow" name="selAddrRow"> </input>
                    <tr id="AddrRow" class="AddrRow">
                        <td style="min-width:100px; max-width:100px;" class="addrlist"><%=dispList.getHn()%></td>
                        <td style="min-width:100px; max-width:100px;" class="addrlist"><%=dispList.getWsid()%></td>
                        <td style="min-width:400px; max-width:400px;" class="addrlist"><%=dispList.getDisplayName()%></td>
                        <td style="min-width:100px; max-width:100px;" class="addrlist"><%=dispList.getZip()%></td>
                        <td style="min-width:100px; max-width:100px;" class="addrlist"><%=dispList.getMafid()%></td>
                        <td style="width:0%;display:none;" class="addrlist"><%=dispList.getOidad()%></td>
                        <td style="width:0%;display:none;" class="addrlist"><%=dispList.getMatchmuoid()%></td>
                    </tr>

                    <% }%>            
                </tbody>
            </table>
            <p class="resultsReturn"><b><i><%=resultSize%> result(s) found.</i></b></p>            
        <%}%>
        </div>
        </div>
        
<script language="javascript" type="text/javascript" src="${pageContext.request.contextPath}/js/xyz_addressResults.js"></script>
