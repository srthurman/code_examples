( function( $ ) {             
                
$("#tblAddrRes").on("click", "tr", function () {
    var state = $(this).hasClass('highlighted');
    
    
    if ( ! state) { 
        CommonRec.clearOtherHighlight("addr"); 
        $('.highlighted').removeClass('highlighted');
        $(this).addClass('highlighted'); 
        
        //Grabbing Data from selected Row
        var tblAddrResData = $(this).children("td").map(function() {
            return $(this).text();
        }).get();
        $("#selAddrRow").val($.trim(tblAddrResData[4]) + ":" + $.trim(tblAddrResData[5]) +":" + $.trim(tblAddrResData[6]));        
        //Storing the data to a input field for 'Accept' record later
        var houseNumber = tblAddrResData[0];
        var unitNo = tblAddrResData[1];
        var streetName = tblAddrResData[2];
        var zipCode = tblAddrResData[3];
        var mafId = tblAddrResData[4];
        var oIdAd = tblAddrResData[5];
        var matchMuOId = tblAddrResData[6];
        
        $('#selResults').val("Address Selected: "+ houseNumber+" "+unitNo+" "+streetName+", "+zipCode+" @"+mafId+" ");
        $('#selCodedTypeAndData').val("Address:"+mafId+":"+oIdAd+":"+matchMuOId);    
        
        
         
               
    }
    
    
});

} )( jQuery );