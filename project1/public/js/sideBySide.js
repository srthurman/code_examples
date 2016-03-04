var SideBySide = {};

$(document).ready(function(){ 
    
//    var heightInfo = $("#maf").height() + $("#geocode").height() +$("#corrAdd").height()+$("#notes").height()+$("#phone").height();
//    console.log('hieght' + heightInfo);
//    $("#qcSide").height(heightInfo);
    $( "#manAccept" )
    .mouseover(function() {
        $("#manualBody").css('border','2px solid rgba(90, 120, 142, 1)');
        $("#qcBody").css('border','1px solid #aaaaaa');
    })
    .mouseout(function() {
        $("#manualBody").css('border','1px solid #aaaaaa');
        $("#qcBody").css('border','1px solid #aaaaaa');
    });
    
    $( "#qcAccept" )
    .mouseover(function() {
        $("#manualBody").css('border','1px solid #aaaaaa');
        $("#qcBody").css('border','2px solid rgba(90, 120, 142, 1)');
    })
    .mouseout(function() {
        $("#manualBody").css('border','1px solid #aaaaaa');
        $("#qcBody").css('border','1px solid #aaaaaa');
    });
    
    //resize dialog to center if window is resized
    $(window).resize(function(){
        $( "#dialogSideBySide" ).dialog( "option", "position", { my: "center", at: "center", of: window } );
    });


});
// setup the dialog
$("#dialogSideBySide").dialog( {
    autoOpen : false, modal : true, width : 1050, height : 800, closeOnEscape : false, draggable : false, resizable : true, 
    buttons :  [{
        id: "manAccept",
        text: 'Manual Accept',
        click: function () {
            SideBySide.compareAccept('0');
        }
    },
    {   
        id: "qcAccept",
        text: 'QC Accept',
        click: function () {
            SideBySide.compareAccept('1');
        }
    },
    {   
        id: "sbsContinue",
        text: 'Continue',
        click: function () {
            $(this).dialog('close');
        }
    }]
});

$(window).resize(function () {
    $("#dialogSideBySide").dialog("option", "position", "center");
});

SideBySide.Open = function () {
    $("#dialogSideBySide").dialog('open');
};
SideBySide.PhoneCall = function () {
    SideBySide.Open();
    $('#qcAccept').prop('disabled', true).addClass('disableInputButton');
    
    $( "#qcAccept" )
    .mouseover(function() { 
        $("#qcBody").css('border','1px solid #aaaaaa');
    })
};

SideBySide.compareAccept = function(errorFlag) {
    console.log("SideBySide.compareAccept - calling updateQueueTable QC, errorFlag: " + errorFlag);
    document.recordForm.action = "CS?action=updateQueueTableQC&errorFlag=" + errorFlag;
    document.recordForm.submit();
};