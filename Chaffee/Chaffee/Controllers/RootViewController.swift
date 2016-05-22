//
//  RootViewController.swift
//  Chaffee
//
//  Created by 史翔新 on 2016/05/22.
//  Copyright © 2016年 Crazism. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
	
	private lazy var session: ServerSession = {
		let session = ServerSession()
		return session
	}()
	
	private lazy var titleLabel: UILabel = {
		let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
		let labelFrame = CGRect(x: 0, y: statusBarHeight, width: self.view.frame.width, height: 30)
		let label = UILabel(frame: labelFrame)
		label.text = "「あ」を書いてください"
		return label
	}()
	
	private lazy var willDrawView: DrawView = {
		let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
		let currentBounds = self.view.bounds
		let squareLength = min(currentBounds.width, currentBounds.height)
		let squareSize = CGSize(width: squareLength, height: squareLength)
		let drawViewPosition = CGPoint(x: (currentBounds.width - squareLength) / 2, y: statusBarHeight + self.titleLabel.frame.height)
		let drawViewFrame = CGRect(origin: drawViewPosition, size: squareSize)
		let drawView = DrawView(frame: drawViewFrame)
		
		return drawView
	}()
	
	private lazy var toolbar: UIView = {
		let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
		let viewFrame = CGRect(x: 0, y: statusBarHeight + self.titleLabel.frame.height + self.willDrawView.frame.height, width: self.view.frame.width, height: 40)
		let view = UIView(frame: viewFrame)
		return view
	}()
	
	private lazy var resetButton: CallbackButton = {
		let buttonSize = CGSize(width: self.toolbar.frame.width / 2, height: self.toolbar.frame.height)
		let buttonOrigin = CGPoint.zero
		let button = CallbackButton(frame: CGRect(origin: buttonOrigin, size: buttonSize))
		button.setTitle("リセット", forState: .Normal)
		button.setTitleColor(.blackColor(), forState: .Normal)
		button.setOnTapAction {
			self.resetStrokes()
		}
		return button
	}()
	
	private lazy var submitButton: CallbackButton = {
		let buttonSize = CGSize(width: self.toolbar.frame.width / 2, height: self.toolbar.frame.height)
		let buttonOrigin = CGPoint(x: self.toolbar.frame.width - buttonSize.width, y: 0)
		let button = CallbackButton(frame: CGRect(origin: buttonOrigin, size: buttonSize))
		button.setTitle("決定", forState: .Normal)
		button.setTitleColor(.blackColor(), forState: .Normal)
		button.setOnTapAction {
			self.outputStrokes()
			self.resetStrokes()
		}
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		
		self.view.backgroundColor = .whiteColor()
		
		do {
			let label = self.titleLabel
			self.view.addSubview(label)
		}
		
		do {
			let view = self.willDrawView
			view.layer.borderWidth = 1
			view.layer.borderColor = UIColor.redColor().CGColor
			self.view.addSubview(view)
		}
		
		do {
			let view = self.toolbar
			self.view.addSubview(view)
			
			do {
				let button = self.resetButton
				view.addSubview(button)
			}
			
			do {
				let button = self.submitButton
				view.addSubview(button)
			}
			
		}
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}

extension RootViewController {
	
	private func resetStrokes() {
		self.willDrawView.clearStrokes()
	}
	
	private func outputStrokes() {
		let strokes = self.willDrawView.getStrokes()
		let text = "あ"
		let outputString = "{\"char\":\"\(text)\",\"data\":\(strokes)}"
		self.session.postString(outputString)
	}
	
}
