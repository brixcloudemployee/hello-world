import UIKit

class LoginVC: ViewController {
	
	
	// MARK: - View
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		prepareUI()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	// MARK: - Methods
	func prepareUI() {
		
		let imgvAvon = UIImageView(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.20,
			self.viewHeader.frame.size.height,
			Constants.Size.SCREEN_WIDTH * 0.60,
			Constants.Size.SCREEN_HEIGHT * 0.15))
				imgvAvon.image = UIImage(named: "Login-Avon")
		imgvAvon.contentMode = .ScaleAspectFit
		self.view.addSubview(imgvAvon)
		
		
		let imgvSteps = UIImageView(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.10,
			imgvAvon.frame.origin.y + imgvAvon.frame.size.height,
			Constants.Size.SCREEN_WIDTH * 0.80,
			Constants.Size.SCREEN_HEIGHT * 0.40))
		imgvSteps.image = UIImage(named: "Login-130")
		imgvSteps.contentMode = .ScaleAspectFit
		self.view.addSubview(imgvSteps)

		
		let btnFB = UIButton(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.25,
			imgvSteps.frame.origin.y + imgvSteps.frame.size.height,
			Constants.Size.SCREEN_WIDTH * 0.50,
			50))
		btnFB.imageView?.contentMode = .ScaleAspectFit
		btnFB.setImage(UIImage(named: "Login-FBText"), forState: .Normal)
		btnFB.addTarget(self, action: #selector(loginFB), forControlEvents: .TouchUpInside)
		self.view.addSubview(btnFB)
		
	
		let imgvOR = UIImageView(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.35,
			btnFB.frame.origin.y + btnFB.frame.size.height,
			Constants.Size.SCREEN_WIDTH * 0.30,
			40))
		imgvOR.image = UIImage(named: "Login-Text-OR")
		imgvOR.contentMode = .ScaleAspectFit
		self.view.addSubview(imgvOR)
		
		
		let btnEmail = UIButton(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.25,
			imgvOR.frame.origin.y + imgvOR.frame.size.height,
			Constants.Size.SCREEN_WIDTH * 0.50,
			50))
		btnEmail.imageView?.contentMode = .ScaleAspectFit
		btnEmail.setImage(UIImage(named: "Login-EmailText"), forState: .Normal)
		btnEmail.addTarget(self, action: #selector(gotoSignin), forControlEvents: .TouchUpInside)
		self.view.addSubview(btnEmail)
		
	}
	
	
	// MARK: - FB
	func loginFB() {
		let fbManager = FBSDKLoginManager()
		fbManager.logOut()
		fbManager.logInWithReadPermissions(["public_profile", "email", "user_about_me", "user_hometown", "user_photos"],
		                                   fromViewController: self,
		                                   handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
																				print(result)
																				if (error != nil) {
																				} else if (result.isCancelled) {
																					
																				} else {
																					self.parseUserData()
																				}
		})
	}
	
	func parseUserData() {
		print("parseUserData")
		if((FBSDKAccessToken.currentAccessToken()) != nil) {
			FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
				.startWithCompletionHandler({ (connection, result, error) -> Void in
					if (error == nil) {
						
						var strID: NSString = ""
						if (result.valueForKey("id") != nil) {
							strID = result.valueForKey("id") as! NSString
						}
						
						var strEmail: NSString = ""
						if (result.valueForKey("email") != nil) {
							strEmail = result.valueForKey("email") as! NSString
						}
						
						var strName: NSString = ""
						if (result.valueForKey("name") != nil) {
							strName = result.valueForKey("name") as! NSString
						}
						
						var strFName: NSString = ""
						if(result.valueForKey("first_name") != nil) {
								strFName = result.valueForKey("first_name") as! NSString
						}
						
						var strLName: NSString = ""
						if(result.valueForKey("last_name") != nil) {
								strLName = result.valueForKey("last_name") as! NSString
						}

						
						let objPictureDic =  result.valueForKey("picture") as? NSDictionary
						let objDataDic =  objPictureDic!.valueForKey("data") as? NSDictionary
						var userepicture : NSString = "default.png"
						
						if(objDataDic?.valueForKey("url") as? String != nil) {
							userepicture = (objDataDic!.valueForKey("url") as? NSString)!
							print("User userepicture is: \(userepicture)")
						}
						
						NSUserDefaults.standardUserDefaults().setObject(strID, forKey: Constants.STD.FB_ID)
						NSUserDefaults.standardUserDefaults().setObject(strFName, forKey: Constants.STD.FB_FName)
						NSUserDefaults.standardUserDefaults().setObject(strLName, forKey: Constants.STD.FB_LName)
						NSUserDefaults.standardUserDefaults().setObject(strEmail, forKey: Constants.STD.FB_Email)
						NSUserDefaults.standardUserDefaults().synchronize()

						self.gotoWelcome()
					}
				})
		}
	}
	
	
	// MARK: - Navigation
	func gotoSignin() {
		self.navigationController?.pushViewController(SigninVC(), animated: false)
	}
	
	func gotoWelcome() {
		self.navigationController?.pushViewController(WelcomeVC(), animated: false)
	}
}