var RangeResults1 = {};

    $('#oddValues').prop('checked','checked');
    $('#selParity').val($('input[name=Parity]:checked').val());
    
/// Click Handlers    
$("#tblResult1").on("click", "tr", function () {
        CommonRec.clearOtherHighlight("rng");
        var state = $(this).hasClass('highlighted');
        
        if ( ! state) { 
            $('.highlighted').removeClass('highlighted');
            $(this).addClass('highlighted'); 
         
        //Grabbing Data from selected Row
        var tblResult1Data = $(this).children("td").map(function() {
            return $(this).text();
        }).get();
        var streetName=tblResult1Data[0];
        var zipCode=tblResult1Data[1];
        var parity=tblResult1Data[2];
        $('#selDisplayName').val(streetName);
        $('#selArZip').val(zipCode);                 
        $('#selRow').val(parity);        
        $('#selParity').val($('input[name=Parity]:checked').val()); 
        
        
        //alert("Your Range1 data is: " + $('#selDisplayName').val() + " , " + $('#selArZip').val() +" , " + $('#selParity').val());
        }else{
            $('#selDisplayName').val(null);
            $('#selArZip').val(null);                 
            $('#selRow').val(null); 
        }
        
    });               
        
     
    $("[name='Parity']").click(function(){
        $("[name='Parity']").removeAttr("checked");
        $(this).attr({"checked":true}).prop({"checked":true});
        $('#selParity').val($('input[name=Parity]:checked').val());
        //alert("Your click: " + $('#selDisplayName').val() + " , " + $('#selArZip').val() +" , " + $('#selParity').val());
    });   
    
$('#displayRange').click(RangeResults1.AddrRangeList);
    

RangeResults1.Rehighlight = function Rehighlight() {
    
    //Adds highlight back to the row that was selected
    $('#tblResult1 tr').eq($('#selRow').val()).addClass('highlighted');
    //regrabbing the values of the existing highlight row
    var tblResult1Data = $('#tblResult1 tr.highlighted').children("td").map(function() {
            return $(this).text();
        }).get();
    $('#selDisplayName').val(tblResult1Data[0]);
    $('#selArZip').val(tblResult1Data[1]);
};

RangeResults1.AddrRangeList = function AddrRangeList() {
var selDisplayName = $("#selDisplayName").val(); 
var selArZip = $("#selArZip").val(); 
var selParity = $('#selParity').val();
var selRow = $('#selRow').val();
var stateHighlight = $("#tblResult1 tr").hasClass('highlighted');
//alert("Your click: " + $('#selDisplayName').val() + " , " + $('#selArZip').val() +" , " + $('#selParity').val() + " , " + $('#selRow').val());

  if (stateHighlight==false || selDisplayName == null || selDisplayName.length == 0) {
      alert("Please select a Street Name to display Ranges.");
      return false;
  }
  else {
    $.ajax( {
        url : 'CS?action=AddrRangeList', 
        type : 'POST', 
        dataType : 'html', 
        data : {selDisplayName : selDisplayName, selArZip : selArZip, selParity : selParity, selRow: selRow},
        success : function (data) {
            $("#resultGroup").html(data);                    
            $("#resultGroup").show();
            
            $('#rangeResult1').removeClass('active');
            $('#rangeResult1').addClass('hide');                                            
            //show target tab content
            $('#rangeResult2').removeClass('hide');
            $('#rangeResult2').addClass('active');
            
            $('#addressTab').removeClass('active');
            $('#addressTab').addClass('hide'); 
             $('#addrLi').removeClass('active');
             $('#addrLi').addClass('hide');
            $('#rangeTab').removeClass('hide');
            $('#rangeTab').addClass('active');  
            $('#rangeLi').removeClass('hide');
            $('#rangeLi').addClass('active');
        },
        error: function() {
          alert("An error occurred in Address Range Search. Please check the log files.");
          return false;
        }
    });   

    return true;
  }
};
