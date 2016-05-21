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
