//
//  DrawView.swift
//  Chaffee
//
//  Created by 史翔新 on 2016/05/21.
//  Copyright © 2016年 Crazism. All rights reserved.
//

import UIKit

class DrawView: UIView {
	
	private var willContext: WCMRenderingContext!
	private var viewLayer: WCMLayer!
	private var strokesLayer: WCMLayer!
	
	private var strokeRenderer: WCMStrokeRenderer!
	
	private var pathBuilder: WCMSpeedPathBuilder!
	private var pathStride: Int32!
	private var pathBrush: WCMStrokeBrush!
	
	private var pathSmoothener: WCMMultiChannelSmoothener!
	
	var strokes = [NSObject]()
	
	override init(frame: CGRect) {
		
		super.init(frame: frame)
		
		self.initWillContext()
		
		self.willContext.setTarget(self.strokesLayer)
		self.willContext.clearColor(.clearColor())
		
		self.refreshView(inRect: self.viewLayer.bounds)
		
		self.strokes = []
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func initWillContext() {
		self.contentScaleFactor = UIScreen.mainScreen().scale
		
		let eaglLayer = self.layer as! CAEAGLLayer
		eaglLayer.opaque = true
		eaglLayer.drawableProperties = [
			kEAGLDrawablePropertyRetainedBacking: true,
			kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8,
		]
		
		let eaglContext = EAGLContext(API: .OpenGLES2)
		
		self.willContext = WCMRenderingContext(EAGLContext: eaglContext)
		
		self.viewLayer = willContext.layerFromEAGLDrawable(self.layer as! EAGLDrawable, withScaleFactor: Float(self.contentScaleFactor))
		
		self.strokesLayer = willContext.layerWithWidth(Int32(self.viewLayer.bounds.size.width), andHeight: Int32(self.viewLayer.bounds.size.height), andScaleFactor: Int32(self.viewLayer.scaleFactor), andUseTextureStorage: true)
		
		self.pathBrush = self.willContext.solidColorBrush()
		
		self.pathBuilder = WCMSpeedPathBuilder()
		self.pathBuilder.setNormalizationConfigWithMinValue(0, andMaxValue: 7000)
		self.pathBuilder.setPropertyConfigWithName(.Width, andMinValue: 2, andMaxValue: 15, andInitialValue: .NaN, andFinalValue: .NaN, andFunction: .Power, andParameter: 1, andFlip: false)
		
		self.pathStride = self.pathBuilder.calculateStride()
		
		self.pathSmoothener = WCMMultiChannelSmoothener(channelsCount: self.pathStride)
		
		self.strokeRenderer =  self.willContext.strokeRendererWithSize(self.viewLayer.bounds.size, andScaleFactor: CGFloat(self.viewLayer.scaleFactor))
		
		self.strokeRenderer.brush = self.pathBrush
		self.strokeRenderer.stride = self.pathStride
		self.strokeRenderer.color = .blackColor()
	}
	
	private func refreshView(inRect rect: CGRect) {
		
		self.willContext.setTarget(self.viewLayer, andClipRect:rect)
		self.willContext.clearColor(.whiteColor())
		
		self.willContext.drawLayer(self.strokesLayer, withSourceRect: rect, andDestinationRect: rect, andBlendMode: .Normal)
		
		self.strokeRenderer.blendStrokeUpdatedAreaInLayer(viewLayer, withBlendMode: .Normal)
		
		self.viewLayer.present()
		
	}
	
}

extension DrawView {
	
	override class func layerClass() -> AnyClass {
		return CAEAGLLayer.self
	}
	
}
