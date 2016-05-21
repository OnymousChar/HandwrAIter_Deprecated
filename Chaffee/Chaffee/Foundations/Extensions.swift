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
