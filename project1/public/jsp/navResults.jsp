<%     
    System.out.println("inside Nav results");
   
    String qaCycle = session.getAttribute("qaCycle").toString();
    String recType = session.getAttribute("recType").toString();
    String manualStatus = "";
    if (session.getAttribute("manualStatus") != null) {
        manualStatus = (String)session.getAttribute("manualStatus").toString();   
    }
    
    System.out.println(qaCycle);
    System.out.println(recType);
    System.out.println(manualStatus);
    
%>
 
<div id="xyz_nav_result"  class="border2">
    <div>
        <ul class="nav nav-tabs">                     
             <li id="addrLi" class="active">
                <a href="#addressTab">Address Result</a>
             </li>
             <li id="rangeLi">
                <a href="#rangeTab">Range Result</a>
             </li>
        </ul> 
        <!--type="hidden" 
            Just testing, will be hidden later--> 
        <input style="display:none" id="selCodedTypeAndData" name="selCodedTypeAndData" value=""/>
        <input class="selectedResults" id="selResults" name="selResults" value=""/>
    </div>
</div> 

<div id="resultsArea">
    <div id="resultsOutput">
    </div>
    <div id="buttonArea">
        <div id="bottom_button rounded" class="bottom_button rounded" align="center">
            <div id="ui-button" class="ui-button" align="center" >
                
                <% if (qaCycle.equals("2")) { %>
                <input type="button" class="button recordButtons" value="Retrieve" id="Retrieve"></input>
                <input type="button" <% if (manualStatus.equals("true") || manualStatus.equals("P")) { %> 
                                            disabled="true" class="button recordButtons disableInputButton" <% 
                                        } else { %>
                                            class="button recordButtons" <% 
                                        } %> 
                        style="margin-right: 20px;" value="Phone Call" id="PhoneCallBtn"></input>
                <% } %>
                
                <% if (recType.equals("record")) { %>  
                    <% if (qaCycle.equals("0")) { %>
                        <input type="button" class="button recordButtons" style="margin-right: 20px;" value="Refer" id="Refer"></input>                
                    <% } %>
                    <input type="button" class="button recordButtons" value="Accept" id="Accept"></input>
                    <input type="button" class="button recordButtons" value="Uncodable" id="Uncodable"></input>
                
                <% } else if (recType.equals("verifier")) {%>
                    <input type="button" class="button recordButtons" value="Verify" id="VerifyBtn"></input>
                <% }%>
                
                <input type="button" class="button recordButtons" value="Return to Main Menu" id="Exit"></input>
            </div>
        </div>        
    </div>
    <div id='addressTab' class="tab-content active">
        
            <jsp:include page="/jsp/xyz_addressResults.jsp" />
        
    </div>
    
    <div id='rangeTab' class="tab-content hide">
        <div id="rangeResult1" class="tab-content active" >                    
            <jsp:include page="/jsp/xyz_rangeResults1.jsp" />                
        </div>
        <div id="rangeResult2" class="tab-content hide" >
            <jsp:include page="/jsp/xyz_rangeResults2.jsp" />
        </div>
    </div>
</div> 

<script language="javascript" type="text/javascript" src="${pageContext.request.contextPath}/js/xyz_navResults.js"></script>


    