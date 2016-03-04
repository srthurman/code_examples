var QCList = {
};
$(document).ready(function(){ 
     $(function() {        
        var custIdSel = $("#queueCustId").val();
        var queueQACycleSel = $("#queueQACycle").val();
        var queueBundleIdSel = $("#queueBundleId").val();
     
        if($("#failRec").val() > 0){
            var redHighlight = 'rgba(249, 138, 138, 1)';
            $("#failRec").css('background',redHighlight,'color','black');            
        };
        
//        if($("#passRec").val() > 0){
//            var greenHighlight = 'rgba(184, 245, 184, 1)'
//            $("#passRec").css('background',greenHighlight);
//        };
        
        $("#QCListTable").on('filterEnd', function () {          
         }).tablesorter({
            widthFixed: false,
            sortList: [[0,0]],
            emptyTo: 'bottom',
            widgets: [ 'default', 'white', 'filter', 'scroller' ],
            widgetOptions : {
              scroller_height : 450,
              scroller_barWidth : 19          
            }
        }); 
        if( !($('tbody#tblQCListBody').hasClass('highlighted'))){
                
                $('table tr').each(function(){
                    if($(this).find('td').eq(0).text() == custIdSel){
                        $(this).addClass('highlighted');
                        
                        var dataQC = custIdSel+":"+queueQACycleSel+":"+queueBundleIdSel;
                        console.log("Pre-selected: "+dataQC);
                        $("#selQCRow").val(dataQC);
                    }
                });                
        }
        
        $('tbody#tblQCListBody').on('click', 'tr.RecordRow', function () {
        var highlight = $(this).hasClass('highlighted');    
    
            if ( ! highlight) { 
                $('.highlighted').removeClass('highlighted');
                $(this).addClass('highlighted'); 
                
                //Grabbing Data from selected Row
                var tblQCListData = $(this).children("td").map(function() {
                    return $(this).text();
                }).get();       
                //Storing the data to a input field for 'Accept' record later
                var custId = tblQCListData[0];
                var houseNo = tblQCListData[1];
                var streetName = tblQCListData[2];
                var unitNo = tblQCListData[3];
                var timeZone = tblQCListData[4];   
                var state = tblQCListData[5];
                var zip = tblQCListData[6];
                
            //    var dataQC = "\n"+custId+":"+houseNo+":"+streetName+":"+unitNo+":"+timeZone+":"+state+":"+zip;
                    var dataQC = custId+":"+queueQACycleSel+":"+queueBundleIdSel;
                console.log(dataQC);
                $("#selQCRow").val(dataQC);
            }
        
        });
        
    
   });     
    
});

QCList.Select = function (){
    document.QCListForm.action = "CS?action=retQCRec";
    document.QCListForm.submit();
}