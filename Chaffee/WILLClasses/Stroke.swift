//
//  Stroke.swift
//  Chaffee
//
//  Created by 史翔新 on 2016/05/21.
//  Copyright © 2016年 Crazism. All rights reserved.
//

import UIKit

class Stroke: NSObject {
	
	var width: Float
	var color: UIColor
	var stride: Int32
	var ts, tf: Float
	var blendMode: WCMBlendMode
	
	private(set) var points: WCMFloatVector
	
	init(points: WCMFloatVector, andStride stride: Int32, andWidth width: Float, andColor color: UIColor, andTs ts: Float, andTf tf: Float, andBlendMode blendMode: WCMBlendMode) {
		
		self.stride = stride
		self.width = width
		self.color = color
		self.ts = ts
		self.tf = tf
		self.blendMode = blendMode
		
		self.points = points
		
		super.init()
		
	}
	
}

extension Stroke {
	
	override var description: String {
		let pointsObjectInfo = self.points.pointer().description
		let pointsInfo = "\"points\":\(pointsObjectInfo.arrayInfoString)"
		let strideInfo = "\"stride\":\(self.stride.description)"
		let pathInfo = "\"path\":{\(pointsInfo),\(strideInfo)}"
		let widthInfo = "\"width\":\(self.width.description)"
		let colorObjectInfo = self.color.rgbaInfo
		let colorInfo = "\"color\":\(colorObjectInfo)"
		let tsInfo = "\"ts\":\(self.ts.description)"
		let tfInfo = "\"tf\":\(self.tf.description)"
		let blendModeInfo = "\"blendMode\":\(self.blendMode.rawValue.description)"
		
		let description = "{\(pathInfo), \(widthInfo), \(colorInfo), \(tsInfo), \(tfInfo), \(blendModeInfo)}"
		return description
	}
	
}

private extension String {
	
	var arrayInfoString: String {
		guard let startIndex = self.rangeOfString("(")?.endIndex, endIndex = self.rangeOfString(")")?.startIndex else {
			return self
		}
		
		let arrayContent = self.substringWithRange(Range(startIndex ..< endIndex))
		return "[\(arrayContent)]"
	}
	
}

private extension UIColor {
	
	var rgbaInfo: String {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		
		self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		
		let hexRed = Int(red * CGFloat(UInt8.max))
		let hexGreen = Int(green * CGFloat(UInt8.max))
		let hexBlue = Int(blue * CGFloat(UInt8.max))
		let intAlpha = 1
		
		return "{\"red\":\(hexRed), \"green\":\(hexGreen), \"blue\":\(hexBlue), \"alpha\":\(intAlpha)}"
	}
	
}
