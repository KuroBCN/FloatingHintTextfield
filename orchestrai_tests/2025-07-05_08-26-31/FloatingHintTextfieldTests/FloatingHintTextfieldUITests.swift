```swift
import XCTest
@testable import FloatingHintTextfield

class FloatingHintTextfieldUITests: XCTestCase {
    
    var textField: FloatingHintTextfield!
    var containerView: UIView!
    
    override func setUp() {
        super.setUp()
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        textField = FloatingHintTextfield(frame: CGRect(x: 20, y: 20, width: 260, height: 60))
        containerView.addSubview(textField)
    }
    
    override func tearDown() {
        textField = nil
        containerView = nil
        super.tearDown()
    }
    
    // MARK: - Visual State Tests
    
    func testInitialVisualState() {
        textField.hintText = "Enter text"
        textField.layoutIfNeeded()
        
        XCTAssertEqual(textField.hintLabel.alpha, 1.0)
        XCTAssertTrue(textField.hintLabel.frame.origin.y > textField.frame.height / 2)
        XCTAssertEqual(textField.underlineView.alpha, 1.0)
    }
    
    func testFloatingVisualState() {
        textField.hintText = "Enter text"
        textField.text = "Sample text"
        
        let expectation = self.expectation(description: "Floating animation")
        
        textField.animateHintLabel(toFloatingState: true) {
            XCTAssertTrue(self.textField.hintLabel.frame.origin.y < 20)
            XCTAssertEqual(self.textField.hintLabel.alpha, 1.0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testErrorVisualState() {
        textField.hintText = "Enter text"
        textField.showError(message: "This field is required")
        
        XCTAssertEqual(textField.underlineView.backgroundColor, textField.errorColor)
        XCTAssertTrue(textField.errorLabel.alpha > 0)
        XCTAssertEqual(textField.errorLabel.text, "This field is required")
    }
    
    // MARK: - Animation Tests
    
    func testHintLabelAnimationToFloating() {
        textField.hintText = "Test Animation"
        let initialY = textField.hintLabel.frame.origin.y
        
        let expectation = self.expectation(description: "Animation to floating")
        
        textField.animateHintLabel(toFloatingState: true) {
            XCTAssertTrue(self.textField.hintLabel.frame.origin.y < initialY)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testHintLabelAnimationToNormal() {
        textField.hintText = "Test Animation"
        textField.text = "Some text"
        textField.animateHintLabel(toFloatingState: true) { }
        
        let expectation = self.expectation(description: "Animation to normal")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.textField.animateHintLabel(toFloatingState: false) {
                XCTAssertTrue(self.textField.hintLabel.frame.origin.y > 20)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testUnderlineAnimationOnFocus() {
        textField.hintText =