```swift
import XCTest
@testable import FloatingHintTextfield

class FloatingHintTextfieldValidationTests: XCTestCase {
    
    var textField: FloatingHintTextfield!
    
    override func setUp() {
        super.setUp()
        textField = FloatingHintTextfield()
    }
    
    override func tearDown() {
        textField = nil
        super.tearDown()
    }
    
    // MARK: - Email Validation Tests
    
    func testValidEmailAddresses() {
        textField.validationType = .email
        
        let validEmails = [
            "test@example.com",
            "user.name@domain.co.uk",
            "user+tag@example.org",
            "123@example.com",
            "test.email.with+symbol@example.com"
        ]
        
        for email in validEmails {
            textField.text = email
            XCTAssertTrue(textField.isValid, "Email \(email) should be valid")
        }
    }
    
    func testInvalidEmailAddresses() {
        textField.validationType = .email
        
        let invalidEmails = [
            "invalid-email",
            "@example.com",
            "test@",
            "test..test@example.com",
            "test@example",
            ""
        ]
        
        for email in invalidEmails {
            textField.text = email
            XCTAssertFalse(textField.isValid, "Email \(email) should be invalid")
        }
    }
    
    // MARK: - Phone Number Validation Tests
    
    func testValidPhoneNumbers() {
        textField.validationType = .phoneNumber
        
        let validPhones = [
            "+1234567890",
            "123-456-7890",
            "(123) 456-7890",
            "123.456.7890",
            "1234567890"
        ]
        
        for phone in validPhones {
            textField.text = phone
            XCTAssertTrue(textField.isValid, "Phone \(phone) should be valid")
        }
    }
    
    func testInvalidPhoneNumbers() {
        textField.validationType = .phoneNumber
        
        let invalidPhones = [
            "123",
            "abc-def-ghij",
            "123-45-6789",
            "",
            "12345"
        ]
        
        for phone in invalidPhones {
            textField.text = phone
            XCTAssertFalse(textField.isValid, "Phone \(phone) should be invalid")
        }
    }
    
    // MARK: - Required Field Validation Tests
    
    func testRequiredFieldValidation() {
        textField.validationType = .required
        
        textField.text = ""
        XCTAssertFalse(textField.isValid)
        
        textField.text = "   "
        XCTAssertFalse(textField.isValid)
        
        textField.text = "Valid text"
        XCTAssertTrue(textField.isValid)
    }
    
    // MARK: - Custom Validation Tests
    
    func testCustomValidation() {
        textField.validationType = .custom
        textField.customValidationBlock = { text in
            return text?.count ?? 0 >= 5
        }
        
        textField.text = "1234"
        XCTAssertFalse(textField.isValid)
        
        textField.text = "12345"
        XCTAssertTrue(textField.isValid)
    }
    
    // MARK: - No Validation Tests
    
    func testNoValidation() {
        textField.validationType = .none
        
        textField.text = ""
        XCTAssertTrue(textField.isValid)
        
        textField.text = "any text"
        XCTAssertTrue(textField.isValid)
    }
    
    // MARK: - Validation State Tests
    
    func testValidationStateChanges() {
        textField.validationType = .email
        textField.errorColor = UIColor.red
        textField.underlineColor = UIColor.gray
        
        textField.text = "invalid"
        textField.validateText()
        
        XCTAssertTrue(textField.showError)
        XCTAssertEqual(textField.underlineView.backgroundColor, UIColor.red)
        
        textField.text = "valid@email.com"
        textField.validateText()
        
        XCTAssertFalse(textField.showError)
        XCTAssertEqual(textField.underlineView.backgroundColor, UIColor.gray)
    }
}
```