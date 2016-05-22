//
//  DrawView.swift
//  Chaffee
//
//  Created by 史翔新 on 2016/05/21.
//  Copyright © 2016年 Crazism. All rights reserved.
//

import UIKit

class DrawView: UIView {
	
	override class func layerClass() -> AnyClass {
		return CAEAGLLayer.self
	}
	
	private var willContext: WCMRenderingContext!
	private var viewLayer: WCMLayer!
	private var strokesLayer: WCMLayer!
	
	private var strokeRenderer: WCMStrokeRenderer!
	
	private var pathBuilder: WCMSpeedPathBuilder!
	private var pathStride: Int32!
	private var pathBrush: WCMStrokeBrush!
	
	private var pathSmoothener: WCMMultiChannelSmoothener!
	
	var strokes = [Stroke]()

	override init(frame: CGRect) {
		
		super.init(frame: frame)
		
		self.initWillContext()
		
		self.willContext.setTarget(self.strokesLayer)
		self.willContext.clearColor(.clearColor())
		
		self.refreshViewInRect(self.viewLayer.bounds)
		
		self.strokes = []
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension DrawView {
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.processTouches(touches, withEvent: event)
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.processTouches(touches, withEvent: event)
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.processTouches(touches, withEvent: event)
	}
	
	override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		self.processTouches(touches, withEvent: event)
	}
	
}

extension DrawView {

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
	
	private func refreshViewInRect(rect: CGRect) {
		
		self.willContext.setTarget(self.viewLayer, andClipRect:rect)
		self.willContext.clearColor(.whiteColor())
		
		self.willContext.drawLayer(self.strokesLayer, withSourceRect: rect, andDestinationRect: rect, andBlendMode: .Normal)
		
		self.strokeRenderer.blendStrokeUpdatedAreaInLayer(viewLayer, withBlendMode: .Normal)
		
		self.viewLayer.present()
		
	}
	
	private func processTouches(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		guard let touch = touches?.first else {
			return
		}
		
		let location = touch.locationInView(self)
		let wcmInputPhase: WCMInputPhase
		switch touch.phase {
		case .Began:
			wcmInputPhase = .Begin
			
			self.pathSmoothener.reset()
			
			self.strokeRenderer.color = UIColor(red: .createRandomValue(), green: .createRandomValue(), blue: .createRandomValue(), alpha:0.5)
			self.strokeRenderer.resetAndClearBuffers()
			
		case .Moved:
			wcmInputPhase = .Move
			
		case .Ended, .Cancelled:
			wcmInputPhase = .End
			
		case .Stationary:
			return
		}
		
		let points = self.pathBuilder.addPointWithPhase(wcmInputPhase, andX: Float(location.x), andY: Float(location.y), andTimestamp: touch.timestamp)
		let smoothedPoints = self.pathSmoothener.smoothValues(points, reachFinalValues: wcmInputPhase == .End)
		let pathAppendResult = self.pathBuilder.addPathPart(smoothedPoints)
		
		let prelimPoints = self.pathBuilder.createPreliminaryPath()
		let smoothedPrelimPoints = self.pathSmoothener.smoothValues(prelimPoints, reachFinalValues: true)
		let prelimPath = self.pathBuilder.finishPreliminaryPath(smoothedPrelimPoints)
		
		self.strokeRenderer.drawPoints(pathAppendResult.addedPath, finishStroke: wcmInputPhase == .End)
		self.strokeRenderer.drawPreliminaryPoints(prelimPath)

		if wcmInputPhase == .End {
			self.strokeRenderer.blendStrokeInLayer(strokesLayer, withBlendMode: .Normal)
			
			let stroke = Stroke(points: WCMFloatVector(begin: pathAppendResult.wholePath.begin(),
													  andEnd: pathAppendResult.wholePath.end()),
							 andStride: self.pathStride,
							  andWidth: .NaN,
							  andColor: self.strokeRenderer.color,
								 andTs: 0,
								 andTf: 1,
						  andBlendMode: .Normal)
			self.strokes.append(stroke)
		}
		
		self.refreshViewInRect(self.strokeRenderer.updatedArea)
		
	}
	
	private func redrawStrokes() {
		
		self.willContext.setTarget(self.strokesLayer)
		self.willContext.clearColor(.clearColor())
		
		let renderer = self.willContext.strokeRendererWithSize(self.viewLayer.bounds.size, andScaleFactor:CGFloat(self.viewLayer.scaleFactor))
		renderer.brush = self.pathBrush;
		
		for s in self.strokes {
			renderer.stride = s.stride;
			renderer.width = s.width;
			renderer.color = s.color;
			renderer.ts = s.ts;
			renderer.tf = s.tf;
			
			renderer.resetAndClearBuffers()
			renderer.drawPoints(s.points.pointer(), finishStroke: true)
			renderer.blendStrokeInLayer(self.strokesLayer, withBlendMode: s.blendMode)
		}
		
		self.refreshViewInRect(self.viewLayer.bounds)
		
	}
	
}

extension DrawView {
	
	func getStrokes() -> String {
		let outputElements = self.strokes.map { (stroke) -> String in
			return stroke.description
		}.joinWithSeparator(",\n")
		let output = "[\(outputElements)]"
		return output
	}
	
	func clearStrokes() {
		self.strokes.removeAll()
		self.redrawStrokes()
	}
	
}
