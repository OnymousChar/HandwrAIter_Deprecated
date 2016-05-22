//
//  ServerSession.swift
//  Chaffee
//
//  Created by 史翔新 on 2016/05/22.
//  Copyright © 2016年 Crazism. All rights reserved.
//

import UIKit

class ServerSession: NSObject {
	
	private let session: NSURLSession
	private let request: NSMutableURLRequest
	
	override init() {
		
		let urlString = "http://52.193.93.208:4567/add"
		let url = NSURL(string: urlString)!
		let session = NSURLSession(configuration: .defaultSessionConfiguration())
		let request = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30)
		request.HTTPMethod = "POST"
		self.session = session
		self.request = request
		
		super.init()
		
	}
	
	func postString(string: String) {
		print(string)
		let data = string.dataUsingEncoding(NSUTF8StringEncoding)!
		self.request.HTTPBody = data
		let task = self.session.dataTaskWithRequest(self.request)
		task.resume()
	}
	
}
