var RangeResults2 = {};

( function( $ ) {                 
    $("#tblResult2").on("click", "tr", function () {
//        CommonRec.clearOtherHighlight("rng"); 
        var state = $(this).hasClass('highlighted');  
        //highlighting function         
        if ( ! state) { 
            $('.highlighted').removeClass('highlighted');  
            $(this).addClass('highlighted'); 
            
            //Get the values clicked for the row, two tables
            var tblResult2StZip = $('.streetName').children("td").map(function() {
                return $(this).text();
            }).get();
            var tblResult2Data = $(this).children("td").map(function() {
                return $(this).text();            
            }).get();  
            var streetName=tblResult2StZip[0];
            var zipCode=tblResult2StZip[1];
            var parity=tblResult2Data[0];
            var from=tblResult2Data[1];
            var to=tblResult2Data[2];
            var OidAr=tblResult2Data[3];
            CommonRec.clearOtherHighlight("rng"); 
            $('#selResults').val("Range Selected: "+streetName+", "+zipCode+" "+parity+": "+from+" - "+to+" ");
            //Storing values from rows for later use
            $('#selCodedTypeAndData').val("Range:"+OidAr); 
        
        }
        
          
    });

RangeResults2.AddrRangeReturn = function AddrRangeReturn() {

    $('#rangeResult2').removeClass('active');
    $('#rangeResult2').addClass('hide');                                            
    //show target tab content
    $('#rangeResult1').removeClass('hide');
    $('#rangeResult1').addClass('active');
    $('#rangeLi').addClass('active');
    //Call function from rangeResults1 to rehighlight the previous table
    RangeResults1.Rehighlight();
    CommonRec.clearOtherHighlight("rng");
};

} )( jQuery );