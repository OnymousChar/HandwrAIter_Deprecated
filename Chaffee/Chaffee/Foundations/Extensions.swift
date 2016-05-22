//
//  Extensions.swift
//  Chaffee
//
//  Created by 史翔新 on 2016/05/21.
//  Copyright © 2016年 Crazism. All rights reserved.
//

import Foundation

extension CGFloat {
	static func createRandomValue(withLimit limit: CGFloat = 1) -> CGFloat {
		let randomUInt = arc4random_uniform(UInt32.max)
		let randomCGFloat = CGFloat(randomUInt) / CGFloat(UInt32.max)
		let randomValue = randomCGFloat * limit
		return randomValue
	}
}

extension String {
	var first: String? {
		if let firstCharacter = self.characters.first {
			return String(firstCharacter)
			
		} else {
			return nil
		}
	}
}

extension CGRect {
	
	func createInsideRect(withMargin margin: CGFloat) -> CGRect {
		let insets = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
		return self.createInsideRect(withInsets: insets)
	}
	
	func createInsideRect(withInsets insets: UIEdgeInsets) -> CGRect {
		let newRect = CGRect(x: self.origin.x + insets.left, y: self.origin.y + insets.top, width: self.size.width - insets.left - insets.right, height: self.size.height - insets.top - insets.bottom)
		return newRect
	}
	
}
