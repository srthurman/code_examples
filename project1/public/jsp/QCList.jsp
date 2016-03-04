<!DOCTYPE HTML>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.lang.Integer"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="web.dbbean.RecordBean"%>
<%@ page import="java.util.*, javax.servlet.*, javax.servlet.http.* "%>
<jsp:include flush="true" page="/jsp/xyz_header.jsp" />

<% 
 Iterator itr;
 String message = "";
 int totComplete = 0;
 int resultSize = 0;
 int initialNumToDisplay = 50;
 
 RecordBean queBean = new RecordBean();
 if (session.getAttribute("queBean") != null){
    queBean = (RecordBean)session.getAttribute("queBean");             
 } 
 
 
 RecordBean qcBean = new RecordBean();
 if (session.getAttribute("qcBean") != null){
    qcBean = (RecordBean)session.getAttribute("qcBean");  
    totComplete = qcBean.getTotPassed()+qcBean.geTotFailed();
 } 
 
 ArrayList<RecordBean> qcList = new ArrayList<RecordBean>();
  if (session.getAttribute("qcList") != null){
    qcList = (ArrayList)session.getAttribute("qcList");             
 } 
    

%> 
<html lang="en">
<head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
        <title>MaCS - QC List</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.default.css"></link>
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.tablesorter.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/widget-scroller.js"></script>   
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.tablesorter.widgets.min.js"></script>
        <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/xyz_qcList.css"></link>       
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/xyz_qcList.js"></script>   
</head>  
<body class="viewUsers">    
        <form name="QCListForm" id="QCListForm" action="" method="post">

            <div id="topView">
                <div  id="userListSection">
                    <h1> QC List </h1>
                    <div id="QCstats" style="padding-bottom:10px">
                      <fieldset>
                        <legend>QC Bundle Information</legend>
                                <dl>
                                    <dt>
                                        <label for="totalRec">Total Records</label>
                                    </dt>
                                    <dd>
                                        <textarea class="" rows="1" cols="4" id="totalRec"
                                                  name="totalRec" readonly="readonly"><%=qcBean.geTotRec()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="totComplete">Total Completed</label>
                                    </dt>
                                    <dd>
                                        <textarea class="" rows="1" cols="4" id="totComplete" 
                                                  name="totComplete" readonly="readonly"><%=totComplete%></textarea>
                                    </dd
                                    <dt>
                                        <label for="passRec">Pass Records</label>
                                    </dt>
                                    <dd>
                                        <textarea class="" rows="1" cols="4" id="passRec" 
                                                  name="passRec" readonly="readonly"><%=qcBean.geTotPassed()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="failRec">Fail Records</label>
                                    </dt>
                                    <dd>
                                        <textarea class="" rows="1" cols="4" id="failRec" 
                                                  name="failRec" readonly="readonly"><%=qcBean.geTotFailed()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="remainingRec">Remaining Records</label>
                                    </dt>
                                    <dd>
                                        <textarea class="" rows="1" cols="4" id="remainingRec"
                                                  name="remainingRec" readonly="readonly"><%=qcBean.geTotRemainder()%></textarea>
                                    </dd>
                                </dl>
                       </fieldset>         
                    </div>
                    <div id="QCList">                
                    
                        <input type="hidden" id="selQCRow" name="selQCRow"> </input>
                        
                        <table id="QCListTable" class="tablesorter">
                            <thead>
                                <tr>
                                    <th style="min-width:250px; max-width:200px;">Cust-Id</th>
                                    <th style="min-width:120px; max-width:120px;">House Number</th>
                                    <th style="min-width:250px; max-width:200px;">Street Name</th>
                                    <th style="min-width:120px; max-width:120px;">Unit No</th>
                                    <th style="min-width:45px; max-width:45px;">Timezone</th>
                                    <th style="min-width:45px; max-width:45px;">State</th>
                                    <th style="min-width:45px; max-width:50px;">Zip</th>
                                </tr>
                            </thead>
                
                            <tbody id="tblQCListBody">
                                <%
                                    if (qcList.size() >= 0) {
                                        for (int i = 0; i<qcList.size();i++) {}}
                                        
                                %>
                                <%
                                if ( qcList.size() != 0 )
                                  {
                                    for(java.util.Iterator it = qcList.iterator(); it.hasNext(); ) 
                                      {   
                                      RecordBean qcListBean = (RecordBean) it.next();
                                %>
                                <tr id="RecordRow" class="RecordRow">
                                    <td style="min-width:250px; max-width:250px;"><%=qcListBean.getCustid()%></td>
                                    <td style="min-width:120px; max-width:120px;"><%=qcListBean.getInAddrNumber()%></td>
                                    <td style="min-width:250px; max-width:250px;"><%=qcListBean.getInStreetName()%></td>
                                    <td style="min-width:120px; max-width:120px;"><%=qcListBean.getInUnitInfo()%></td>
                                    <td style="min-width:45px; max-width:45px;"><%=qcListBean.getTimeZone()%></td>
                                    <td style="min-width:45px; max-width:45px;"><%=qcListBean.getInState()%></td>
                                    <td style="min-width:45px; max-width:50px;"><%=qcListBean.getInZip()%></td>
                                </tr>
                                <%
                                        }
                                    }        
                                %>            
                            </tbody>
                        </table>
                    </div>
                    <p class="resultsReturn"><b><i><%=qcList.size()%> result(s) found.</i></b></p>                   
            </div>

        <input type="hidden" id="queueCustId" name="queueCustId" value=<%=queBean.getCustid()%> />
        <input type="hidden" id="queueBundleId" name="queueBundleId" value=<%=queBean.getBundleId()%> />
        <input type="hidden" id="queueQACycle" name="queueQACycle" value=<%=queBean.getQaCycle()%> />
                    
        <div id="buttonArea">
            <div id="bottom_button rounded" class="bottom_button rounded" align="center">
                <div id="ui-button" class="ui-button" align="center" >     
                    <input type="button" class="button recordButtons" value="Select" id="Select" onclick="QCList.Select();"></input>
                </div>
            </div>        
     
           </div>
               
            </div>
        </form>   
             
        
     
</body>
</html>
