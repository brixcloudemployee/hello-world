import UIKit

class WelcomeVC: ViewController {

	// MARK: - Propertiess
	var scrollView: UIScrollView!
	var txtSteps: UITextField!
	
	
	// MARK: - View
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		prepareUI()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onKeyboardHide), name: UIKeyboardWillHideNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onKeyboardShow), name: UIKeyboardWillShowNotification, object: nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	// MARK: - Methods
	func prepareUI() {
		self.imgvBG.image = UIImage(named: "Welcome-BG")
		
		scrollView = UIScrollView(frame: CGRectMake(0,
			self.viewHeader.frame.size.height,
			Constants.Size.SCREEN_WIDTH,
			Constants.Size.SCREEN_HEIGHT))
		self.view.addSubview(scrollView)

		let imgvWelcome = UIImageView(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.25,
			10,
			Constants.Size.SCREEN_WIDTH * 0.50,
			Constants.Size.SCREEN_HEIGHT * 0.10))
		imgvWelcome.image = UIImage(named: "Welcome-Welcome")
		imgvWelcome.contentMode = .ScaleAspectFit
		scrollView.addSubview(imgvWelcome)

		
		let lblName = UILabel(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.25,
			imgvWelcome.frame.origin.y + imgvWelcome.frame.size.height,
			Constants.Size.SCREEN_WIDTH * 0.50,
			Constants.Size.SCREEN_HEIGHT * 0.10))
		if let strName = NSUserDefaults.standardUserDefaults().objectForKey(Constants.STD.FB_FName) {
			lblName.text =  strName as? String
		}
		scrollView.addSubview(lblName)

		
		let imgvLongText = UIImageView(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.10,
			lblName.frame.origin.y + lblName.frame.size.height,
			Constants.Size.SCREEN_WIDTH * 0.80,
			Constants.Size.SCREEN_HEIGHT * 0.50))
		imgvLongText.image = UIImage(named: "Welcome-LongText")
		imgvLongText.contentMode = .ScaleAspectFit
		scrollView.addSubview(imgvLongText)

		
		txtSteps = UITextField(frame: CGRectMake(0,
			imgvLongText.frame.origin.y + imgvLongText.frame.size.height - 25,
			150,
			40))
		txtSteps.center = CGPointMake(self.view.center.x, txtSteps.center.y)
		txtSteps.borderStyle = .Line
		txtSteps.keyboardType = .NumberPad
		txtSteps.font = UIFont.systemFontOfSize(25)
		txtSteps.textAlignment = .Center
		txtSteps.text = "3000"
		txtSteps.placeholder = "3000"
		scrollView.addSubview(txtSteps)
		
		
		let imgvDone = UIImageView(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.40,
			Constants.Size.SCREEN_HEIGHT * 0.90,
			Constants.Size.SCREEN_WIDTH * 0.20,
			Constants.Size.SCREEN_HEIGHT * 0.10))
		imgvDone.image = UIImage(named: "Welcome-Done")
		imgvDone.contentMode = .ScaleAspectFit
		self.view.addSubview(imgvDone)
		
		
		scrollView.contentSize = CGSizeMake(Constants.Size.SCREEN_WIDTH, txtSteps.frame.origin.y + txtSteps.frame.size.height + 10)
	}
	
	
	// MARK: - Keyboard
	func onKeyboardHide() {
		var rectScroll = scrollView.frame
		rectScroll.size.height = Constants.Size.SCREEN_HEIGHT
		scrollView.frame = rectScroll
	}
	
	func onKeyboardShow() {
		var rectScroll = scrollView.frame
		rectScroll.size.height = Constants.Size.SCREEN_HEIGHT - (Constants.Size.KEYBOARD_HEIGHT+30)
		scrollView.frame = rectScroll
	}
}