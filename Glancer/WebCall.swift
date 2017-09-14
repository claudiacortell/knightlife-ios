//
//  WebCall.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/13/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class WebCall
{
	let directory = "https://bbnknightlife.herokuapp.com/api/"
	let app: String!
	
	init(app: String)
	{
		self.app = app
	}
	
	private func buildRequest() -> URLRequest
	{
		let urlPath = self.directory + self.app
		let url = URL(string: urlPath)
		let request = URLRequest(url: url!)
		
		return request
	}
	
	func runAsync(callback: AsyncWebCallHandler)
	{
//		TODO: Implement this. It'll have to be soon and I probably should be doing them now but whatever idc
	}
	
	func idk()
	{
		request.httpBody = postString.data(using: .utf8)
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {                                                 // check for fundamental networking error
				print("error=\(error)")
				return
			}
			
			
			if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
				print("statusCode should be 200, but is \(httpStatus.statusCode)")
				print("response = \(response)")
				
			}
			
			let responseString = String(data: data, encoding: .utf8)
			print("responseString = \(responseString)")
			
		}
		task.resume()
	}
	
	func runSync() -> SynchronizedWebCallHandler
	{
		let request = self.buildRequest()
		
		var token = CallToken()
		token.connected = false
		token.url = request.url!.absoluteString
		
		var handler = SynchronizedWebCallHandler()
		
		do
		{
			let response = try NSURLConnection.sendSynchronousRequest(request, returning: nil) as Data
			let dictionary = setJsonDictionary(token: &token, response: response)
			
			handler.result = dictionary
		} catch let error as NSError
		{
			token.connected = false
			token.error = error.localizedDescription
		}
		
		handler.token = token
		return handler
	}
	
	private func setJsonDictionary(token: inout CallToken, response: Data) -> NSDictionary?
	{
		do
		{
			if let jsonResult = try JSONSerialization.jsonObject(with: response, options: []) as? NSDictionary
			{
				token.connected = true
				return jsonResult
			} else
			{
				token.connected = false
				token.error = "Unable to convert Data to Json object"
			}
		} catch let error as NSError
		{
			token.connected = false
			token.error = error.localizedDescription
		}
		return nil
	}
}

struct CallToken
{
//	Used to pass specifics about a web call to any applicable handlers. Add variables as you may need
	var url: String!
	var connected: Bool!
	var error: String?
}

protocol AsyncWebCallHandler
{
	func webCall(token: CallToken, results: NSDictionary?)
}

struct SynchronizedWebCallHandler
{
	var token: CallToken!
	var result: NSDictionary?
}
