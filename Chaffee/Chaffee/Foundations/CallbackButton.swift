//
//  CallbackButton.swift
//  Chaffee
//
//  Created by 史翔新 on 2016/05/22.
//  Copyright © 2016年 Crazism. All rights reserved.
//

import UIKit

class CallbackButton: UIButton {
	
	private var onTapAction: (() -> Void)?
	
	override func didMoveToSuperview() {
		self.addTarget(self, action: #selector(CallbackButton.onTap), forControlEvents: .TouchUpInside)
	}
	
	func setOnTapAction(action: (() -> Void)?) {
		self.onTapAction = action
	}
	
	func onTap() {
		self.onTapAction?()
	}
	
}
