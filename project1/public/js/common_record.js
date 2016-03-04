//Sara
//***** DEPENDENCIES *****//
/*
* map.js - xyzMap
* jQuery 2.1.4
*/

var CommonRec = {};

/****************** Namespace Variables ******************/
CommonRec.mapWindowObject = null;
CommonRec.recordWindowObject = null;

//case insensitve regular expression for use in removing prefix/suffix from address when copied using >> button
CommonRec.regexpPrefixString = "^(((n\\.*|s\\.*|e\\.*|w\\.*|ne\\.*|nw\\.*|se\\.*|sw\\.*|north|south|east|west)\\s+){0,1})";
CommonRec.regexpSuffixString = "(\\s+(dr\\.*|drive|ct\\.*|court|way|rd\\.*|road|ave\\.*|avenue|st\\.*|street|blvd\\.*|cir\\.*|circle)\\s*)$";
/****************** END Namespace Variables ******************/









/****************** Event Handlers ******************/
$("#exportAddrBtn").click(function() { CommonRec.exportAddrInfo(); });

$("#showMapBtn").click(function() { CommonRec.showMapButton(); });
$("#addrSearchBtn").click(function() { CommonRec.addressSearch(); });
$("#resetSearchBtn").click(function() { CommonRec.resetSearch(); });
/****************** END Event Handlers ******************/







/****************** Utility functions ******************/
CommonRec.enableButton = function(btnClass) {
    $(btnClass).prop('disabled', false).addClass('enableButton');
};

$('#overlay-item, #overlay-back').hide();//-monki

//**// pressing [enter] key will trigger [search] submit
$('.searchTextarea').keypress(function (event) {
    var keycode = (event.keyCode ? event.keyCode : event.which);
    if (event.which == '13') {
        CommonRec.addressSearch();
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
CommonRec.validateNumber = function (e) {
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
CommonRec.exportAddrInfo = function () {
    $("#selHn").val($("#corrHn").val());
    $('#selZip').val($("#corrZipCode").val());

    //create a regexp object using regexp variable and remove prefix
    var re = new RegExp(CommonRec.regexpPrefixString, "i");
    var streetToChop = $("#corrStreetName").val().replace(re, "");
    //create a regexp object using regexp variable and remove prefix
    re = new RegExp(CommonRec.regexpSuffixString, "i");
    streetToChop = streetToChop.replace(re, "");
    //send the updated street name to the search street
    if (typeof (streetToChop) != 'undefined' && streetToChop != null && streetToChop.trim() != '') {
        $('#selStreetName').val(streetToChop.trim());
    }
    else {
        $('#selStreetName').val($("#corrStreetName").val());
    }
};

CommonRec.resetSearch = function () {
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









/****************** Map Window ******************/
if (!CommonRec.recordWindowObject) {
    CommonRec.recordWindowObject = window.self;
};

CommonRec.showMapButton = function () {
    if (!CommonRec.checkMapOpen()) {
        //CommonRec.mapWindowObject = window.open("CS?action=showMap", "xyzMap", "height=800,width=1200");
        CommonRec.showMap();
    }
};

CommonRec.closeMapWindow = function () {
    if (CommonRec.checkMapOpen()) {
        CommonRec.mapWindowObject.close();
    };
};

CommonRec.showMap = function () {
    CommonRec.mapWindowObject = window.open("CS?action=showMap", "xyzMap", "resizable=1,height=800,width=900");
};

CommonRec.checkMapOpen = function () {
    //alert('checking map status');   
    if (!CommonRec.mapWindowObject || CommonRec.mapWindowObject.closed) {
        return false
    };
    return true;
};

//**// Called from Map Window
CommonRec.clearOtherHighlight = function (src) {
    //clearing the selected data values first
    $('#selResults').val("");
    $('#selCodedTypeAndData').val("");

    //clear the highlights
    if (src === "addr") {
        $('#tblResult1 tr, #tblResult2 tr').removeClass('highlighted');
        $("#selDisplayName").val("");
        $("#selArZip").val("");
        if (CommonRec.mapWindowObject && !CommonRec.mapWindowObject.closed) {
            CommonRec.mapWindowObject.xyzMap.clearHighlight();
            CommonRec.mapWindowObject.xyzMap.clearHighlightMapList();
        }
    }
    if (src === "rng") {
        $('#tblAddrRes tr').removeClass('highlighted');
        if (CommonRec.mapWindowObject && !CommonRec.mapWindowObject.closed) {
            CommonRec.mapWindowObject.xyzMap.clearHighlight();
            CommonRec.mapWindowObject.xyzMap.clearHighlightMapList();
        }
    }
    else if (src === "map") {
        $('#tblAddrRes tr, #tblResult1 tr, #tblResult2 tr').removeClass('highlighted');
        $("#selDisplayName").val("");
        $("#selArZip").val("");
    }

};
/****************** END Map Window ******************/









/****************** Address Search ******************/

CommonRec.addressSearch = function () {

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
        url : 'CS?action=AddressSearch', type : 'POST', dataType : 'html', data :  {
            selHn : selHn, selStreet : selStreet, selIntStreet : selIntStreet, selZip : selZip, selSt : selSt, selCou : selCou, selBlock : selBlock, selTract : selTract
        },
        success : function (data) {
            $("#resultGroup").html(data);
            $("#resultGroup").show();
            //check if map is open
            if (CommonRec.checkMapOpen()) {
                //map open; reload
                CommonRec.mapWindowObject.location.reload();
            }
            else {
                //show map
                CommonRec.showMap();
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