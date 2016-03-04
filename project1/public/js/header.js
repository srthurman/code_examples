var xyzHeader = {};

xyzHeader.loggedOut = false;

xyzHeader.logout = function (logoutType){
    console.log('logout clicked');
    
    console.log(logoutType);
    
    if (typeof logoutType === 'undefined') {
        logoutType = 'logout';
    };
    console.log(logoutType);
    
    if (logoutType === "timeout" || (logoutType === "logout" && confirm("Are you sure you want to log out?"))){
        console.log("proceed with logout");
        xyzHeader.loggedOut = true;
    
        var currScreen = xyzHeader.currScreen;
        currScreen = $("#xyzScreen").text();
        console.log('Screen: '+ currScreen);
        if (currScreen == "Record"){
            Record.closeMapWindow();
        };
        
        //check if the session is still valid
        xyzHeader.sessionCheck()        
            //wait for response from sessionCheck function
            .then(
                //call if sessionCheck was successful. Return another promise.
                function(resp) {return xyzHeader.sessionCheckSuccess(resp,currScreen)},
                //call if sessionCheck failed
                function(resp) {xyzHeader.sessionCheckFail(resp)}
            )
            //wait for response from success function above
            .then(
                function(resp) {
                    console.log("close window/redirect to timeout page");
//                    xyzHeader.closeWindow();
                    if (logoutType !== "logout") {
                        window.open('jsp/xyz_ErrorPage.jsp?errorMessage=Session has expired.', '_blank', ''); 
                    };
                     xyzHeader.closeWindow();
                }
            );    
    };
    
};


/**
 * this function makes an ajax call to the either the CS or Login Servlet
 * in order to remove the session variables and then invalidate the session
 * cache false is used to force the log out by not letting the page cache.
 */
xyzHeader.closeSession = function(currScreen){
    //Check what the current screen is, if Records page then save work
    var logoutUrl = "";
    if (currScreen == "Record"){ 
        logoutUrl = "CS?action=logout";
    } else {
        logoutUrl = "loginProcess?action=logout";
    }
    
    return $.ajax({
            type : "GET", dataType : "html", url : logoutUrl, cache: false
    });
};

/**
 * this function makes an ajax call to the CS in order to determine
 * if the session is still active. cache false is used to force the log out by not
 * letting the page cache.
 */
xyzHeader.sessionCheck = function(){
    return $.ajax({
        type : "GET", dataType : "html", url : "CS?action=sessionCheck", cache: false
    });
};

xyzHeader.sessionCheckSuccess = function(sessionCheckResults, currScreen){
    console.log("sessionCheckSuccess");
    var deferred = $.Deferred();
    console.log('Session Check: ' + sessionCheckResults);
    if (sessionCheckResults == 'Success'){
        console.log('Session active close the session');
        
        //for the record screen, a save of corrected info must be done before logging out
        if (currScreen == "Record"){
            console.log("closing record page");
            
//            Record.closeMapWindow();
            //save the corrected info
            $.when(Record.saveCorrInfo())
                .done(function(resp){
                    
                    //now remove the session variables and invalidate the session
                    xyzHeader.closeSession(currScreen)
                    .then(
                        function(logoutResults){
                            console.log('Logout Results: ' + logoutResults);
                            deferred.resolve();
                         },
                         function(resp){
                            console.log('Failed to close session variables and session 2');
                            deferred.resolve();
                        }
                    );
                })
                .fail(function(resp) {
                    console.log("Failed to save corrected info");
                    return;
                });
        }
        //not on record screen just remove session vairables and invalidate session
        else{
            console.log("closing non-record page");
            //remove the session variables and invalidate the session
            xyzHeader.closeSession(currScreen).then(
                function(logoutResults){
                    console.log('Logout Results: ' + logoutResults);
                    deferred.resolve();
                    //xyzHeader.closeWindow();
                },
                function(resp){
                    console.log('Failed to close session variables and session 1');
                    deferred.resolve();
                    //xyzHeader.closeWindow();
                }
            );
        }
    }
    else{
        console.log('Session not active, just close the browser');
        deferred.resolve();
        //xyzHeader.closeWindow();
    };
    
    return deferred.promise();
}
        
xyzHeader.sessionCheckFail = function(resp){
    console.log('Failed checking session');
    console.log('Close the browser');
    xyzHeader.closeWindow();
}

xyzHeader.closeWindow = function() {
    
    //try to remove the credentials from the cache
    try {
        document.execCommand("ClearAuthenticationCache");
    } catch (exception) {}
    
    //in any borwser excluding firefox, open the current window throught javascript so it can be closed
    try{
        window.open('', '_self', '');
        window.close();
    }
    catch(e){}
};