
        <!-- dialog window markup -->
        <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/sessionTimer.css"/>
        
        <div id="dialog" title="Your session is about to expire!"  style="display: none;">
            <p>
                <span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 50px 0;"></span>
                 You will be logged off in <span id="dialog-countdown" style="font-weight:bold"></span> seconds.
            </p>
            <p>Do you want to continue your session?</p>
        </div>
        
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.idletimer.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.idletimeout.js"></script>
        <script type="text/javascript">
        var IdleTimer = {};       
        
          // setup the dialog
          $("#dialog").dialog( {
              autoOpen : false, modal : true, width : 400, height : 200, 
              closeOnEscape : false, draggable : false, resizable : false, 
              buttons :  {
                  'Yes, Keep Working' : function () {
                      $(this).dialog('close');
                  }
              }
          });
          // cache a reference to the countdown element so we don't have to query the DOM for it on each ping.
          var $countdown = $("#dialog-countdown");
          // IdleTime 14 minutes and polling every 4 minutes
          $.idleTimeout('#dialog', 'div.ui-dialog-buttonpane button:first', {
              idleAfter : 840, 
              pollingInterval : 240, 
              //the following two times are for testing only
//              idleAfter: 5,
//              pollingInterval: 3,
              keepAliveURL :'cs?action=sessionCheck', 
              serverResponseEquals : 'Success', 
              onTimeout : function () {
                    xyzHeader.logout("timeout");
//                    window.location = "jsp/xyz_ErrorPage.jsp?errorMessage=Session has expired.";
              },
              onIdle : function () {
                  $(this).dialog("open");
              },
              onCountdown : function (counter) {
                  $countdown.html(counter);// update the counter
              }
          });
        </script>
        
        