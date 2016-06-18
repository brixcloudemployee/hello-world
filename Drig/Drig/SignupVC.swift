import UIKit

class SignupVC: UIViewController {
	
	var txtName: UITextField!
	var txtPass: UITextField!
	
	enum JSONError: String, ErrorType {
		case NoData = "ERROR: no data"
		case ConversionFailed = "ERROR: conversion from JSON failed"
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.lightGrayColor()
		
		//data_request()
		//signup()
		//login()
		
		prepareUI()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Methods
	func prepareUI() {
		txtName = UITextField(frame: CGRectMake(10,
			50,
			200,
			35))
		txtName.borderStyle = .RoundedRect
		txtName.backgroundColor = UIColor.whiteColor()
		self.view.addSubview(txtName)
		
		txtPass = UITextField(frame: CGRectMake(txtName.frame.origin.x,
			txtName.frame.origin.y + txtName.frame.size.height + 10,
			txtName.frame.size.width,
			txtName.frame.size.height))
		txtPass.borderStyle = .RoundedRect
		txtPass.backgroundColor = UIColor.whiteColor()
		self.view.addSubview(txtPass)
		
		let btnRegister = UIButton(type: .System)
		btnRegister.frame = CGRectMake(txtPass.frame.origin.x,
		                            txtPass.frame.origin.y + txtPass.frame.size.height + 15,
		                            100,
		                            35)
		btnRegister.backgroundColor = UIColor.whiteColor()
		btnRegister.setTitle("Register", forState: .Normal)
		self.view.addSubview(btnRegister)
		
		let btnCancel = UIButton(type: .System)
		btnCancel.frame = CGRectMake(btnRegister.frame.origin.x,
		                             btnRegister.frame.origin.y + btnRegister.frame.size.height + 15,
		                             btnRegister.frame.size.width,
		                             btnRegister.frame.size.height)
		btnCancel.backgroundColor = UIColor.whiteColor()
		btnCancel.setTitle("Sign Up", forState: .Normal)
		btnCancel.addTarget(self, action: #selector(goBack), forControlEvents: .TouchUpInside)
		self.view.addSubview(btnCancel)
	}
	
	
	// MARK: - Navigation
	func goBack() {
		self.navigationController?.popViewControllerAnimated(false)
	}
	
	
	// signup
	func signup() {
		//let strURL = "http://beacons.drigmethods.com/signup?email=a@a.com&password=a"
		let strURL = "http://beacons.drigmethods.com/signup"
		
		let url:NSURL = NSURL(string: strURL)!
		let session = NSURLSession.sharedSession()
		
		let request = NSMutableURLRequest(URL: url)
		request.HTTPMethod = "POST"
		request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
		
		let paramString = "email=c@c.com&password=c"
		request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
		
		let task = session.dataTaskWithRequest(request) {(
			let data, let response, let error) in
			
			guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
				print("error")
				return
			}
			let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
			print(dataString)
		}
		task.resume()
	}
	
	// login
	func login() {
		let strURL = "http://beacons.drigmethods.com/login?email=a@a.com&password=a"
		
		let url:NSURL = NSURL(string: strURL)!
		let session = NSURLSession.sharedSession()
		
		let request = NSMutableURLRequest(URL: url)
		request.HTTPMethod = "POST"
		request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
		
		//        let paramString = "data=Hello"
		//        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
		
		let task = session.dataTaskWithRequest(request) {(
			let data, let response, let error) in
			
			guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
				print("error")
				return
			}
			let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
			print(dataString)
		}
		task.resume()
	}
	
	// beacon
	func data_request() {
		let strURL = "http://beacons.drigmethods.com/displaypromotion?email=wengrodrigo@yahoo.com&uuid=fda50693a4e24fb1afcfc6eb07647825&min=1&max=710"
		
		let url:NSURL = NSURL(string: strURL)!
		let session = NSURLSession.sharedSession()
		
		let request = NSMutableURLRequest(URL: url)
		request.HTTPMethod = "POST"
		request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
		
		//        let paramString = "data=Hello"
		//        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
		
		let task = session.dataTaskWithRequest(request) {(
			let data, let response, let error) in
			
			//            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
			//                print("error")
			//                return
			//            }
			//            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
			//            print(dataString)
			
			do {
				guard let data = data else {
					throw JSONError.NoData
				}
				guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
					throw JSONError.ConversionFailed
				}
				print(json)
				self.displayReturn(json)
			} catch let error as JSONError {
				print(error.rawValue)
			} catch let error as NSError {
				print(error.debugDescription)
			}
			
		}
		task.resume()
	}
	
	func displayReturn(response: NSDictionary) {
		if let imageURL = response["imageUrl"] {
			print(imageURL)
		}
		
		if let user = response["user"] {
			if let email = user["email"] {
				print(email!)
			}
		}
	}
}