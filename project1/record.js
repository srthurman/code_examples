var Record = {
};
Record.mapWindowObject = null;
Record.recordWindowObject = null;
//case insensitve regular expression for use in removing prefix/suffix from address when copied using >> button
//todo: try to use one regexp and pull the group matching a basename
Record.regexpPrefixString = "^(((n\\.*|s\\.*|e\\.*|w\\.*|ne\\.*|nw\\.*|se\\.*|sw\\.*|north|south|east|west)\\s+){0,1})";
Record.regexpSuffixString = "(\\s+(dr\\.*|drive|ct\\.*|court|way|rd\\.*|road|ave\\.*|avenue|st\\.*|street|blvd\\.*|cir\\.*|circle)\\s*)$";







/****************** Utility functions ******************/
Record.enableButton = function(btnClass) {
    $(btnClass).prop('disabled', false).addClass('enableInputButton');
};

$('#overlay-item, #overlay-back').hide();//-monki

//**// pressing [enter] key will trigger [search] submit
$('.searchTextarea').keypress(function (event) {
    var keycode = (event.keyCode ? event.keyCode : event.which);
    if (event.which == '13') {
        Record.AddressSearch();
        return false;
    }
});

//**// scroll function
$('#scrollVertical').on('keyup', 'textarea', function (e) {
    $(this).css('height', 'auto');
    $(this).height(this.scrollHeight);
});
$('#scrollVertical').find('textarea').keyup();

//**// Ensure only numbers are valid for this field
Record.validateNumber = function (e) {
    // Allow: backspace, delete, tab, escape, enter and .
    if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !==  - 1 || 
    // Allow: Ctrl+A
    (e.keyCode == 65 && e.ctrlKey === true) || 
    // Allow: Ctrl+C
    (e.keyCode == 67 && e.ctrlKey === true) || 
    // Allow: Ctrl+X
    (e.keyCode == 88 && e.ctrlKey === true) || 
    // Allow: home, end, left, right
    (e.keyCode >= 35 && e.keyCode <= 39)) {
        // let it happen, don't do anything
        return;
    }
    // Ensure that it is a number and stop the keypress
    if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
        e.preventDefault();
    }
};

//**// Get search input from Corr Info fields
Record.Export = function Export() {
    $("#selHn").val($("#corrHn").val());
    $('#selZip').val($("#corrZipCode").val());

    //create a regexp object using regexp variable and remove prefix
    var re = new RegExp(Record.regexpPrefixString, "i");
    var streetToChop = $("#corrStreetName").val().replace(re, "");
    //create a regexp object using regexp variable and remove prefix
    re = new RegExp(Record.regexpSuffixString, "i");
    streetToChop = streetToChop.replace(re, "");
    //send the updated street name to the search street
    if (typeof (streetToChop) != 'undefined' && streetToChop != null && streetToChop.trim() != '') {
        $('#selStreetName').val(streetToChop.trim());
    }
    else {
        $('#selStreetName').val($("#corrStreetName").val());
    }
};

//**// Reset all fields
Record.Reset = function Reset() {
    $("#selHn").val("");
    $('#selStreetName').val("");
    $('#selIntStreet').val("");
    $('#selZip').val("");
    $('#selBlockState').val("");
    $('#selBlockCounty').val("");
    $('#selBlockId').val("");
    $('#selTractId').val("");
    $("#addressTab").empty();
    $("#rangeTab").empty();
    $('#selCodedTypeAndData').val("");
    $('#selResults').val("");

};

/****************** END Utility functions ******************/










