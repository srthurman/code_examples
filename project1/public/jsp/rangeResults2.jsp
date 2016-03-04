<%@ page import="java.util.ArrayList"%>
<%@ page import="web.dbbean.RefListBean"%>

<%  
    System.out.println("inside rangeResults1");
    
    ArrayList arList = new ArrayList();;
    RefListBean refBean = new RefListBean();
    String message = "";
    int resultSize = 0;
    if (session.getAttribute("refBean") != null){
        refBean = (RefListBean)session.getAttribute("refBean");
        arList = refBean.getArList();
    }
    if(!arList.isEmpty()){
        resultSize = arList.size();
    }
%>     

    <div id="RangeArea2" class="RangeArea2">
        <div id="tableButtons">
            <div class="resultLayout">
                <input type="button" class="button"  id="returnResults" value="Return" onclick="RangeResults2.AddrRangeReturn();"></input> 
            </div>
        </div>
        <div id="tableLeftResults">
        <% 
            if(arList.size() <= 0){
                message = "<span class=\"fldtext\" style=\"color: red; font-size: small;\"><b><i>"+ refBean.getErrorMessageAr2() +"</i></b></span>"; 
                out.println(message);
            }else{
        %>
            <table class="RANGE_TB">
                <thead>
                  <tr>
                    <th style="min-width:400px; max-width:400px;">Street Name</th>
                    <th style="min-width:100px; max-width:100px;">ZIP Code</th>                
                  </tr>
                </thead>
            </table>
            <table class="RANGE_TB">
                <tbody>
                  <tr class="streetName">
                    <td style="min-width:400px; max-width:400px;"><%=refBean.getSelDisplayName()%></td>
                    <td style="min-width:100px; max-width:100px;"><%=refBean.getSelArZip()%></td>                
                  </tr>                  
                </tbody>
            </table>
             
        </div>
        <div id="tableRightResults">   
            <table id="tblResult2Header" class="RANGE_TB">
                <thead>
                  <tr>
                    <th style="min-width:50px; max-width:50px;">Parity</th>
                    <th style="min-width:100px; max-width:100px;">From</th>
                    <th style="min-width:100px; max-width:100px;">To</th>                
                  </tr>
                </thead>
            </table>
            <table id="tblResult2" class="RANGE_TB">                
                <tbody  class="scrollContent2">                  
                  <%                        
                    for(java.util.Iterator it = arList.iterator(); it.hasNext(); ) { 
                            RefListBean refObj = (RefListBean) it.next();                            
                  %>
                  <input type="hidden" name="selParity" id="selParity"/>
                  <input type="hidden" name="selFrom" id="selFrom"/>
                  <input type="hidden" name="selTo" id="selTo"/>                  
                  <input type="hidden" name="selOidar" id="selOidar"/>
                  <tr>
                    <td style="min-width:50px; max-width:50px;"><%=refObj.getParity()%></td>
                    <td style="min-width:100px; max-width:100px;"><%=refObj.getFromHn()%></td>     
                    <td style="min-width:100px; max-width:100px;"><%=refObj.getToHn()%></td> 
                    <td style="display:none;"><%=refObj.getOidar()%></td> 
                  </tr>
                  <%}%>                  
                </tbody>
              </table>
              <p class="resultsReturn"><b><i><%=resultSize%> result(s) found.</i></b></p>  
        </div>
        <%};%>
    </div>
    
    <script language="javascript" type="text/javascript" src="${pageContext.request.contextPath}/js/xyz_rangeResults2.js"></script>
     