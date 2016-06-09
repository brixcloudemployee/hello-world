import UIKit

class SigninVC: ViewController {
	
	// MARK: - Propertiess
	var scrollView: UIScrollView!
	var txtEM: UITextField!
	var txtPW: UITextField!
	
	
	// MARK: - View
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		prepareUI()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onKeyboardHide), name: UIKeyboardWillHideNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onKeyboardShow), name: UIKeyboardWillShowNotification, object: nil)
		
		gotoSignup()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	// MARK: - Methods
	func prepareUI() {
		self.viewHeader.hidden = true
		self.imgvBG.image = UIImage(named: "Signin-BG")
		
		scrollView = UIScrollView(frame: CGRectMake(0,
			0,
			Constants.Size.SCREEN_WIDTH,
			Constants.Size.SCREEN_HEIGHT))
		self.view.addSubview(scrollView)
		
		let imgvAvon = UIImageView(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.20,
			0,
//			self.viewHeader.frame.size.height,
			Constants.Size.SCREEN_WIDTH * 0.60,
			Constants.Size.SCREEN_HEIGHT * 0.15))
		imgvAvon.image = UIImage(named: "Signin-Avon")
		imgvAvon.contentMode = .ScaleAspectFit
		scrollView.addSubview(imgvAvon)
		
		
		let imgvSteps = UIImageView(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.10,
			imgvAvon.frame.origin.y + imgvAvon.frame.size.height,
			Constants.Size.SCREEN_WIDTH * 0.80,
			Constants.Size.SCREEN_HEIGHT * 0.40))
		imgvSteps.image = UIImage(named: "Signin-130")
		imgvSteps.contentMode = .ScaleAspectFit
		scrollView.addSubview(imgvSteps)
		
		
		txtEM = UITextField(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.10,
			imgvSteps.frame.origin.y + imgvSteps.frame.size.height + 20,
			Constants.Size.SCREEN_WIDTH * 0.80,
			40))
		txtEM.borderStyle = .RoundedRect
		txtEM.placeholder = "Email"
		scrollView.addSubview(txtEM)
		
		txtPW = UITextField(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.10,
			txtEM.frame.origin.y + txtEM.frame.size.height + 10,
			Constants.Size.SCREEN_WIDTH * 0.80,
			40))
		txtPW.borderStyle = .RoundedRect
		txtPW.placeholder = "Password"
		scrollView.addSubview(txtPW)
		
		let btnSignin = UIButton(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.10,
			txtPW.frame.origin.y + txtPW.frame.size.height + 10,
			Constants.Size.SCREEN_WIDTH * 0.80,
			40))
		btnSignin.setBackgroundImage(UIImage(named: "Signin-Button"), forState: .Normal)
		btnSignin.setTitle("Sign In", forState: .Normal)
		btnSignin.addTarget(self, action: #selector(attemptSignin), forControlEvents: .TouchUpInside)
		scrollView.addSubview(btnSignin)
		
		let btnSignup = UIButton(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.10,
			btnSignin.frame.origin.y + btnSignin.frame.size.height + 10,
			Constants.Size.SCREEN_WIDTH * 0.80,
			40))
		btnSignup.imageView?.contentMode = .ScaleAspectFit
		btnSignup.setBackgroundImage(UIImage(named: "Signin-Button"), forState: .Normal)
		btnSignup.setTitle("Sign Up", forState: .Normal)
		btnSignup.addTarget(self, action: #selector(gotoSignup), forControlEvents: .TouchUpInside)
		scrollView.addSubview(btnSignup)
		
		scrollView.contentSize = CGSizeMake(Constants.Size.SCREEN_WIDTH, btnSignup.frame.origin.y + btnSignup.frame.size.height + 10)
	}
	
	
	// MARK: - SIGNIN
	func attemptSignin() {
		if txtEM.text?.isEmpty == true {
			UIAlertController.showMessage(self, title: "Sign In Failed", message: "Please enter your email address")
			return
		}
		
		if txtEM.text?.isEmail() == false {
			UIAlertController.showMessage(self, title: "Sign In Failed", message: "Please enter a valid email address")
			return
		}
		
		if txtPW.text?.isEmpty == true {
			UIAlertController.showMessage(self, title: "Sign In Failed", message: "Please enter password")
			return
		}
		
		signinUser()
	}
	
	func signinUser() {
		print("signinUser")
		BFLoader.sharedInstance.showLoader(self.view)
		
		let strURL = "https://avonmillionsteps.herokuapp.com/api/users/sign_in"
		
		let url:NSURL = NSURL(string: strURL)!
		let session = NSURLSession.sharedSession()
		
		let request = NSMutableURLRequest(URL: url)
		request.HTTPMethod = "POST"
		request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
		request.timeoutInterval = 30
		
		let paramString = "email=\(txtEM.text!)&password=\(txtPW.text!)&provider=email"
		request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
		
		let task = session.dataTaskWithRequest(request) {(
			let data, let response, let error) in
			BFLoader.sharedInstance.hideLoader(self.view)
			
			do {
				guard let data = data else {
					throw JSONError.NoData
				}
				guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
					throw JSONError.ConversionFailed
				}
				
				dispatch_async(dispatch_get_main_queue()) {
					print("0 \(json)")
					self.parseJSON(json)
				}
				
			} catch let error as JSONError {
				dispatch_async(dispatch_get_main_queue()) {
					print("1" + error.rawValue)
					UIAlertController.showMessage(self, title: "Failed", message: error.rawValue)
				}
			} catch let error as NSError {
				dispatch_async(dispatch_get_main_queue()) {
					print("2" + error.debugDescription)
					UIAlertController.showMessage(self, title: "Failed", message: error.debugDescription)
				}
			}
		}
		task.resume()
	}
	
	
	// MARK: _ PARSER
	func parseJSON(response: NSDictionary) {
		// TODO -
		// parse return
		// save token, name, email, user_id
		
		//		{
		//			"access_token" = 250f5c4ed4dd5038f57eeb5e30001413;
		//			"display_name" = "Optional(\"Izanagi\")";
		//			email = "optional(\"iza@nami.com\")";
		//			"first_name" = "Optional(\"Izanagi\")";
		//			"last_name" = "Optional(\"Izanami\")";
		//			provider = email;
		//			"social_id" = "";
		//			"social_name" = "";
		//			"user_id" = 12;
		//		}
		
		gotoMain()
	}


	// MARK: - Navigation
	func gotoSignup() {
		self.navigationController?.pushViewController(SignupVC(), animated: false)
	}

	func gotoMain() {
		self.navigationController?.pushViewController(MainVC(), animated: false)
	}

	
	// MARK: - Keyboard
	func onKeyboardHide() {
		var rectScroll = scrollView.frame
		rectScroll.size.height = Constants.Size.SCREEN_HEIGHT
		scrollView.frame = rectScroll
	}
	
	func onKeyboardShow() {
		var rectScroll = scrollView.frame
		rectScroll.size.height = Constants.Size.SCREEN_HEIGHT - Constants.Size.KEYBOARD_HEIGHT
		scrollView.frame = rectScroll
	}
}