/****************** Click Handlers ******************/
$('.nav_CorrInfo_tabs > li > a').click(function (event) {
    event.preventDefault();//stop browser to take action for clicked anchor
    //get displaying tab content jQuery selector
    var active_tab_selector = $('.nav_CorrInfo_tabs > li.active > a').attr('href');

    //find actived navigation and remove 'active' css
    var actived_nav = $('.nav_CorrInfo_tabs > li.active');
    actived_nav.removeClass('active');

    //add 'active' css into clicked navigation
    $(this).parents('li').addClass('active');

    //hide displaying tab content
    $(active_tab_selector).removeClass('active');
    $(active_tab_selector).addClass('hide');

    //show target tab content
    var target_tab_selector = $(this).attr('href');
    $(target_tab_selector).removeClass('hide');
    $(target_tab_selector).addClass('active');

});

$('#phoneCall').click(function () {
    var checkedQuestion = $('input:radio[name=phoneCallQuestion]:checked').val();
    if (checkedQuestion == 'Yes') {
        $("#phoneCallFieldset").slideDown("slow");
    }
    else {
        $("input[name=phoneCallRecord]:checked").prop('checked', false);
        $("#phoneCallFieldset").slideUp("slow");
    }

});

/****************** END Click Handlers ******************/










/****************** Phone Call Dialog ******************/
$("#phoneCall").dialog( {
    autoOpen : false
});

//**// Phonecall dialog resize dialog to center if window is resized
$(window).resize(function(){
   $( "#phoneCall" ).dialog( "option", "position", { my: "center", at: "center", of: window } );
});

$("#phoneCallFieldset").hide();

Record.clearPhoneSelection = function () {
    $("input[name=phoneCallQuestion]:checked").prop('checked', false);
    $("input[name=phoneCallRecord]:checked").prop('checked', false);
    $("#phoneCallFieldset").hide();
};

Record.YesNoDialog = function YesNoDialog(dialogTitle, dialogText, dialogWidth, dialogHeight, btn1) {
    var promise = $.Deferred();

    $("#phoneCall").dialog( {
        modal : true, 
        title : dialogTitle, 
        autoOpen : false, 
        width : dialogWidth, 
        height : dialogHeight, 
        resizable : false, 
        buttons : [{
            text : "Mark as " + btn1, 
            click : function () {
                var checkedQuestion = $("input[name=phoneCallQuestion]:checked").val();
                var phoneCallResult = $("input[name=phoneCallRecord]:checked").val();
                if (checkedQuestion == 'No') {$("#phoneCall").dialog("close");
                    promise.resolve('Proceed');
                }else if (checkedQuestion == 'Yes') {
                    if (phoneCallResult) {$("#phoneCall").dialog("close");
                        promise.resolve('Proceed');
                    }else {alert('Please select an option from the Call options.');}
                }else {alert('Please select a response.');
                }
            }
        },
        {
             text : "Cancel", 
             click : function () {
                $("#phoneCall").dialog("close");Record.clearPhoneSelection();promise.resolve('Cancel');
                }
        }]
    });

    $("#phoneCall").dialog("open");
    return promise.promise();
};

Record.PhoneLog = function (updType) {
    console.log("Phone logging function");
    var promise = $.Deferred();

    if (updType === 'Uncodable' || updType === 'Accept') {
        Record.YesNoDialog('Phone Call Results', null, 'auto', 'auto', updType)
            .done(function (resp) {
                console.log("Phone Dialog Done: " + resp);
                if (resp === 'Proceed') {
                    promise.resolve('true');
                }
                else if (resp === 'Cancel') {
                    promise.reject('false');
                }
            })
            .fail(function (resp) {
                console.log("Phone Dialog Failure: " + resp);
                alert("Oops! There was a problem: " + resp);
                promise.reject('false');
            });
    }
    else {
        return true;
    }
    return promise.promise();

};

Record.PhoneCall = function () {
    $('#PhoneCall').prop('disabled', true).addClass('disableInputButton');
    SideBySide.PhoneCall();
    $.ajax({type : "POST", url : "CServlet?action=QCPhoneCall"});
};
/****************** END Phone Call Dialog ******************/











/****************** Map Window ******************/
if (!Record.recordWindowObject) {
    Record.recordWindowObject = window.self;
};

