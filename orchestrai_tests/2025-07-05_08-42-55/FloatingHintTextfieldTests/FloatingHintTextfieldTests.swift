```swift
import XCTest
@testable import FloatingHintTextfield

class FloatingHintTextfieldTests: XCTestCase {
    
    var textField: FloatingHintTextfield!
    var mockDelegate: MockFloatingHintTextfieldDelegate!
    
    override func setUp() {
        super.setUp()
        textField = FloatingHintTextfield()
        mockDelegate = MockFloatingHintTextfieldDelegate()
        textField.floatingDelegate = mockDelegate
    }
    
    override func tearDown() {
        textField = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitWithFrame() {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        let textField = FloatingHintTextfield(frame: frame)
        
        XCTAssertEqual(textField.frame, frame)
        XCTAssertNotNil(textField.hintLabel)
        XCTAssertNotNil(textField.underlineView)
    }
    
    func testInitWithCoder() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.finishEncoding()
        
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
        let textField = FloatingHintTextfield(coder: unarchiver)
        
        XCTAssertNotNil(textField)
    }
    
    // MARK: - Hint Text Tests
    
    func testSetHintText() {
        let hintText = "Enter your name"
        textField.hintText = hintText
        
        XCTAssertEqual(textField.hintText, hintText)
        XCTAssertEqual(textField.hintLabel.text, hintText)
    }
    
    func testHintTextAnimation() {
        textField.hintText = "Test Hint"
        textField.text = ""
        
        // Test hint is in placeholder position when empty
        XCTAssertTrue(textField.hintLabel.transform.isIdentity)
        
        // Simulate text input
        textField.text = "Test"
        textField.textFieldDidBeginEditing(textField)
        
        // Allow animation to complete
        let expectation = self.expectation(description: "Animation completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            // Test hint is in floating position when text is present
            XCTAssertFalse(self.textField.hintLabel.transform.isIdentity)
        }
    }
    
    // MARK: - Color Tests
    
    func testHintColor() {
        let color = UIColor.blue
        textField.hintColor = color
        
        XCTAssertEqual(textField.hintColor, color)
        XCTAssertEqual(textField.hintLabel.textColor, color)
    }
    
    func testSelectedHintColor() {
        let color = UIColor.red
        textField.selectedHintColor = color
        
        XCTAssertEqual(textField.selectedHintColor, color)
    }
    
    func testUnderlineColor() {
        let color = UIColor.green
        textField.underlineColor = color
        
        XCTAssertEqual(textField.underlineColor, color)
        XCTAssertEqual(textField.underlineView.backgroundColor, color)
    }
    
    func testSelectedUnderlineColor() {
        let color = UIColor.purple
        textField.selectedUnderlineColor = color
        
        XCTAssertEqual(textField.selectedUnderlineColor, color)
    }
    
    // MARK: - Font Tests
    
    func testHintFont() {
        let font = UIFont.boldSystemFont(ofSize: 16)
        textField.hintFont = font
        
        XCTAssertEqual(textField.hintFont, font)
        XCTAssertEqual(textField.hintLabel.font, font)
    }
    
    // MARK: - Animation Tests
    
    func testAnimationDuration() {
        let duration: TimeInterval = 0.5
        textField.animationDuration = duration
        
        XCTAssertEqual(textField.animationDuration, duration)
    }
    
    func testBeginEditingAnimation() {
        textField.hintText = "Test"
        textField.text = ""
        
        textField.textFieldDidBeginEditing(textField)
        
        XCTAssertTrue(mockDelegate.didBeginEditingCalled)
        XCTAssertEqual(mockDelegate.lastTextField, textField)
    }
    
    func testEndEditingAnimation() {
        textField.hintText = "Test"
        textField.text = ""
        
        textField.textFieldDidEndEditing(textField)
        
        XCTAssertTrue(mockDelegate.didEndEditingCalled)
        XCTAssertEqual(mockDelegate.lastTextField, textField)
    }
    
    // MARK: - Text Change Tests
    
    func testTextDidChange() {
        textField.text = "New text"
        textField.textFieldDidChange(textField)
        
        XCTAssertTrue(mockDelegate.textDidChangeCalled)
        XCTAssertEqual(mockDelegate.lastTextField, textField)
    }
    
    func testShouldChangeCharacters() {
        let range = NSRange(location: 0, length: 0)
        let replacement = "a"
        
        let result = textField.textField(textField, shouldChangeCharactersIn: range, replacementString: replacement)
        
        XCTAssertTrue(result)
        XCTAssertTrue(mockDelegate.shouldChangeCharactersCalled)
    }
    
    // MARK: - Validation Tests
    
    func testIsValid() {
        textField.text = "valid@email.com"
        textField.validationType = .email
        
        XCTAssertTrue(textField.isValid)
    }
    
    func testIsInvalid() {
        textField.text = "invalid-email"
        textField.validationType = .email
        
        XCTAssertFalse(textField.isValid)
    }
    
    func testErrorState() {
        textField.showError = true
        textField.errorColor = UIColor.red
        
        XCTAssertTrue(textField.showError)
        XCTAssertEqual(textField.underlineView.backgroundColor, UIColor.red)
    }
    
    // MARK: - Accessibility Tests
    
    func testAccessibilityLabel() {
        textField.hintText = "Email Address"
        
        XCTAssertEqual(textField.accessibilityLabel, "Email Address")
        XCTAssertTrue(textField.isAccessibilityElement)
    }
    
    func testAccessibilityHint() {
        let hint = "Enter your email address"
        textField.accessibilityHint = hint
        
        XCTAssertEqual(textField.accessibilityHint, hint)
    }
    
    // MARK: - Layout Tests
    
    func testLayoutSubviews() {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        textField.frame = frame
        textField.layoutSubviews()
        
        XCTAssertTrue(textField.hintLabel.frame.width <= frame.width)
        XCTAssertTrue(textField.underlineView.frame.width == frame.width)
    }
    
    // MARK: - Edge Cases
    
    func testEmptyHintText() {
        textField.hintText = ""
        
        XCTAssertEqual(textField.hintText, "")
        XCTAssertEqual(textField.hintLabel.text, "")
    }
    
    func testNilHintText() {
        textField.hintText = nil
        
        XCTAssertNil(textField.hintText)
        XCTAssertNil(textField.hintLabel.text)
    }
    
    func testVeryLongHintText() {
        let longText = String(repeating: "Very long hint text ", count: 20)
        textField.hintText = longText
        
        XCTAssertEqual(textField.hintText, longText)
        XCTAssertEqual(textField.hintLabel.text, longText)
    }
    
    // MARK: - Performance Tests
    
    func testAnimationPerformance() {
        measure {
            for _ in 0..<100 {
                textField.textFieldDidBeginEditing(textField)
                textField.textFieldDidEndEditing(textField)
            }
        }
    }
}

// MARK: - Mock Delegate

class MockFloatingHintTextfieldDelegate: NSObject, FloatingHintTextfieldDelegate {
    var didBeginEditingCalled = false
    var didEndEditingCalled = false
    var textDidChangeCalled = false
    var shouldChangeCharactersCalled = false
    var lastTextField: FloatingHintTextfield?
    
    func floatingHintTextfieldDidBeginEditing(_ textField: FloatingHintTextfield) {
        didBeginEditingCalled = true
        lastTextField = textField
    }
    
    func floatingHintTextfieldDidEndEditing(_ textField: FloatingHintTextfield) {
        didEndEditingCalled = true
        lastTextField = textField
    }
    
    func floatingHintTextfieldTextDidChange(_ textField: FloatingHintTextfield) {
        textDidChangeCalled = true
        lastTextField = textField
    }
    
    func floatingHintTextfield(_ textField: FloatingHintTextfield, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        shouldChangeCharactersCalled = true
        lastTextField = textField
        return true
    }
}
```