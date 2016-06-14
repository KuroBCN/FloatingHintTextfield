//
//  FloatingHintTextField.swift
//  floatingTextInput
//
//  Created by Pereiro, Delfin on 28/12/15.
//  Copyright © 2015 Pereiro, Delfin. All rights reserved.
//

import UIKit

let kAnimationTimeInterval : NSTimeInterval = 0.3
let kDefaultFloatingScale : CGFloat = 0.7

public class FloatingHintTextField: UITextField {

    private var floatingLabel = CATextLayer()
    public var floatingLabelColor : UIColor?
    public var placeholderColor = UIColor.init(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
    public var animationDuration = kAnimationTimeInterval
    public var floatingLabelFont : UIFont? {
        didSet{
            scale = floatingLabelActiveFont().pointSize / self.font!.pointSize
            floatingLabel.font = UIFont(name: self.floatingLabelFont!.fontName,
                                        size: self.font!.pointSize)
            self.setNeedsDisplay()
        }
    }
    private var scale : CGFloat = kDefaultFloatingScale
    private var topInset : CGFloat = 0
    
    /// We can't get editing text frame from inside clearButtonRectForBounds method
    /// without causing an infinite loop (editingRectForBounds and any other similar
    /// methods call clearButtonRectForBounds under the hood) so we store it for
    /// a proper clear button positioning
    private var editingTextBounds = CGRectNull
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override public var placeholder: String? {
        didSet {
            self.floatingLabel.string = placeholder
            super.placeholder = nil
        }
    }
    
    override public var frame: CGRect {
        didSet {
            super.frame = frame
            self.commonInit()
        }
    }
    
    public convenience init(){
        self.init(frame: CGRectZero)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    
//    MARK:  - Private methods
    private func commonInit() {

        // Get original placeholder color
        var range = NSMakeRange(0, 0)        
        let color = super.attributedPlaceholder?.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: &range)
        if let color = color as? UIColor {
            placeholderColor = color
        }
        
        // Set floating text string and removes real placeholder
        placeholder = super.placeholder
        
        // calculate top inset
        if self.font != nil {
            topInset = floor(super.editingRectForBounds(self.bounds).height-self.font!.lineHeight)
        }
        editingTextBounds = editingRectForBounds(self.bounds)
        
        // Position floating label
        floatingLabel.anchorPoint = CGPoint(x: 0, y: 0)
        floatingLabel.frame = editingTextBounds
        floatingLabel.contentsScale = UIScreen.mainScreen().scale
        floatingLabel.font = floatingLabelActiveFont()
        floatingLabel.fontSize = floatingLabelActiveFont().pointSize
        floatingLabel.foregroundColor = placeholderColor.CGColor
        self.layer.addSublayer(floatingLabel)
        
        self.adjustsFontSizeToFitWidth = false
        self.contentVerticalAlignment = UIControlContentVerticalAlignment.Top
    }
    
    private func floatingLabelActiveColor()->UIColor {
        
        if let color = floatingLabelColor {
            return color
        }else if self.respondsToSelector(Selector("tintColor")) {
            return self.tintColor
        }
        return UIColor.blueColor()
    }
    
    private func floatingLabelActiveFont()->UIFont {
        
        if let font =  floatingLabelFont {
            return font
        } else if let font = self.font {
            return font
        }
        return UIFont.systemFontOfSize(12)
    }
    
    private func moveUpFloatingText() {
        CATransaction.begin()
        CATransaction.setValue(animationDuration, forKey: kCATransactionAnimationDuration)
        let transformation = CATransform3DScale(CATransform3DIdentity, self.scale, self.scale, 1);
        self.floatingLabel.transform = transformation
        var frame2 = self.floatingLabel.frame
        frame2.origin.y = 2         // top margin
        self.floatingLabel.frame = frame2
        self.floatingLabel.foregroundColor = self.floatingLabelActiveColor().CGColor

//        self.floatingLabel.font =  self.floatingLabelActiveFont()
        CATransaction.commit()
    }
    
    private func moveDownFloatingText() {

        var textFrame = textRectForBounds(self.frame)
        textFrame.origin.x = textFrame.origin.x - self.frame.origin.x
        textFrame.origin.y = textFrame.origin.y - self.frame.origin.y
        
        CATransaction.begin()
        CATransaction.setValue(animationDuration, forKey: kCATransactionAnimationDuration)
        self.floatingLabel.transform = CATransform3DIdentity
//        self.floatingLabel.font = UIFont.systemFontOfSize(15)
        self.floatingLabel.foregroundColor = placeholderColor.CGColor
        self.floatingLabel.frame = textFrame
        CATransaction.commit()
    }
    
    func insetRectForBounds(rect : CGRect) -> CGRect {
        var newRect = rect
        newRect.origin.y += topInset
        newRect.size.height -= topInset
        return newRect
    }
    
//    MARK: - UITextField Methods
    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        var rect = super.editingRectForBounds(bounds)
        rect = insetRectForBounds(rect)
        return CGRectIntegral(rect)
    }
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        var rect = super.textRectForBounds(bounds)
        rect = insetRectForBounds(rect)
        return CGRectIntegral(rect)
    }
    
    override public func clearButtonRectForBounds(bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRectForBounds(bounds)
        let correction = (editingTextBounds.height-rect.height)/2.0
        rect.origin.y = editingTextBounds.origin.y + correction
        return CGRectIntegral(rect)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if self.text?.characters.count == 0 {
            moveDownFloatingText()
        } else {
            moveUpFloatingText()
        }
    }
}