Record.showMapButton = function () {
    if (!Record.checkMapOpen()) {
        Record.showMap();
    }
};

Record.closeMapWindow = function () {
    if (Record.checkMapOpen()) {
        Record.mapWindowObject.close();
    };
};

Record.showMap = function () {
    Record.mapWindowObject = window.open("CServlet?action=showMap", "projMap", "resizable=1,height=800,width=900");
};

Record.checkMapOpen = function () {
    //alert('checking map status');   
    if (!Record.mapWindowObject || Record.mapWindowObject.closed) {
        return false
    };
    return true;
};

//**// Called from Map Window
Record.clearOtherHighlight = function (src) {
    //clearing the selected data values first
    $('#selResults').val("");
    $('#selCodedTypeAndData').val("");

    //clear the highlights
    if (src === "addr") {
        $('#tblResult1 tr, #tblResult2 tr').removeClass('highlighted');
        $("#selDisplayName").val("");
        $("#selArZip").val("");
        if (Record.mapWindowObject && !Record.mapWindowObject.closed) {
            Record.mapWindowObject.projMap.clearHighlight();
            Record.mapWindowObject.projMap.clearHighlightMapList();
        }
    }
    if (src === "rng") {
        $('#tblAddrRes tr').removeClass('highlighted');
        if (Record.mapWindowObject && !Record.mapWindowObject.closed) {
            Record.mapWindowObject.projMap.clearHighlight();
            Record.mapWindowObject.projMap.clearHighlightMapList();
        }
    }
    else if (src === "map") {
        $('#tblAddrRes tr, #tblResult1 tr, #tblResult2 tr').removeClass('highlighted');
        $("#selDisplayName").val("");
        $("#selArZip").val("");
    }

};
/****************** END Map Window ******************/









//Sara - section
/****************** Corrected Info ******************/
$("#corrRespPhoneArea").keydown(Record.validateNumber);
$("#corrRespPhonePrefix").keydown(Record.validateNumber);
$("#corrRespPhoneSuffix").keydown(Record.validateNumber);

Record.saveCorrInfo = function () {
    var phoneCallRecord = "";
    if ($("input[name=phoneCallRecord]:checked").val()) {
        phoneCallRecord = $("input[name=phoneCallRecord]:checked").val();
    }
    var promise = $.Deferred();

    console.log("before ajax " + phoneCallRecord);
    $.ajax( {
        type : "POST", url : "CServlet?action=saveCorrInfo", data : $('#recordForm').serialize() + "&phoneCallRecord=" + phoneCallRecord
    })
    .then(
        function (resp) { Record.saveCorrInfoSuccess(resp, promise) ;},
        function (resp) { promise.reject(resp); }
    );
    return promise.promise();
};

Record.saveCorrInfoSuccess = function (resp, promise) {
            console.log("DONE saveCorrInfo");
            console.log(resp);
            var isplit = resp.split(':');
            var retStatus = isplit[0];
            var message = isplit[1];
    
            if (retStatus != "0") {
                alert(message);
                promise.reject();
            }
            else {
                promise.resolve();
            }
        }

/****************** END Corrected Info ******************/










/****************** Address Search ******************/

