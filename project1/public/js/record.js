//Sara
//***** DEPENDENCIES *****//
/*
* common_record.js - CommonRec
* jQuery 2.1.4
*/

var Record = {};

/****************** Event Handlers ******************/
$("#saveCorrInfoBtn").click(function() { Record.saveCorrInfo(); });

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

$('#container_rounded').on('click', '#Accept', function() { Record.UpdateRecord('Accept'); });
$('#container_rounded').on('click', '#Uncodable', function() { Record.UpdateRecord('Uncodable'); });
$('#container_rounded').on('click', '#Refer', function() { Record.UpdateRecord('Refer'); });
$('#container_rounded').on('click', '#Retrieve', function() { Record.RetrieveList(); });

$('#container_rounded').on('click', '#PhoneCallBtn', function() { Record.PhoneCall(); });

$('#container_rounded').on('click', '#Exit', function() { Record.ExitRecord(); });
/****************** END Event Handlers ******************/









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
    console.log("Phone logging function", updType);
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
        promise.resolve('true');
    }
    return promise.promise();

};

Record.PhoneCall = function () {
    $('#PhoneCall').prop('disabled', true).addClass('disableInputButton');
    SideBySide.PhoneCall();
    $.ajax({type : "POST", url : "CS?action=QCPhoneCall"});
};
/****************** END Phone Call Dialog ******************/











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
        type : "POST", url : "CS?action=saveCorrInfo", data : $('#recordForm').serialize() + "&phoneCallRecord=" + phoneCallRecord
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









/********************* UPDATE METHODS *********************/
Record.UpdateRecord = function (updType) {
    console.log("update record");
    console.trace();
    var updRec = Record.UpdateRecordConfirm(updType);

    if ($("#qaCycle").val() === "2") {
        Record.checkManualStatus()
        .then(
            function(resp) { Record.updateRecordQC(resp, updRec, updType); }
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
        console.trace();
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
            return $.ajax( { type : "POST", url : "CS?action=Record" + updType, data : postData } );
        },
        function () {
            CommonRec.enableButton('.recordButtons');
            //$('.recordButtons').prop('disabled', false).addClass('enableButton');
        }
    )
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
            document.recordForm.action = "ControlServlet?action=getNewRecord&qaCycle=" + qaCycle;
            document.recordForm.submit();
        } else {
            console.log("updateComp resolve");
            CommonRec.enableButton('.recordButtons');
            //$('.recordButtons').prop('disabled', false).addClass('enableButton');
            defObj.resolve();
            
        }
    }
    else {
        alert(message);
        CommonRec.enableButton('.recordButtons');
        //$('.recordButtons').prop('disabled', false).addClass('enableButton');
    }
};


Record.checkManualStatus = function() {
    return $.ajax({type : "POST", url : "CS?action=checkManualStatus"});
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
	    document.recordForm.action = "CS?action=updateQueueTableQC&errorFlag=1";
	    document.recordForm.submit();
    };
};


Record.compareQCRecord = function() {
    return $.ajax({type : "POST", url : "CS?action=compareQCRecords"});
};


Record.compareQCRecordResponse = function(resp) {
    console.log("compareQCRecordResponse");
    var iSplit = resp.split(':');
    var status = iSplit[0];
    var error = iSplit[1];
    if (status === "0") {
        console.log("Record.compareQCRecord - calling updateQueueTable QC, errorFlag: 0");
        document.recordForm.action = "CS?action=updateQueueTableQC&errorFlag=0";
        document.recordForm.submit();
    } else if (status === "1") {
        document.recordForm.action = "CS?action=getSideBySide";
        document.recordForm.submit();
    } else {
        alert(error);
    }
};


Record.reEnableButtons = function () {
    //add check to see if Phone Call was clicked before enabling all buttons during the Phone Logging step
    var checkPhoneCall = $('#PhoneCall').hasClass('disableInputButton');
    
    CommonRec.enableButton('.recordButtons');
    //$('.recordButtons').prop('disabled', false).addClass('enableButton');
    
    if(checkPhoneCall){
        $('#PhoneCall').removeClass('enableButton');
        $('#PhoneCall').prop('disabled', true).addClass('disableInputButton');
    };
};

/********************* END: UPDATE METHODS *********************/








/********************* Retrieve QC Record List *********************/
Record.RetrieveList = function () {  
    document.recordForm.action = "CS?action=retrieveQCList";
    document.recordForm.submit();
};
/********************* END Retrieve QC Record List *********************/







/********************* Exit Screen *********************/
Record.ExitRecord = function ExitRecord() {
    console.log("exit record");
    Record.saveCorrInfo()
    .then(function (resp) {
        console.log("DONE saveCorrInfo Deferred");
        CommonRec.closeMapWindow();
        document.recordForm.target = "";
        document.recordForm.action = "CS?action=ExitRecord";
        document.recordForm.submit();
    },
    function (resp) {
        console.log("FAIL saveCorrInfo Deferred");
        CommonRec.enableButton('.recordButtons');
        //$('.recordButtons').prop('disabled', false).addClass('enableButton');
    });
};

/********************* END Exit Screen *********************/
