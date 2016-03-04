var expect = chai.expect;
var should = chai.should();


describe("Sample test", function() {
	it("should be true", function() {
		expect(1).to.equal(1);
	});
});

describe("Account Request", function() {
	describe("validateForm function", function() {
        beforeEach(function() {
            var html='<input class="required" type="text" id="input1"/> <input class="required" type="text" id="input2"/> <input class="" type="text" id="input3"/>' 
            $('body').append(html);
        });
        
        it("should return true if all required fields are filled.", function() {
            $("#input1").val("Text");
            $("#input2").val("Text");
            var reqFieldsFilled = AccountRequest.validateForm();
            expect(reqFieldsFilled).to.equal(true);
        });
        
        it("should return false if not all required fields are filled.", function() {
            $("#input1").val("Text");
            var reqFieldsFilled = AccountRequest.validateForm();
            expect(reqFieldsFilled).to.equal(false);
        });
                
        afterEach(function() {
            $("input").remove();
        });
        
    });
});