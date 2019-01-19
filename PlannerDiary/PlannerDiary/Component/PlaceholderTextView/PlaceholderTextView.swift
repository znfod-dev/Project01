//
//  PlaceholderTextView.swift
//  PlannerDiary
//
//  Created by 김삼현 on 05/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit

private let kPlaceholderTextViewInsetSpan: CGFloat = 8

@IBDesignable class PlaceholderTextView: UITextView {
	// variables
	
	/** The string that will be put in the placeholder */
	@IBInspectable var placeholder: NSString? {
		didSet {
			setNeedsDisplay()
		}
	}
	
	/** color for the placeholder text. Default is UIColor.lightGrayColor() */
	@IBInspectable var placeholderColor: UIColor = UIColor.lightGray

	/** Initializes the placeholder text view, waiting for a notification of text changed */
	func listenForTextChangedNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(PlaceholderTextView.textChangedForPlaceholderTextView(_:)), name:UITextView.textDidChangeNotification , object: self)
		
		NotificationCenter.default.addObserver(self, selector: #selector(PlaceholderTextView.textChangedForPlaceholderTextView(_:)), name:UITextView.textDidBeginEditingNotification , object: self)
	}
	
	/** willMoveToWindow will get called with a nil argument when the window is about to dissapear */
	override func willMove(toWindow newWindow: UIWindow?) {
		super.willMove(toWindow: newWindow)
		if newWindow == nil {
			NotificationCenter.default.removeObserver(self)
		}
		else {
			listenForTextChangedNotifications()
		}
	}
	
	// MARK: - Adjusting placeholder.
	@objc func textChangedForPlaceholderTextView(_ notification: Notification) {
		setNeedsDisplay()
		setNeedsLayout()
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
		// in case we don't have a text, put the placeholder (if any)
		if text.count == 0 && self.placeholder != nil {
			let baseRect = placeholderBoundsContainedIn(self.bounds)
			let font = self.font ?? self.typingAttributes[NSAttributedString.Key.font] as? UIFont ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
			
			self.placeholderColor.set()
			
			// build the custom paragraph style for our placeholder text
			var customParagraphStyle: NSMutableParagraphStyle!
			if let defaultParagraphStyle =  typingAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle {
				customParagraphStyle = defaultParagraphStyle.mutableCopy() as? NSMutableParagraphStyle
			}
			else {
				customParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
			}
			
			// set attributes
			customParagraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
			customParagraphStyle.alignment = self.textAlignment
			let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: customParagraphStyle.copy() as! NSParagraphStyle, NSAttributedString.Key.foregroundColor: self.placeholderColor]
			// draw in rect.
			self.placeholder?.draw(in: baseRect, withAttributes: attributes)
		}
	}
	
	func placeholderBoundsContainedIn(_ containerBounds: CGRect) -> CGRect {
		// get the base rect with content insets.
		let baseRect = containerBounds.inset(by: UIEdgeInsets(top: kPlaceholderTextViewInsetSpan, left: kPlaceholderTextViewInsetSpan/2.0, bottom: 0, right: 0))
		
		// adjust typing and selection attributes
		if let paragraphStyle = typingAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle {
			baseRect.offsetBy(dx: paragraphStyle.headIndent, dy: paragraphStyle.firstLineHeadIndent)
		}
		
		return baseRect
	}
}
