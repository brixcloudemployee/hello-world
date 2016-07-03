import UIKit

class LoginVC: UIViewController {
    
    var txtName: UITextField!
    var txtPass: UITextField!
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Welcome"
        
        prepareUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Methods
    func prepareUI() {
        let sizeScreen = UIScreen.mainScreen().bounds.size
        
        txtName = UITextField(frame: CGRectMake(10,
            50,
            sizeScreen.width-20,
            35))
        txtName.layer.masksToBounds = false
        txtName.layer.shadowColor = UIColor.blackColor().CGColor
        txtName.layer.shadowOffset = CGSizeMake(0,1)
        txtName.layer.shadowOpacity = 1
        txtName.layer.shadowRadius = 0.1
        txtName.borderStyle = .None
        txtName.backgroundColor = UIColor.whiteColor()
        txtName.placeholder = "Email"
        txtName.autocorrectionType = .No
        self.view.addSubview(txtName)
        
        txtPass = UITextField(frame: CGRectMake(txtName.frame.origin.x,
            txtName.frame.origin.y + txtName.frame.size.height + 10,
            txtName.frame.size.width,
            txtName.frame.size.height))
        txtPass.layer.masksToBounds = false
        txtPass.layer.shadowColor = UIColor.blackColor().CGColor
        txtPass.layer.shadowOffset = CGSizeMake(0,1)
        txtPass.layer.shadowOpacity = 1
        txtPass.layer.shadowRadius = 0.1
        txtPass.borderStyle = .None
        txtPass.backgroundColor = UIColor.whiteColor()
        txtPass.placeholder = "Password"
        txtPass.autocorrectionType = .No
        txtPass.secureTextEntry = true
        self.view.addSubview(txtPass)
        
        let btnLogin = UIButton(type: .System)
        btnLogin.frame = CGRectMake(txtPass.frame.origin.x,
                                    txtPass.frame.origin.y + txtPass.frame.size.height + 25,
                                    sizeScreen.width - 20,
                                    35)
        btnLogin.backgroundColor = UIColor.colorFromHex(0xE76B20)
        btnLogin.tintColor = UIColor.blackColor()
        btnLogin.setTitle("Login", forState: .Normal)
        btnLogin.addTarget(self, action: #selector(attemptLogin), forControlEvents: .TouchUpInside)
        self.view.addSubview(btnLogin)
        
        let btnSignup = UIButton(type: .System)
        btnSignup.frame = CGRectMake(btnLogin.frame.origin.x,
                                     btnLogin.frame.origin.y + btnLogin.frame.size.height + 15,
                                     btnLogin.frame.size.width,
                                     btnLogin.frame.size.height)
        btnSignup.backgroundColor = UIColor.colorFromHex(0xE76B20)
        btnSignup.tintColor = UIColor.blackColor()
        btnSignup.setTitle("Register", forState: .Normal)
        btnSignup.addTarget(self, action: #selector(attemptSignup), forControlEvents: .TouchUpInside)
        self.view.addSubview(btnSignup)
    }
    
    
    // MARK: - LOGIN
    func attemptLogin() {
        if txtName.text?.isEmpty == true {
            UIAlertController.showMessage(self, title: "Login Failed", message: "Please enter your email address")
            return
        }
        
        if txtName.text?.isEmail() == false {
            UIAlertController.showMessage(self, title: "Login Failed", message: "Please enter a valid email address")
            return
        }
        
        if txtPass.text?.isEmpty == true {
            UIAlertController.showMessage(self, title: "Login Failed", message: "Please enter password")
            return
        }
        
        loginUser()
    }
    
    func loginUser() {
        print("loginUser")
        BFLoader.sharedInstance.showLoader(self.view)
        
        let strURL = "http://beacons.drigmethods.com/login?email=\(txtName.text!)&password=\(txtPass.text!)"
        
        let url:NSURL = NSURL(string: strURL)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.timeoutInterval = 30
        
//        let paramString = "email=" + txtName.text! + "&password=" + txtPass.text!
//        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
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
    
    
    // MARK: - SIGNUP
    func attemptSignup() {
        if txtName.text?.isEmpty == true {
            UIAlertController.showMessage(self, title: "Register Failed", message: "Please enter a valid email address")
            return
        }
        
        if txtName.text?.isEmail() == false {
            UIAlertController.showMessage(self, title: "Register Failed", message: "Please enter a valid email address")
            return
        }
        
        if txtPass.text?.isEmpty == true {
            UIAlertController.showMessage(self, title: "Register Failed", message: "Please enter password")
            return
        }
        
        signupUser()
    }
    
    func signupUser() {
        let strURL = "http://beacons.drigmethods.com/signup"
        BFLoader.sharedInstance.showLoader(self.view)
        
        let url:NSURL = NSURL(string: strURL)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.timeoutInterval = 30
        
        let paramString = "email=" + txtName.text! + "&password=" + txtPass.text!
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
        
        if let success = response["success"] as? String {
            print(success)
            if success == "1" {
                NSUserDefaults.standardUserDefaults().setObject(self.txtName.text, forKey: "std-email")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.navigationController?.pushViewController(PromoListVC(), animated: false)
                return
            } else {
                UIAlertController.showMessage(self, title: response["message"] as! String, message: "please try again")
            }
        }
        
        UIAlertController.showMessage(self, title: "Failed", message: "please try again")
    }
    
    
    // MARK: - Navigation
    func gotoSignup() {
        self.navigationController?.pushViewController(SignupVC(), animated: false)
    }
}