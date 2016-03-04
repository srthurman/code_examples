<%@ page import="web.dbbean.compAddrBean"%>

<%
    compAddrBean ssBean = new compAddrBean();
    if (session.getAttribute("ssBean") != null){
        ssBean = (compAddrBean)session.getAttribute("ssBean");             
    } 
    
    //Manual Coded Status
    String manStatus = ssBean.getManStatus();
    //Manual MAF Block
    String manHouseNumber = ssBean.getManHn();
    String manStreetName = ssBean.getManStreet();
    String manUnitNo = ssBean.getManUnitNo();
    String manZipCode = ssBean.getManzipCode();
    String manMafId = ssBean.getManMafid();
    
    //Manual Geocode
    String manState = ssBean.getManState();
    String manCounty = ssBean.getManCounty();
    String manTract = ssBean.getManTract();
    String manBlock = ssBean.getManBlock();
    
    //Manual Corrected Info
    String manCorrHn               = ssBean.getManCorrHn();
    String manCorrStreetName       = ssBean.getManCorrStreet();
    String manCorrUnitNo           = ssBean.getManCorrUnitNo();
    String manCorrCity             = ssBean.getManCorrCity();
    String manCorrState            = ssBean.getManCorrState();
    String manCorrZipCode          = ssBean.getManCorrZipCode();
    String manCorrNonCityAddr      = ssBean.getManCorrNonCityAddr();
    String manCorrPoBox            = ssBean.getManCorrPoBox();
    String manCorrNameFirst        = ssBean.getManCorrNameFirst();
    String manCorrNameMiddle       = ssBean.getManCorrNameMiddle();    
    String manCorrNameLast         = ssBean.getManCorrNameLast();
    String manCorrRespPhoneArea    = ssBean.getManCorrPhoneArea();
    String manCorrRespPhonePrefix  = ssBean.getManCorrPhonePrefix();
    String manCorrRespPhoneSuffix  = ssBean.getManCorrPhoneSuffix();
    String manCorrLocDesc          = ssBean.getManCorrLocDesc();
    
    //Manual Notes
    String manNotes = ssBean.getManNotes();
    
    //Manual Phone Results
    String manPhone = ssBean.getManPhoneStatus();
    String manPhoneDesc = ssBean.getManPhoneDesc();
    
    //QC Coded status
    String qcStatus = ssBean.getQcStatus();
    //QC MAF Block
    String qcHouseNumber = ssBean.getQcHn();
    String qcStreetName = ssBean.getQcStreet();
    String qcUnitNo = ssBean.getQcUnitNo();
    String qcZipCode = ssBean.getQczipCode();
    String qcMafId = ssBean.getQcMafid();
    
    //QC Geocode
    String qcState = ssBean.getQcState();
    String qcCounty = ssBean.getQcCounty();
    String qcTract = ssBean.getQcTract();
    String qcBlock = ssBean.getQcBlock();
    
    //QC Corrected Info
    String qcCorrHn               = ssBean.getQcCorrHn();
    String qcCorrStreetName       = ssBean.getQcCorrStreet();
    String qcCorrUnitNo           = ssBean.getQcCorrUnitNo();
    String qcCorrCity             = ssBean.getQcCorrCity();
    String qcCorrState            = ssBean.getQcCorrState();
    String qcCorrZipCode          = ssBean.getQcCorrZipCode();
    String qcCorrNonCityAddr      = ssBean.getQcCorrNonCityAddr();
    String qcCorrPoBox            = ssBean.getQcCorrPoBox();
    String qcCorrNameFirst        = ssBean.getQcCorrNameFirst();
    String qcCorrNameMiddle       = ssBean.getQcCorrNameMiddle();    
    String qcCorrNameLast         = ssBean.getQcCorrNameLast();
    String qcCorrRespPhoneArea    = ssBean.getQcCorrPhoneArea();
    String qcCorrRespPhonePrefix  = ssBean.getQcCorrPhonePrefix();
    String qcCorrRespPhoneSuffix  = ssBean.getQcCorrPhoneSuffix();
    String qcCorrLocDesc          = ssBean.getQcCorrLocDesc();
    
    //QC Notes
    String qcNotes = ssBean.getQcNotes();
    
    //QC Phone Results
    String qcPhone = ssBean.getQcPhoneStatus();
    String qcPhoneDesc = ssBean.getQcPhoneDesc();    
    
