//Sara
<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="web.dbbean.RecordBean"%>
<%@ page import="web.dbbean.VerificationBean"%>
<%@ page import="web.dbbean.RefListBean"%>
<%@ page import="web.dbbean.compAddrBean"%>
<%@ page import="java.util.ArrayList"%>
<jsp:include flush="true" page="xyz_header.jsp"/>
<%
    String recType = session.getAttribute("recType").toString();
    RecordBean recBean = null;
    RecordBean queBean = null;
    System.out.println("Record JSP");
    
    
    if (recType.equals("record")) {
        recBean = new RecordBean();
        if (session.getAttribute("RecBean") != null){
            recBean = (RecordBean)session.getAttribute("RecBean");             
        }    
    
        queBean = new RecordBean();
        if (session.getAttribute("queBean") != null){
            queBean = (RecordBean)session.getAttribute("queBean");             
        }
        
    } else {
        recBean = new VerificationBean();
        if (session.getAttribute("verAddrBean") != null){
            recBean = (VerificationBean)session.getAttribute("verAddrBean");             
        }    
    
        queBean = new VerificationBean();
        if (session.getAttribute("verQueBean") != null){
            queBean = (VerificationBean)session.getAttribute("verQueBean");             
        }
    }
    
    session.setAttribute("qaCycle", queBean.getQaCycle());
    
    String message = "";
    if (request.getAttribute("errorMessage") != null) {
        message = request.getAttribute("errorMessage").toString();   
    }
    
    ArrayList<RefListBean> phonecallTypes = new ArrayList<RefListBean>();
    if (session.getAttribute("phonecallTypes") != null) {           
        phonecallTypes = (ArrayList<RefListBean>)session.getAttribute("phonecallTypes");
    }
    String phoneCallType = recBean.getManualPhoneCall();
    
    String manualStatus = "";
    if (session.getAttribute("manualStatus") != null) {
        manualStatus = (String)session.getAttribute("manualStatus").toString();   
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
        <title>MaCS - Record</title>
        <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/xyz_record.css"></link>
        <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/xyz_navResults.css"></link>
        <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/xyz_rangeResults.css"></link>
    </head>
    <body class="recordInfo">
        <div id="container rounded">
            <span id="xyzScreen" style="display: none;">Record</span>
             
            <form name="recordForm" id="recordForm" action="" method="post">
            <input id="qaCycle" name="qaCycle" type="hidden"
                                           value="<%=queBean.getQaCycle()%>"/>

                <div id="inputGroup">
                    <!--div id="RecId">Record ID: <%=recBean.getCustid()%> &nbsp;&nbsp; Bundle ID: <%=queBean.getBundleId()%></div-->
                    <!--         RESPONSE ADDRESS FIELDS        -->
                    <div id="responseAddress" class="layout">
                        <h1 class="resAddr">
                            Response Address (
                            <i>
                                <%=recBean.getCustid()%></i>
                            )
                        </h1>
                        <div class="sectionStyle">
                            <fieldset>
                                <legend>Original Response</legend>
                                <dl>
                                    <dt>
                                        <label for="houseNumber">House Number</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="houseNumber"
                                                  name="houseNumber" readonly="readonly"><%=recBean.getInAddrNumber()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="streetName">Street Name</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="streetName"
                                                  name="streetName" readonly="readonly"><%=recBean.getInStreetName()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="unitNo">Unit No</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="unitNo" name="unitNo"
                                                  readonly="readonly"><%=recBean.getInUnitInfo()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="city">City</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="city" name="city"
                                                  readonly="readonly"><%=recBean.getInCity()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="state">State</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="state" name="state"
                                                  readonly="readonly"><%=recBean.getInState()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="zipCode">ZIP Code</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="zipCode" name="zipCode"
                                                  vreadonly="readonly"><%=recBean.getInZip()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="nonCityAddr">Non-City Addr</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="nonCityAddr"
                                                  name="nonCityAddr" readonly="readonly"><%=recBean.getInMailnoncity()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="poBox">PO Box</label>
                                    </dt>
                                    <dd>              
                                        <textarea class="right greyOut" rows="1" cols="25" id="poBox" name="poBox"
                                                  maxlength="20"><%=recBean.getInMailPOBox()%></textarea>
                                    </dd>  
                                    <dt>
                                        <label for="respNameFirst">Resp First Name</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="respNameFirst" name="respNameFirst"
                                                  readonly="readonly" ><%=recBean.getInResponseNameFirst()%></textarea>
                                    <dt>
                                        <label for="respNameMiddle">Resp Mid Name</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="respNameMiddle" name="respNameMiddle"
                                                  readonly="readonly" ><%=recBean.getInResponseNameMiddle()%></textarea>
                                    <dt>
                                        <label for="respLastFirst">Resp Last Name</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="respLastFirst" name="respLastFirst"
                                                  readonly="readonly" ><%=recBean.getInResponseNameLast()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="respPhone">Resp Phone #</label>
                                    </dt>                   
                                        <dd style="display: table; text-align:right">
                                            <textarea class="greyOut" rows="1" cols="3" id="inRespPhoneArea" readonly="readonly"
                                                      name="inRespPhoneArea" ><%=recBean.getInResponsePhoneArea()%></textarea>
                                            <textarea class="greyOut" rows="1" cols="3" id="inRespPhonePrefix" readonly="readonly"
                                                      name="inRespPhonePrefix" ><%=recBean.getInResponsePhonePrefix()%></textarea>
                                            <textarea class="greyOut" rows="1" cols="4" id="inRespPhoneSuffix" readonly="readonly"
                                                      name="inRespPhoneSuffix" ><%=recBean.getInResponsePhoneSuffix()%></textarea>
                                        </dd>
                                    <dt>
                                        <label for="formLang">Form Language</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="formLang" name="formLang"
                                                  readonly="readonly"><%=recBean.getFormLanguage()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="locDesc">Location Desc</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="3" cols="25" id="locDesc" name="locDesc"
                                                  style="height:60px" readonly="readonly"><%=recBean.getInLocdesc()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="updatedCounty">Updated County</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="updatedCounty"
                                                  name="updatedCounty" readonly="readonly"><%=recBean.getUpdatedCounty()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="updatedState">Updated State</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="updatedState"
                                                  name="updatedState" readonly="readonly"><%=recBean.getUpdatedState()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="updatedZipCode">Updated ZIP Code</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="updatedZipCode"
                                                  name="updatedZipCode" readonly="readonly"><%=recBean.getUpdatedZip()%></textarea>
                                    </dd>
                                </dl>
                            </fieldset
                            <fieldset>
                                <legend>Enhanced Response</legend>
                                <dl>
                                    <dt>
                                        <label for="houseNumber">House Number</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="houseNumber"
                                                  name="houseNumber" readonly="readonly"><%=recBean.getInAddrNumber2()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="streetName">Street Name</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="streetName"
                                                  name="streetName" readonly="readonly"><%=recBean.getInStreetName2()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="unitNo">Unit No</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="unitNo" name="unitNo"
                                                  readonly="readonly"><%=recBean.getInUnitInfo2()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="city">City</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="city" name="city"
                                                  readonly="readonly"><%=recBean.getInCity2()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="state">State</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="state" name="state"
                                                  readonly="readonly"><%=recBean.getInState2()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="zipCode">ZIP Code</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="zipCode" name="zipCode"
                                                  readonly="readonly"><%=recBean.getInZip2()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="nonCityAddr">Non-City Addr</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="nonCityAddr"
                                                  name="nonCityAddr" readonly="readonly"><%=recBean.getInMailnoncity2()%></textarea>
                                    </dd>
                                    <dt>
                                        <label for="poBox">PO Box</label>
                                    </dt>
                                    <dd>              
                                        <textarea class="right greyOut" rows="1" cols="25" id="poBox" name="poBox"
                                                  maxlength="20"><%=recBean.getInMailPOBox2()%></textarea>
                                    </dd>
                                    <!--<dt><label for="respName">Resp Name</label></dt>-->
                                    <!--<dd><input class="right" id="respName" name="respName" type="text" value="" disabled /></dd>-->
                                    <!--<dt><label for="respPhone">Resp Phone #</label></dt>-->
                                    <!--<dd><input class="right" id="respPhone" name="respPhone" type="text" value="" disabled /></dd>-->
                                </dl>
                            </fieldset>
                        </div>
                    </div>
                    <!--
            CORRECTED INFO FIELDS
            -->
                    <div id="corrInfo_recNotes">
                        <div id="nav_corrInfo_recNotes">
                            <ul class="nav_CorrInfo nav_CorrInfo_tabs">
                                <li id="corrInfoLi" class="active">
                                    <a href="#correctedInfo">Corrected Info</a>
                                </li>
                                 
                                <li id="corrRecordNotes">
                                    <a href="#recordNotes">Notes
                                        <% if (!recBean.getNotes().isEmpty()){
                                            out.println(" *");
                                        }
                                %></a>
                                </li>
                                 
                            <%if (queBean.getQaCycle().equals("5")) { %>
                                <li id="previousResolution">
                                    <a href="#prevRes">History</a>
                                </li>
                            <%}%>
                            </ul>
                        </div>
                        <div id="correctedInfo" class="layout tabCorrInfo-content active">
                            <input type="hidden" name="action" value=""></input>
                            <div id="corrInfoFieldset">
                                <fieldset class="padding" style="border-color: transparent;">
                                    <dl>
                                        <dt>
                                            <label for="houseNumber">House Number</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right" rows="1" cols="22" id="corrHn" name="corrHn"
                                                      maxlength="20"><%=recBean.getCorrAddrNumber()%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="streetName">Street Name</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right" rows="1" cols="22" id="corrStreetName"
                                                      name="corrStreetName" maxlength="100"><%=recBean.getCorrStreetName()%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="unitNo">Unit No</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right" rows="1" cols="22" id="corrUnitNo" name="corrUnitNo"
                                                      maxlength="52"><%=recBean.getCorrUnitInfo()%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="city">City</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right" rows="1" cols="22" id="corrCity" name="corrCity"
                                                      maxlength="16"><%=recBean.getCorrCity()%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="state">State</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right" rows="1" cols="22" id="corrState" name="corrState"
                                                      maxlength="2"><%=recBean.getCorrState()%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="zipCode">ZIP Code</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right" rows="1" cols="22" id="corrZipCode"
                                                      name="corrZipCode" maxlength="5"><%=recBean.getCorrZip()%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="nonCityAddr">Non-City Addr</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right" rows="1" cols="22" id="corrNonCityAddr"
                                                      name="corrNonCityAddr" maxlength="16"><%=recBean.getCorrMailnoncity()%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="corrPoBox">PO Box</label>
                                        </dt>
                                        <dd>              
                                            <textarea class="right" rows="1" cols="22" id="corrPoBox" name="corrPoBox"
                                                      maxlength="20"><%=recBean.getCorrMailPOBox()%></textarea>
                                        </dd>  
                                        <dt>
                                            <label for="corrNameFirst">Resp First Name</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right" rows="1" cols="22" id="corrNameFirst" name="corrNameFirst"
                                                      maxlength="20"><%=recBean.getCorrResponseNameFirst()%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="corrNameMiddle">Resp Mid Name</label>
                                        </dt>
                                        <dd>              
                                            <textarea class="right" rows="1" cols="22" id="corrNameMiddle" name="corrNameMiddle"
                                                      maxlength="20"><%=recBean.getCorrResponseNameMiddle()%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="corrNameLast">Resp Last Name</label>
                                        </dt>
                                        <dd>                
                                            <textarea class="right" rows="1" cols="22" id="corrNameLast" name="corrNameLast"
                                                      maxlength="20"><%=recBean.getCorrResponseNameLast()%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="respPhone">Resp Phone #</label>
                                        </dt>
                                        <dd style="text-align: right; display: table;">
                                            <textarea class="" rows="1" cols="3" id="corrRespPhoneArea"
                                                      name="corrRespPhoneArea" maxlength="3"><%=recBean.getCorrResponsePhoneArea()%></textarea>
                                            <textarea class="" rows="1" cols="3" id="corrRespPhonePrefix"
                                                      name="corrRespPhonePrefix" maxlength="3"><%=recBean.getCorrResponsePhonePrefix()%></textarea>
                                            <textarea class="" rows="1" cols="4" id="corrRespPhoneSuffix"
                                                      name="corrRespPhoneSuffix" maxlength="4"><%=recBean.getCorrResponsePhoneSuffix()%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="locDesc">Location Desc</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right" rows="3" cols="22" id="corrLocDesc"
                                                      name="corrLocDesc" maxlength="100" style="height:60px"><%=recBean.getCorrLocdesc()%></textarea>
                                        </dd>
                                    </dl>
                                    <!-- input element for retaining custId -->
                                    <input class="right" id="custId" name="custId" type="hidden"
                                           value="<%=recBean.getCustid()%>"/>
                                </fieldset>
                            </div>
                        </div>
                        <div id="recordNotes" class="layout tabCorrInfo-content hide">
                            <input type="hidden" name="action" value=""></input>
                            <div id="recordNotesFieldset">
                                <fieldset>
                                    <legend>Notes</legend>
                                    <textarea rows="3" cols="25" id="recNotes" name="recNotes"
                                        maxlength="200" style="height:196px; width:300px; margin-left:10px;"><%=recBean.getNotes()%></textarea>
                                        
                                    <!-- input element for retaining custId -->
                                    <input class="right" id="custId" name="custId" type="hidden"
                                           value="&lt;%=recBean.getCustid()%>"/>
                                </fieldset>
                            </div>
                        </div>
                        <!--display history for verification record-->
                        <%if (recType.equals("verifier")) { %>
                            <div id="prevRes" class="layout tabCorrInfo-content hide">
                            <input type="hidden" name="prevResAction" value=""></input>
                            <div id="prevResFieldset">
                                <fieldset>
	                                <legend>RTNP</legend>
	                                <dl>
	                                    <dt>
	                                        <label for="mafidRTNP">MAFID</label>
	                                    </dt>
	                                    <dd>
	                                        <textarea class="right greyOut" rows="1" cols="25" id="mafidRTNP"
	                                                  name="mafidRTNP" readonly="readonly"></textarea>
	                                    </dd>
	                                    <dt>
	                                        <label for="geocodeRTNP">Geocode</label>
	                                    </dt>
	                                    <dd>
	                                        <textarea class="right greyOut" rows="1" cols="25" id="geocodeRTNP"
	                                                  name="geocodeRTNP" readonly="readonly"></textarea>
	                                    </dd>
	                                    <dt>
	                                        <label for="matchStatusRTNP">Match Status</label>
	                                    </dt>
	                                    <dd>
	                                        <textarea class="right greyOut" rows="1" cols="25" id="matchStatusRTNP" name="matchStatusRTNP"
	                                                  readonly="readonly"></textarea>
	                                    </dd>
	                                </dl>
	                            </fieldset>
	                            <fieldset>
	                                <legend>Automated</legend>
	                                <dl>
	                                    <dt>
	                                        <label for="mafidAuto">MAFID</label>
	                                    </dt>
	                                    <dd>
	                                        <textarea class="right greyOut" rows="1" cols="25" id="mafidAuto"
	                                                  name="mafidAuto" readonly="readonly"></textarea>
	                                    </dd>
	                                    <dt>
	                                        <label for="geocodeAuto">Geocode</label>
	                                    </dt>
	                                    <dd>
	                                        <textarea class="right greyOut" rows="1" cols="25" id="geocodeAuto"
	                                                  name="geocodeAuto" readonly="readonly"></textarea>
	                                    </dd>
	                                    <dt>
	                                        <label for="matchStatusAuto">Match Status</label>
	                                    </dt>
	                                    <dd>
	                                        <textarea class="right greyOut" rows="1" cols="25" id="matchStatusAuto" name="matchStatusAuto"
	                                                  readonly="readonly"></textarea>
	                                    </dd>
	                                </dl>
	                            </fieldset>
	                            <fieldset>
	                                <legend>Manual</legend>
	                                <dl>
	                                    <dt>
	                                        <label for="mafidManual">MAFID</label>
	                                    </dt>
	                                    <dd>
	                                        <textarea class="right greyOut" rows="1" cols="25" id="mafidManual"
	                                                  name="mafidManual" readonly="readonly"></textarea>
	                                    </dd>
	                                    <dt>
	                                        <label for="geocodeManual">Geocode</label>
	                                    </dt>
	                                    <dd>
	                                        <textarea class="right greyOut" rows="1" cols="25" id="geocodeManual"
	                                                  name="geocodeManual" readonly="readonly"></textarea>
	                                    </dd>
	                                    <dt>
	                                        <label for="matchStatusManual">Match Status</label>
	                                    </dt>
	                                    <dd>
	                                        <textarea class="right greyOut" rows="1" cols="25" id="matchStatusManual" name="matchStatusManual"
	                                                  readonly="readonly"></textarea>
	                                    </dd>
	                                </dl>
	                            </fieldset>
                            </div>
                        </div>                        
                        <% } %>
                       <!-- move this to another JSP
                        -->
                        <%if (recType.equals("record")) { %>
                        <div id="phoneCall" style="display: none;">
                            <!--class="layout tabCorrInfo-content hide"-->
                            <input type="hidden" name="action" value=""></input>
                            <div id="phoneCallYes">
                            <span>Did you make a call to the Respondent?</span></br>
                            <input class="" type="radio" id="phoneCallYesId" name="phoneCallQuestion" value="Yes">
                            <label for="phoneCallYesId">Yes, I made a call.</label>
                                <div id="phoneCallFieldset">
                                    <fieldset>
                                        <legend>Contact Made</legend>
                                        <input class="" type="radio" id="phoneCorrInfo" name="phoneCallRecord"
                                                value="<%=phonecallTypes.get(0).getPhonecallTypeCode()%>"
                                                <% if (phoneCallType.equals(phonecallTypes.get(0).getPhonecallTypeCode()) ) { %> checked="checked" <% }%>/>
                                        <label for="phoneCorrInfo"><%=phonecallTypes.get(0).getPhonecallTypeName()%></label>
                                        <br/>
                                        <input class="" type="radio" id="phoneGeocode" name="phoneCallRecord"
                                                value="<%=phonecallTypes.get(1).getPhonecallTypeCode()%>"
                                                <% if (phoneCallType.equals(phonecallTypes.get(1).getPhonecallTypeCode()) ) { %> checked="checked" <% }%>/>
                                        <label for="phoneGeocode"><%=phonecallTypes.get(1).getPhonecallTypeName()%></label>
                                        <br/>
                                        <input class="" type="radio" id="phoneNoAddtlInfo" name="phoneCallRecord"
                                                value="<%=phonecallTypes.get(2).getPhonecallTypeCode()%>"
                                                <% if (phoneCallType.equals(phonecallTypes.get(2).getPhonecallTypeCode()) ) { %> checked="checked" <% }%>/>
                                        <label for="phoneNoAddtlInfo"><%=phonecallTypes.get(2).getPhonecallTypeName()%></label>
                                        <br/>
                                        <input class="" type="radio" id="phoneHangUp" name="phoneCallRecord"
                                                value="<%=phonecallTypes.get(3).getPhonecallTypeCode()%>"
                                                <% if (phoneCallType.equals(phonecallTypes.get(3).getPhonecallTypeCode()) ) { %> checked="checked" <% }%>/>
                                        <label for="phoneHangUp"><%=phonecallTypes.get(3).getPhonecallTypeName()%></label>
                                        <br/>
                                        <input class="" type="radio" id="phoneBadConnection" name="phoneCallRecord"
                                               value="<%=phonecallTypes.get(4).getPhonecallTypeCode()%>"
                                               <% if (phoneCallType.equals(phonecallTypes.get(4).getPhonecallTypeCode()) ) { %> checked="checked" <% }%>/>
                                        <label for="phoneBadConnection"><%=phonecallTypes.get(4).getPhonecallTypeName()%></label>
                                    </fieldset>
                                     
                                    <fieldset>
                                        <legend style="margin-top:1px;">No Contact Made</legend>
                                        <input class="" type="radio" id="phoneNoAnswer" name="phoneCallRecord"
                                                value="<%=phonecallTypes.get(5).getPhonecallTypeCode()%>"
                                                <% if (phoneCallType.equals(phonecallTypes.get(5).getPhonecallTypeCode()) ) { %> checked="checked" <% }%>/>
                                        <label for="phoneNoAnswer"><%=phonecallTypes.get(5).getPhonecallTypeName()%></label>
                                        <br/>
                                        <input class="" type="radio" id="phoneInvalidNumber" name="phoneCallRecord"
                                               value="<%=phonecallTypes.get(6).getPhonecallTypeCode()%>"
                                               <% if (phoneCallType.equals(phonecallTypes.get(6).getPhonecallTypeCode()) ) { %> checked="checked" <% }%>/>
                                        <label for="phoneInvalidNumber"><%=phonecallTypes.get(6).getPhonecallTypeName()%></label>
                                        <br/>
                                        <input class="" type="radio" id="phoneBusy" name="phoneCallRecord"
                                                value="<%=phonecallTypes.get(7).getPhonecallTypeCode()%>"
                                                <% if (phoneCallType.equals(phonecallTypes.get(7).getPhonecallTypeCode()) ) { %> checked="checked" <% }%>/>
                                        <label for="phoneBusy"><%=phonecallTypes.get(7).getPhonecallTypeName()%></label>
                                        <br/>
                                        <input class="" type="radio" id="phoneAnswerMachine" name="phoneCallRecord"
                                               value="<%=phonecallTypes.get(8).getPhonecallTypeCode()%>"
                                               <% if (phoneCallType.equals(phonecallTypes.get(8).getPhonecallTypeCode()) ) { %> checked="checked" <% }%>/>
                                        <label for="phoneAnswerMachine"><%=phonecallTypes.get(8).getPhonecallTypeName()%></label>
                                    </fieldset>
                                </div>
                                    </br>
                                    <input class="" type="radio" id="phoneCallNo" name="phoneCallQuestion" value="No"><label for="phoneCallNo">No, I did not need to make call.</label>
                            </div>
                        </div>
                        <% } %>
                        
                        <div id="saveCorrButtons">
                            <input type="button" class="button" value="Save" id="saveCorrInfoBtn"></input>                            
                            <input type="button" class="button" value=">>" id="exportAddrBtn" style="min-width:30px; float:right"></input>
                        </div>
                    </div>
                    <!--
            SEARCH FIELDS
            -->
                    <div id="searchWindow" class="layout">
                        <h1 class="searchInfo">Search</h1>
                        <div class="sectionStyle2">
                            <fieldset class="padding">
                                <dl>
                                    <dt>
                                        <label for="houseNumber">House Number</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right searchTextarea" rows="1" cols="25" id="selHn"
                                                  name="selHn"></textarea>
                                    </dd>
                                    <dt>
                                        <label for="streetName">Street Name</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right searchTextarea" rows="1" cols="25" id="selStreetName"
                                                  name="selStreetName"></textarea>
                                    </dd>
                                    <dt>
                                        <label for="intStreet">Int Street</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right searchTextarea" rows="1" cols="25" id="selIntStreet"
                                                  name="selIntStreet"></textarea>
                                    </dd>
                                    <dt>
                                        <label for="zipCode">ZIP Code</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right searchTextarea" rows="1" cols="25" id="selZip"
                                                  name="selZip" maxlength="5"></textarea>
                                    </dd>
                                </dl>
                            </fieldset>
                             
                            <fieldset>
                                <legend>Map Search</legend>
                                <dl>
                                    <dt>
                                        <label for="blockState">State</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="selBlockState"
                                                  name="selBlockState" readonly="readonly"></textarea>
                                    </dd>
                                    <dt>
                                        <label for="blockCounty">County</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="selBlockCounty"
                                                  name="selBlockCounty" readonly="readonly"></textarea>
                                    </dd>
                                    <dt>
                                        <label for="tractID">Tract Id</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="selTractId"
                                                  name="selTractId" readonly="readonly"></textarea>
                                    </dd>
                                    <dt>
                                        <label for="blockId">Block Id</label>
                                    </dt>
                                    <dd>
                                        <textarea class="right greyOut" rows="1" cols="25" id="selBlockId"
                                                  name="selBlockId" readonly="readonly"></textarea>
                                    </dd>
                                </dl>
                            </fieldset>
                        </div>
                        <div class="right">
                            <% if (recType.equals("verifier")) { %>
                                <input type="button" class="button" value="MAF Browser" onclick="window.open('${pageContext.request.pathInfo}/mafbrowser/');"></input>
                            <%}%>
                            <input type="button" class="button" value="Show Map" id="showMapBtn"></input>                             
                            <input type="button" class="button" value="Search" id="addrSearchBtn"></input>                             
                            <input type="button" class="button" value="Reset" id="resetSearchBtn"></input>
                        </div>
                    </div>
                </div>
                <div id="resultGroup">
                        <jsp:include page="/jsp/xyz_navResults.jsp" />
                    </div>
                </div>
            </form>
        </div>
        <jsp:include flush="true" page="xyz_SideBySide.jsp">
        </jsp:include>
        
        <script language="javascript" type="text/javascript" src="${pageContext.request.contextPath}/js/xyz_common_record.js"></script>
        <%if (recType.equals("record")) { %>
            <script language="javascript" type="text/javascript" src="${pageContext.request.contextPath}/js/xyz_record.js"></script>
        <% } else if (recType.equals("verifier")) { %>
            <script language="javascript" type="text/javascript" src="${pageContext.request.contextPath}/js/xyz_verify.js"></script>
        <% } %>
        
        <% if (manualStatus.equals("true")) { %>
        <script>
            SideBySide.Open();
        </script>
        <% } %>
        
    </body>
</html>