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
	
	private init(points: WCMFloatVector, width: Float, color: UIColor, stride: Int32, ts: Float, tf: Float, blendMode: WCMBlendMode) {
		
		self.width = width
		self.color = color
		self.stride = stride
		self.ts = ts
		self.tf = tf
		self.blendMode = blendMode
		
		self.points = points
		
		super.init()
		
	}
	
	static func strokeWithPoints(points: WCMFloatVector, andStride stride: Int32, andWidth width: Float, andColor color: UIColor, andTs ts: Float, andTf tf: Float, andBlendMode blendMode: WCMBlendMode) -> Stroke {
		return Stroke(points: points, width: width, color: color, stride: stride, ts: ts, tf: tf, blendMode: blendMode)
	}
	
}