%>
        <!-- dialog window markup -->
        <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/xyz_sideBySide.css"/>
        
        <div id="dialogSideBySide" title="Manual Side-By-Side Comparison"  style="display: none;">
            <div id="headerSideBySideWindow">
                <div id="headerManual">
                    <h1>Manual</h1>
                </div>
                <div id="headerQc">
                    <h1>Quality Control (QC)</h1>
                </div>
            </div>
            <div id="sideBySideWindow">
                <div id="manualBody">
                    <fieldset id="manCodeStatus">
                        <legend>Coded Status</legend>
                            <dl>
                                <dt>
                                    <label for="manStatus"></label>
                                </dt>
                                <dd style="text-align: left; display: table;">
                                    <textarea class="greyOut" rows="1" cols="50" id="manStatus"
                                              name="manStatus" readonly="readonly"><%=manStatus%></textarea>
                                </dd>
                            </dl>
                    </fieldset>
                    <fieldset id="manMaf">                        
                        <legend>MAF</legend>
                            <dl>
                                <dt>
                                    <label for="manHouseNumber">House Number</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="manHouseNumber"
                                              name="manHouseNumber" readonly="readonly"><%=manHouseNumber%></textarea>
                                </dd>
                                <dt>
                                    <label for="manStreetName">Street Name</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="manStreetName"
                                              name="manStreetName" readonly="readonly"><%=manStreetName%></textarea>
                                </dd>
                                <dt>
                                    <label for="manUnitNo">Unit No</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="manUnitNo" name="manUnitNo"
                                              readonly="readonly"><%=manUnitNo%></textarea>
                                </dd>                                
                                <dt>
                                    <label for="manZipCode">ZIP Code</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="manZipCode" name="manZipCode"
                                              vreadonly="readonly"><%=manZipCode%></textarea>
                                </dd>
                                <dt>
                                    <label for="manMafId">MAF Id</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="manMafId" name="manMafId"
                                              vreadonly="readonly"><%=manMafId%></textarea>
                                </dd>
                            </dl>
                    </fieldset>
                    <fieldset id="geocode">
                        <legend>Geocode</legend> <!--State, County, Tract, Block-->
                            <dl>
                                <dt>
                                    <label for="manState">State Id</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="manState"
                                              name="manState" readonly="readonly"><%=manState%></textarea>
                                </dd>
                                <dt>
                                    <label for="manCounty">County Id</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="manCounty"
                                              name="manCounty" readonly="readonly"><%=manCounty%></textarea>
                                </dd>
                                <dt>
                                    <label for="manTract">Tract Id</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="manTract"
                                              name="manTract" readonly="readonly"><%=manTract%></textarea>
                                </dd>
                                <dt>
                                    <label for="manBlock">Block Id</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="manBlock"
                                              name="manBlock" readonly="readonly"><%=manBlock%></textarea>
                                </dd>
                            </dl>
                    </fieldset>
                    <fieldset id="manCorrAdd">
                        <legend>Corrected Address Info</legend>
                            <dl>
                                        <dt>
                                            <label for="manCorrHn">House Number</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="1" cols="25" id="manCorrHn" name="manCorrHn"
                                                      readonly="readonly" maxlength="20"><%=manCorrHn%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="manCorrStreetName">Street Name</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="1" cols="25" id="manCorrStreetName"
                                                      readonly="readonly" name="manCorrStreetName" maxlength="100"><%=manCorrStreetName%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="manmanCorrUnitNo">Unit No</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="1" cols="25" id="manCorrUnitNo" name="manCorrUnitNo"
                                                      readonly="readonly" maxlength="52"><%=manCorrUnitNo%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="manCorrCity">City</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="1" cols="25" id="manCorrCity" name="manCorrCity"
                                                      readonly="readonly" maxlength="16"><%=manCorrCity%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="manCorrState">State</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="1" cols="25" id="manCorrState" name="manCorrState"
                                                      readonly="readonly" maxlength="2"><%=manCorrState%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="manCorrZipCode">ZIP Code</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="1" cols="25" id="manCorrZipCode"
                                                      readonly="readonly" name="manCorrZipCode" maxlength="5"><%=manCorrZipCode%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="manCorrNonCityAddr">Non-City Addr</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="1" cols="25" id="manCorrNonCityAddr"
                                                      readonly="readonly" name="manCorrNonCityAddr" maxlength="16"><%=manCorrNonCityAddr%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="manCorrPoBox">PO Box</label>
                                        </dt>
                                        <dd>              
                                            <textarea class="right greyOut" rows="1" cols="25" id="manCorrPoBox" name="manCorrPoBox"
                                                      readonly="readonly" maxlength="20"><%=manCorrPoBox%></textarea>
                                        </dd>  
                                        <dt>
                                            <label for="manCorrNameFirst">Resp First Name</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="1" cols="25" id="manCorrNameFirst" name="manCorrNameFirst"
                                                      readonly="readonly" maxlength="20"><%=manCorrNameFirst%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="manCorrNameMiddle">Resp Mid Name</label>
                                        </dt>
                                        <dd>              
                                            <textarea class="right greyOut" rows="1" cols="25" id="manCorrNameMiddle" name="manCorrNameMiddle"
                                                      readonly="readonly" maxlength="20"><%=manCorrNameMiddle%></textarea>
                                        </dd>                                                                              
                                        <dt>
                                            <label for="manCorrNameLast">Resp Last Name</label>
                                        </dt>
                                        <dd>                
                                            <textarea class="right greyOut" rows="1" cols="25" id="manCorrNameLast" name="manCorrNameLast"
                                                      readonly="readonly" maxlength="20"><%=manCorrNameLast%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="respPhone">Resp Phone #</label>
                                        </dt>
                                        <dd style="text-align: right; display: table;">
                                            <textarea class="greyOut" rows="1" cols="4" id="manCorrRespPhoneArea"
                                                      readonly="readonly" name="manCorrRespPhoneArea" maxlength="3"><%=manCorrRespPhoneArea%></textarea>
                                            <textarea class="greyOut" rows="1" cols="5" id="manCorrRespPhonePrefix"
                                                      readonly="readonly" name="manCorrRespPhonePrefix" maxlength="3"><%=manCorrRespPhonePrefix%></textarea>
                                            <textarea class="greyOut" rows="1" cols="6" id="manCorrRespPhoneSuffix"
                                                      readonly="readonly" name="manCorrRespPhoneSuffix" maxlength="4"><%=manCorrRespPhoneSuffix%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="manCorrLocDesc">Location Desc</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="3" cols="50" id="manCorrLocDesc"
                                                      readonly="readonly" name="manCorrLocDesc" maxlength="100" style="height:60px"><%=manCorrLocDesc%></textarea>
                                        </dd>
                                    </dl>
                    </fieldset>
                    <fieldset id="notes">
                        <legend>Notes</legend>
                            <textarea class="right greyOut" rows="3" cols="50" id="manNotes"
                                      readonly="readonly" name="manNotes" maxlength="100" style="height:60px"><%=manNotes%></textarea>
                            
                    </fieldset>
                    <fieldset id="phone">
                        <legend>Phone Call Results</legend>
                            <textarea class="right greyOut" rows="3" cols="50" id="manPhone"
                                      readonly="readonly" name="manPhone" maxlength="100" style="height:60px"><%=manPhone%> - <%=manPhoneDesc%></textarea>
                    </fieldset>                    
                </div>
                
                
                <div id="qcBody">
                    <fieldset id="qcCodeStatus">
                        <legend>Coded Status</legend>
                            <dl>
                                <dt>
                                    <label for="qcStatus"></label>
                                </dt>
                                <dd style="text-align: left; display: table;">
                                    <textarea class="greyOut" rows="1" cols="50" id="qcStatus"
                                              readonly="readonly" name="qcStatus"><%=qcStatus%></textarea>
                                </dd>
                            </dl>
                    </fieldset>
                    <fieldset id="qcMaf">
                        <legend>MAF</legend>
                            <dl>
                                <dt>
                                    <label for="qcHouseNumber">House Number</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="qcHouseNumber"
                                              name="qcHouseNumber" readonly="readonly"><%=qcHouseNumber%></textarea>
                                </dd>
                                <dt>
                                    <label for="qcStreetName">Street Name</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="qcStreetName"
                                              name="qcStreetName" readonly="readonly"><%=qcStreetName%></textarea>
                                </dd>
                                <dt>
                                    <label for="qcUnitNo">Unit No</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="qcUnitNo" name="qcUnitNo"
                                              readonly="readonly"><%=qcUnitNo%></textarea>
                                </dd>                                
                                <dt>
                                    <label for="qcZipCode">ZIP Code</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="qcZipCode" name="qcZipCode"
                                              readonly="readonly"><%=qcZipCode%></textarea>
                                </dd>
                                <dt>
                                    <label for="qcMafId">MAF Id</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="qcMafId" name="qcMafId"
                                              readonly="readonly"><%=qcMafId%></textarea>
                                </dd>
                            </dl>
                    </fieldset>
                    <fieldset id="geocode">
                        <legend>Geocode</legend> <!--State, County, Tract, Block-->
                            <dl>
                                <dt>
                                    <label for="qcState">State Id</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="qcState"
                                              name="qcState" readonly="readonly"><%=qcState%></textarea>
                                </dd>
                                <dt>
                                    <label for="qcCounty">County Id</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="qcCounty"
                                              name="qcCounty" readonly="readonly"><%=qcCounty%></textarea>
                                </dd>
                                <dt>
                                    <label for="qcTract">Tract Id</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="qcTract"
                                              name="qcTract" readonly="readonly"><%=qcTract%></textarea>
                                </dd>
                                <dt>
                                    <label for="qcBlock">Block Id</label>
                                </dt>
                                <dd>
                                    <textarea class="right greyOut" rows="1" cols="25" id="qcBlock"
                                              name="qcBlock" readonly="readonly"><%=qcBlock%></textarea>
                                </dd>
                            </dl>
                    </fieldset>
                    <fieldset id="qcCorrAdd">
                        <legend>Corrected Address Info</legend>
                            <dl>
                                        <dt>
                                            <label for="qcCorrHn">House Number</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="1" cols="25" id="qcCorrHn" name="qcCorrHn"
                                                      readonly="readonly" maxlength="20"><%=qcCorrHn%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="qcCorrStreetName">Street Name</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="1" cols="25" id="qcCorrStreetName"
                                                      readonly="readonly" name="qcCorrStreetName" maxlength="100"><%=qcCorrStreetName%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="qcqcCorrUnitNo">Unit No</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right  greyOut" rows="1" cols="25" id="qcCorrUnitNo" name="qcCorrUnitNo"
                                                      readonly="readonly" maxlength="52"><%=qcCorrUnitNo%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="qcCorrCity">City</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="1" cols="25" id="qcCorrCity" name="qcCorrCity"
                                                      readonly="readonly" maxlength="16"><%=qcCorrCity%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="qcCorrState">State</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="1" cols="25" id="qcCorrState" name="qcCorrState"
                                                      readonly="readonly" maxlength="2"><%=qcCorrState%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="qcCorrZipCode">ZIP Code</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="1" cols="25" id="qcCorrZipCode"
                                                      readonly="readonly" name="qcCorrZipCode" maxlength="5"><%=qcCorrZipCode%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="qcCorrNonCityAddr">Non-City Addr</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="1" cols="25" id="qcCorrNonCityAddr"
                                                      readonly="readonly" name="qcCorrNonCityAddr" maxlength="16"><%=qcCorrNonCityAddr%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="qcCorrPoBox">PO Box</label>
                                        </dt>
                                        <dd>              
                                            <textarea class="right greyOut" rows="1" cols="25" id="qcCorrPoBox" name="qcCorrPoBox"
                                                      readonly="readonly" maxlength="20"><%=qcCorrPoBox%></textarea>
                                        </dd> 
                                        <dt>
                                            <label for="qcCorrNameFirst">Resp First Name</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="1" cols="25" id="qcCorrNameFirst" name="qcCorrNameFirst"
                                                      readonly="readonly" maxlength="20"><%=qcCorrNameFirst%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="qcCorrNameMiddle">Resp Mid Name</label>
                                        </dt>
                                        <dd>              
                                            <textarea class="right greyOut" rows="1" cols="25" id="qcCorrNameMiddle" name="qcCorrNameMiddle"
                                                      readonly="readonly" maxlength="20"><%=qcCorrNameMiddle%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="qcCorrNameLast">Resp Last Name</label>
                                        </dt>
                                        <dd>                
                                            <textarea class="right greyOut" rows="1" cols="25" id="qcCorrNameLast" name="qcCorrNameLast"
                                                      readonly="readonly" maxlength="20"><%=qcCorrNameLast%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="respPhone">Resp Phone #</label>
                                        </dt>
                                        <dd style="text-align: right; display: table;">
                                            <textarea class="greyOut" rows="1" cols="4" id="qcCorrRespPhoneArea"
                                                      readonly="readonly" name="qcCorrRespPhoneArea" maxlength="3"><%=qcCorrRespPhoneArea%></textarea>
                                            <textarea class="greyOut" rows="1" cols="5" id="qcCorrRespPhonePrefix"
                                                      readonly="readonly" name="qcCorrRespPhonePrefix" maxlength="3"><%=qcCorrRespPhonePrefix%></textarea>
                                            <textarea class="greyOut" rows="1" cols="6" id="qcCorrRespPhoneSuffix"
                                                      readonly="readonly" name="qcCorrRespPhoneSuffix" maxlength="4"><%=qcCorrRespPhoneSuffix%></textarea>
                                        </dd>
                                        <dt>
                                            <label for="qcCorrLocDesc">Location Desc</label>
                                        </dt>
                                        <dd>
                                            <textarea class="right greyOut" rows="3" cols="50" id="qcCorrLocDesc"
                                                      readonly="readonly" name="qcCorrLocDesc" maxlength="100" style="height:60px"><%=qcCorrLocDesc%></textarea>
                                        </dd>
                                    </dl>
                    </fieldset>
                    <fieldset id="notes">
                        <legend>Notes</legend>
                            <textarea class="right greyOut" rows="3" cols="50" id="qcNotes"
                                      readonly="readonly" name="qcNotes" maxlength="100" style="height:60px"><%=qcNotes%></textarea>
                            
                    </fieldset>
                    <fieldset id="phone">
                        <legend>Phone Call Results</legend>
                            <textarea class="right greyOut" rows="3" cols="50" id="qcPhone"
                                      readonly="readonly" name="qcPhone" maxlength="100" style="height:60px"><%=qcPhone%> - <%=qcPhoneDesc%></textarea>
                    </fieldset>                       
                </div>                
            </div>
            
        </div>
        <script language="javascript" type="text/javascript" src="${pageContext.request.contextPath}/js/xyz_sideBySide.js"></script>
        
        