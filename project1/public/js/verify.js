//***** DEPENDENCIES *****//
/*
* common_record.js - CommonRec
* jQuery 2.1.4
*/

var Verify = {};

/****************** Event Handlers ******************/
$("#Exit").click(function() { Verify.ExitRecord(); });
$("#VerifyBtn").click(function() { Verify.verifyRecord(); });
/****************** END Event Handlers ******************/









/********************* Verify Record *********************/
Verify.verifyRecord = function () {
    alert("Verify record clicked!");
};
/********************* END Verify Record *********************/









/********************* Exit Screen *********************/
Verify.ExitRecord = function () {
    console.log("exit record");
    CommonRec.closeMapWindow();
    document.recordForm.target = "";
    document.recordForm.action = "VerificationServlet?action=ExitRecord";
    document.recordForm.submit();
};
/********************* END Exit Screen *********************/