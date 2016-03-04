<%@ page import="java.util.ArrayList"%>
<%@ page import="web.dbbean.RefListBean"%>

<%     
     System.out.println("inside rangeResults1");
     
     ArrayList arNameList = new ArrayList();
     RefListBean refBean = new RefListBean();
     String message = "";
     String selRowString= "";
     int selRow = 0;
     int resultSize=0;
     
     if (session.getAttribute("refBean") != null){
        refBean = (RefListBean)session.getAttribute("refBean");
        arNameList = refBean.getArNameList();
     }
    if (session.getAttribute("selRow") != null){
        selRow = Integer.parseInt((String)session.getAttribute("selRow"));        
    }
    if(!arNameList.isEmpty()){
        resultSize = arNameList.size();
    }
%>        
    <div id="RangeArea1" class="RangeArea1">
        <div id="tableLeftResults">
        <% 
            if(arNameList.size() <= 0){
                message = "<span class=\"fldtext\" style=\"color: red; font-size:14px;\"><b><i>"+ refBean.getErrorMessageAr1() +"</i></b></span>"; 
                out.println(message);
            }else{
        %>
            <table id="tblResult1Header" class="RANGE_TB">
                <thead>
                  <tr>
                    <th style="min-width:400px; max-width:400px;">Street Name</th>
                    <th style="min-width:100px; max-width:100px;">ZIP Code</th>                
                  </tr>
                </thead>
            </table>            
                  <input type="hidden" name="selRow" id="selRow" value=<%=selRow%>></input>
            <table id="tblResult1" class="RANGE_TB">                
                <tbody class="scrollContent2">             
                  <%
                    int rowCount=0;
                    for(java.util.Iterator it = arNameList.iterator(); it.hasNext(); ) { 
                            RefListBean refObj = (RefListBean) it.next();
                  %>
                  <input type="hidden" name="selDisplayName" id="selDisplayName"></input>
                  <input type="hidden" name="selArZip" id="selArZip"></input>
                  <tr  id="selectedRangeRow">
                    <td style="min-width:400px; max-width:400px;"><%=refObj.getDisplayName()%></td>
                    <td style="min-width:100px; max-width:100px;"><%=refObj.getZip()%></td>      
                    <td style="display:none"><%=rowCount%></td>  
                  </tr>
                  <%
                    rowCount++;
                    }%>                 
                </tbody>
              </table>
              <p class="resultsReturn"><b><i><%=resultSize%> result(s) found.</i></b></p>       
        </div>
        <div id="tableButtons">
            <div class="resultLayout">                
                <input type="hidden" id="selParity" name="selParity"></input>
                <input type="radio" id="oddValues" name="Parity" value="O" >Odd<br></input>
                <input type="radio" id="evenValues" name="Parity" value="E">Even<br></input>                
                <input type="button" class="button" id="displayRange" name="displayRange" value="Display Range"></input>
            </div>
        </div>
        <%};%>
    </div>

    <script language="javascript" type="text/javascript" src="${pageContext.request.contextPath}/js/xyz_rangeResults1.js"></script>