Record.AddressSearch = function AddressSearch() {

    var selHn = $("#selHn").val();
    var selStreet = ($('#selStreetName').val()).trim();
    var selIntStreet = ($('#selIntStreet').val()).trim();
    var selZip = $('#selZip').val();
    var selSt = $('#selBlockState').val();
    var selCou = $('#selBlockCounty').val();
    var selBlock = $('#selBlockId').val();
    var selTract = $('#selTractId').val();
    var valid = "0123456789";
    var hyphencount = 0;

    if (!(selZip == null || selZip.length == 0)) {

        if (selZip.length != 5) {
            alert("Please enter valid 5 digit ZIP code.");
            $('#zipCode').value = "";
            $('#zipCode').focus();
            return false;
        }
        for (var i = 0;i < selZip.length;i++) {
            temp = "" + selZip.substring(i, i + 1);
            if (temp == "-")
                hyphencount++;
            if (valid.indexOf(temp) == "-1") {
                alert("Invalid characters in your ZIP code.  Please try again.");
                $('#zipCode').val("");
                $('#zipCode').focus();
                return false;
            }
        }
    }
    else if ((selSt.length == 0) || (selCou.length == 0) || (selBlock.length == 0) || (selTract.length == 0)) {
        alert("No valid Search type is selected.");
        return false;
    }

    $("#addressTab").empty();
    $("#rangeTab").empty();

    $.ajax( {
        url : 'CServlet?action=AddressSearch', type : 'POST', dataType : 'html', data :  {
            selHn : selHn, selStreet : selStreet, selIntStreet : selIntStreet, selZip : selZip, selSt : selSt, selCou : selCou, selBlock : selBlock, selTract : selTract
        },
        success : function (data) {
            $("#resultGroup").html(data);
            $("#resultGroup").show();
            //check if map is open
            if (Record.checkMapOpen()) {
                //map open; reload
                Record.mapWindowObject.location.reload();
            }
            else {
                //show map
                Record.showMap();
            }
        },
        error : function () {
            alert("An error occurred in Address Search. Please check the log files.");
            return false;
        }
    });
    $("#bottom_button").toggle();
    return true;
};

/****************** END Address Search ******************/









//Sara - section
/********************* UPDATE METHODS *********************/
Record.UpdateRecord = function (updType) {
    console.log("update record");
    var updRec = Record.UpdateRecordConfirm(updType);

    if ($("#qaCycle").val() === "2") {
        Record.checkManualStatus()
        .then(
            function(resp) { updateRecordQC(resp, updRec, updType); }
        )
    }
    else {
        if (updRec.status) {
            Record.UpdateRecordFinal(updType, updRec.postData);
        };
    }

};

Record.UpdateRecordConfirm = function(updType) {
        console.log("update record confirm");
        var retVal = {"status": false, "postData": {}};
        var confirmMsg = "Are you sure you want to " + updType.toUpperCase() + " this case";
        
        if (updType === 'Uncodable') {
            //Adding for grammar sake
            confirmMsg = "Are you sure you want to mark UNCODABLE to this case"
        };
        
        if (updType === 'Accept') {
            var selCodedTypeAndData = $('#selCodedTypeAndData').val();
            if (selCodedTypeAndData.length > 0) {
                var codeSplit = selCodedTypeAndData.split(':');
                var codeType = codeSplit[0];
                confirmMsg = $('#selResults').val() + "\n" + confirmMsg + " to the " + codeType;
                retVal.postData = {
                    selCodedTypeAndData : selCodedTypeAndData
                };
            }
            else {
                alert("Please Select either an Address, Range, or Map Data to code the case.");
                retVal.status = false;
                return retVal;
            }
        };
    
        if (confirm(confirmMsg + "?")) {
            retVal.status = true;
        };
        
        return retVal;
};

Record.UpdateRecordFinal = function(updType, postData) {
    console.log("update record final");
    var updateComp = $.Deferred();
    $('.recordButtons').prop('disabled', true).addClass('disableInputButton');

    Record.PhoneLog(updType)
    .then(
        Record.saveCorrInfo,
        Record.reEnableButtons
    ) //post SaveCorrInfo
    .then(
        function (resp) {
            return $.ajax( { type : "POST", url : "CServlet?action=Record" + updType, data : postData } );
        },
        function () {
            Record.enableButton('.recordButtons');
            //$('.recordButtons').prop('disabled', false).addClass('enableInputButton');
        }
    ) //post Update the record
    .then(
        function (resp) { Record.UpdateRecordFinalSuccess(resp, updateComp); }
    );

    return updateComp.promise();
};

