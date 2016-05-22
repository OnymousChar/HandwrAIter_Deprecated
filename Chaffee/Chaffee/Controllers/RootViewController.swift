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
	
	private lazy var recognizer: G8Tesseract = {
		let recognizer = G8Tesseract(language: "eng")
		recognizer.pageSegmentationMode = .SingleChar
		
		return recognizer
	}()
	
	private lazy var background: UIImageView = {
		let image = UIImage(named: "bg")!
		let view = UIImageView(image: image)
		view.frame.size = self.view.frame.size
		return view
	}()
	
	private lazy var instructionView: UIImageView = {
		let image = UIImage(named: "input_top")
		let view = UIImageView(image: image)
		view.frame.origin = .zero
		return view
	}()
	
	private lazy var drawViewWindowView: UIImageView = {
		let image = UIImage(named: "input_window")
		let view = UIImageView(image: image)
		view.frame.origin = CGPoint(x: (self.view.frame.width - view.frame.width) / 2, y: 200)
		return view
	}()
	
	private lazy var willDrawView: DrawView = {
		let drawView = DrawView(frame: self.drawViewWindowView.frame.createInsideRect(withMargin: 20))
		drawView.backgroundColor = .clearColor()
		return drawView
	}()
	
	private lazy var submitButton: CallbackButton = {
		let image = UIImage(named: "input_btn01")
		let button = CallbackButton()
		button.setImage(image, forState: .Normal)
		button.frame.size = image?.size ?? .zero
		button.center.x = self.view.frame.width / 2
		button.frame.origin.y = 540
		button.setOnTapAction {
			self.outputStrokes()
//			self.recognizeText()
			self.resetStrokes()
//			self.setNextCharacter()
		}
		return button
	}()
	
	private lazy var resetButton: CallbackButton = {
		let image = UIImage(named: "input_btn02")
		let button = CallbackButton()
		button.setImage(image, forState: .Normal)
		button.frame.size = image?.size ?? .zero
		button.center.x = self.view.frame.width / 2
		button.frame.origin.y = 620
		button.setOnTapAction {
			self.resetStrokes()
		}
		return button
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		
		self.view.backgroundColor = .whiteColor()
		
		do {
			let background = self.background
			self.view.addSubview(background)
		}
		
		do {
			let label = self.instructionView
			self.view.addSubview(label)
		}
		
		do {
			let view = self.willDrawView
			self.view.addSubview(view)
		}
		
		do {
			let view = self.drawViewWindowView
			self.view.addSubview(view)
		}
		
		do {
			let button = self.resetButton
			self.view.addSubview(button)
		}
		
		do {
			let button = self.submitButton
			self.view.addSubview(button)
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
		let text = self.getRecognizeText()
		let strokes = self.willDrawView.getStrokes()
		let outputString = "{\"char\":\"\(text)\",\"data\":\(strokes)}"
		self.session.postString(outputString)
	}
	
	private func getRecognizeText() -> String {
		let currentImage = self.willDrawView.getImage()
		self.recognizer.image = currentImage
		self.recognizer.recognize()
		print(self.recognizer.recognizedText)
		return self.recognizer.recognizedText
	}
	
}
