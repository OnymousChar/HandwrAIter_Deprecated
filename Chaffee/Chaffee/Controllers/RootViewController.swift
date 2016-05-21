//
//  RootViewController.swift
//  Chaffee
//
//  Created by 史翔新 on 2016/05/22.
//  Copyright © 2016年 Crazism. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
	
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
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 10)), dispatch_get_main_queue()) {
			self.willDrawView.outputStrokes()
			print("Cleared")
		}
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}