Record.UpdateRecordFinalSuccess = function (resp, defObj) {
    console.log("DONE saveCorrInfo Deferred AJAX -- " + resp);
    var isplit = resp.split(':');
    var retStatus = isplit[0];
    var message = isplit[1];

    if (retStatus == "0") {
        //0=success, 1=update failure, 2=other errors
        var qaCycle = $("#qaCycle").val();
        alert(message);
        if (qaCycle !== "2") {
            document.recordForm.action = "DServlet?action=getNewRecord&qaCycle=" + qaCycle;
            document.recordForm.submit();
        } else {
            console.log("updateComp resolve");
            Record.enableButton('.recordButtons');
            //$('.recordButtons').prop('disabled', false).addClass('enableInputButton');
            defObj.resolve();
            
        }
    }
    else {
        alert(message);
        Record.enableButton('.recordButtons');
        //$('.recordButtons').prop('disabled', false).addClass('enableInputButton');
    }
};


Record.checkManualStatus = function() {
    return $.ajax({type : "POST", url : "CServlet?action=checkManualStatus"});
    //SideBySide.Open();
};


Record.updateRecordQC = function(resp, updRec, updType) {
    console.log("resp 1");
    console.log(resp);
    if (updRec.status) {
        Record.UpdateRecordFinal(updType, updRec.postData)
        .then(Record.checkIfCompareNeeded);
    };
};


Record.checkIfCompareNeeded = function(resp) {
    //if the qc and manual reviewer results need to be compared
    console.log("resp 2");
    console.log(resp);
    if (resp === "false") {
        Record.compareQCRecord()
        .then(Record.compareQCRecordResponse);
    }
    //if we're accepting the qc answers
    else {
    //call method to update table
	    document.recordForm.action = "CServlet?action=updateQueueTableQC&errorFlag=1";
	    document.recordForm.submit();
    };
};


Record.compareQCRecord = function() {
    return $.ajax({type : "POST", url : "CServlet?action=compareQCRecords"});
};


Record.compareQCRecordResponse = function(resp) {
    console.log("compareQCRecordResponse");
    var iSplit = resp.split(':');
    var status = iSplit[0];
    var error = iSplit[1];
    if (status === "0") {
        console.log("Record.compareQCRecord - calling updateQueueTable QC, errorFlag: 0");
        document.recordForm.action = "CServlet?action=updateQueueTableQC&errorFlag=0";
        document.recordForm.submit();
    } else if (status === "1") {
        document.recordForm.action = "CServlet?action=getSideBySide";
        document.recordForm.submit();
    } else {
        alert(error);
    }
};


Record.reEnableButtons = function () {
    //add check to see if Phone Call was clicked before enabling all buttons during the Phone Logging step
    var checkPhoneCall = $('#PhoneCall').hasClass('disableInputButton');
    
    Record.enableButton('.recordButtons');
    //$('.recordButtons').prop('disabled', false).addClass('enableInputButton');
    
    if(checkPhoneCall){
        $('#PhoneCall').removeClass('enableInputButton');
        $('#PhoneCall').prop('disabled', true).addClass('disableInputButton');
    };
};

/********************* END: UPDATE METHODS *********************/








/********************* Retrieve QC Record List *********************/
Record.RetrieveList = function () {  
    document.recordForm.action = "CServlet?action=retrieveQCList";
    document.recordForm.submit();
};
/********************* END Retrieve QC Record List *********************/







/********************* Exit Screen *********************/
Record.ExitRecord = function ExitRecord() {
    Record.saveCorrInfo()
    .then(function (resp) {
        console.log("DONE saveCorrInfo Deferred");
        Record.closeMapWindow();
        document.recordForm.target = "";
        document.recordForm.action = "CServlet?action=ExitRecord";
        document.recordForm.submit();
    },
    function (resp) {
        console.log("FAIL saveCorrInfo Deferred");
        Record.enableButton('.recordButtons');
        //$('.recordButtons').prop('disabled', false).addClass('enableInputButton');
    });
};

/********************* END Exit Screen *********************/
