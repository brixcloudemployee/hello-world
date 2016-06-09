import UIKit

class MainVC: ViewController {
	
	// MARK: Properties
	// ALERT
	var sizeScreen: CGSize!
	var viewScreen: UIView!
	var viewAlert: UIView!
	var lblName: UILabel!
	var lblDetail: UILabel!
	var txtSteps: UITextField!
	var btnDone: UIButton!
	
	// PAGE
	var lblDate: UILabel!
	var lblSteps: UILabel!
	var lblGoals: UILabel!
	
	
	// MARK: - View
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		
		updateUI()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.view.backgroundColor = UIColor.whiteColor()
		
		sizeScreen = UIScreen.mainScreen().bounds.size
		
		//		prepareSmokeScreen()
		
		prepareUI()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	// MARK: - Methods
	func prepareUI() {
		let scrollView = UIScrollView(frame: CGRectMake(0,
			viewHeader.frame.origin.y + viewHeader.frame.size.height,
			sizeScreen.width,
			sizeScreen.height - (viewHeader.frame.origin.y + viewHeader.frame.size.height)))
		self.view.addSubview(scrollView)
		
		// DATE
		lblDate = UILabel(frame: CGRectMake(0,
			0,
			sizeScreen.width,
			50))
		lblDate.font = UIFont.systemFontOfSize(16)
		lblDate.textAlignment = .Center
		lblDate.textColor = UIColor.blackColor()
		scrollView.addSubview(lblDate)
		
		
		// CIRCLE
		let imgvCircle = UIImageView(frame: CGRectMake(0,
			lblDate.frame.origin.y + lblDate.frame.size.height,
			sizeScreen.width * 0.8,
			sizeScreen.width * 0.8))
		imgvCircle.center = CGPointMake(self.view.center.x, imgvCircle.center.y)
		imgvCircle.image = UIImage(named: "Main-Circle")
		scrollView.addSubview(imgvCircle)
		
		lblSteps = UILabel(frame: CGRectMake(0,
			imgvCircle.frame.origin.y + (imgvCircle.frame.size.height * 0.38),
			sizeScreen.width,
			imgvCircle.frame.size.height * 0.34))
		lblSteps.font = UIFont.systemFontOfSize(lblSteps.frame.size.height * 0.8)
		lblSteps.textAlignment = .Center
		lblSteps.textColor = UIColor.whiteColor()
		scrollView.addSubview(lblSteps)
		
		lblGoals = UILabel(frame: CGRectMake(0,
			imgvCircle.frame.origin.y + (imgvCircle.frame.size.height * 0.80),
			sizeScreen.width,
			imgvCircle.frame.size.height * 0.1))
		lblGoals.userInteractionEnabled = true
		lblGoals.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeDailyGoals)))
		lblGoals.font = UIFont.systemFontOfSize(lblGoals.frame.size.height * 0.8)
		lblGoals.textAlignment = .Center
		lblGoals.textColor = UIColor.blackColor()
		scrollView.addSubview(lblGoals)
		
		
		// SHARE
		let btnShareSteps = UIButton(frame: CGRectMake(0,
			imgvCircle.frame.origin.y + imgvCircle.frame.size.height + 10,
			280,
			35))
		btnShareSteps.center = CGPointMake(self.view.center.x, btnShareSteps.center.y)
		btnShareSteps.layer.cornerRadius = 5
		btnShareSteps.backgroundColor = UIColor.lightGrayColor()
		btnShareSteps.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
		btnShareSteps.setTitle("SHARE YOUR DAILY STEPS", forState: .Normal)
		scrollView.addSubview(btnShareSteps)
		
		
		// 130
		let imgvMillion = UIImageView(frame: CGRectMake(0,
			btnShareSteps.frame.origin.y + btnShareSteps.frame.size.height + 10,
			btnShareSteps.frame.size.width,
			73))
		imgvMillion.center = CGPointMake(self.view.center.x, imgvMillion.center.y)
		imgvMillion.image = UIImage(named: "Main-130")
		scrollView.addSubview(imgvMillion)
		
		
		// LINE
		let viewLine = UIView(frame: CGRectMake(sizeScreen.width * 0.05,
			imgvMillion.frame.origin.y + imgvMillion.frame.size.height + 20,
			sizeScreen.width * 0.9,
			2))
		viewLine.backgroundColor = UIColor.lightGrayColor()
		scrollView.addSubview(viewLine)
		
		
		// SPONSORS
		
		// FB - 317 - 117
		// Donate - 262 - 117
		// Globe - 256 - 115
		// Skecher - 215 - 95
		
		let imgvFBShare = UIImageView(frame: CGRectMake(viewLine.frame.origin.x + (viewLine.frame.size.width * 0.01),
			viewLine.frame.origin.y + viewLine.frame.size.height + 10,
			viewLine.frame.size.width * 0.22,
			viewLine.frame.size.width * 0.10))
		imgvFBShare.contentMode = .ScaleAspectFit
		imgvFBShare.image = UIImage(named: "Main-FB")
		scrollView.addSubview(imgvFBShare)
		
		let imgvDonate = UIImageView(frame: CGRectMake(imgvFBShare.frame.origin.x + imgvFBShare.frame.size.width + (viewLine.frame.size.width * 0.033),
			imgvFBShare.frame.origin.y,
			viewLine.frame.size.width * 0.22,
			viewLine.frame.size.width * 0.10))
		imgvDonate.userInteractionEnabled = true
		imgvDonate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoDonate)))
		imgvDonate.contentMode = .ScaleAspectFit
		imgvDonate.image = UIImage(named: "Main-Donate")
		scrollView.addSubview(imgvDonate)
		
		let imgvGlobe = UIImageView(frame: CGRectMake(imgvDonate.frame.origin.x + imgvDonate.frame.size.width + (viewLine.frame.size.width * 0.033),
			imgvFBShare.frame.origin.y,
			viewLine.frame.size.width * 0.22,
			viewLine.frame.size.width * 0.10))
		imgvGlobe.contentMode = .ScaleAspectFit
		imgvGlobe.image = UIImage(named: "Main-Globe")
		scrollView.addSubview(imgvGlobe)
		
		let imgvSkechers = UIImageView(frame: CGRectMake(imgvGlobe.frame.origin.x + imgvGlobe.frame.size.width + (viewLine.frame.size.width * 0.033),
			imgvFBShare.frame.origin.y,
			viewLine.frame.size.width * 0.22,
			viewLine.frame.size.width * 0.10))
		imgvSkechers.contentMode = .ScaleAspectFit
		imgvSkechers.image = UIImage(named: "Main-Skechers")
		scrollView.addSubview(imgvSkechers)
		
		
		scrollView.contentSize = CGSizeMake(Constants.Size.SCREEN_WIDTH, imgvFBShare.frame.origin.y + imgvFBShare.frame.size.height + 10)
	}
	
	func updateUI() {
		let df = NSDateFormatter()
		df.dateStyle = .FullStyle
		lblDate.text = df.stringFromDate(NSDate())
		
		lblSteps.text = "0"
		lblGoals.text = "10,000"
	}

	func changeDailyGoals() {
		
	}
	
	
	// MARK: - Navigation
	func gotoDonate() {
		self.navigationController?.pushViewController(DonateVC(), animated: false)
	}
	
	
	// MARK: - Reserve
	func prepareSmokeScreen() {
		viewScreen = UIView(frame: CGRectMake(0,
			0,
			sizeScreen.width,
			sizeScreen.height))
		viewScreen.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
		self.view.addSubview(viewScreen)
		
		//		prepareHello()
		//		prepareSteps()
	}
	
	func prepareHello() {
		viewAlert = UIView(frame: CGRectMake(0,
			0,
			sizeScreen.width * 0.9,
			150))
		viewAlert.layer.shadowColor = UIColor.redColor().CGColor
		viewAlert.layer.shadowOffset = CGSizeMake(0, 0)
		viewAlert.layer.shadowRadius = 1
		viewAlert.layer.shadowOpacity = 1
		viewAlert.layer.cornerRadius = 5
		viewAlert.backgroundColor = UIColor.whiteColor()
		viewAlert.center = self.view.center
		self.view.addSubview(viewAlert)
		
		lblName = UILabel(frame: CGRectMake(0,
			20,
			viewAlert.frame.size.width,
			viewAlert.frame.size.height * 0.4))
		lblName.font = UIFont.systemFontOfSize(30)
		lblName.textAlignment = .Center
		lblName.textColor = UIColor.blackColor()
		lblName.text = "Hello World"
		self.viewAlert.addSubview(lblName)
		
		lblDetail = UILabel(frame: CGRectMake(0,
			lblName.frame.origin.y + lblName.frame.size.height - 20,
			viewAlert.frame.size.width,
			viewAlert.frame.size.height - lblName.frame.size.height))
		lblDetail.font = UIFont.systemFontOfSize(20)
		lblDetail.textAlignment = .Center
		lblDetail.textColor = UIColor.blackColor()
		lblDetail.text = "You may now take \nyour first step"
		lblDetail.numberOfLines = 0
		self.viewAlert.addSubview(lblDetail)
	}
	
	func prepareSteps() {
		viewAlert = UIView(frame: CGRectMake(0,
			0,
			sizeScreen.width * 0.9,
			200))
		viewAlert.layer.shadowColor = UIColor.redColor().CGColor
		viewAlert.layer.shadowOffset = CGSizeMake(0, 0)
		viewAlert.layer.shadowRadius = 1
		viewAlert.layer.shadowOpacity = 1
		viewAlert.layer.cornerRadius = 5
		viewAlert.backgroundColor = UIColor.whiteColor()
		viewAlert.center = self.view.center
		self.view.addSubview(viewAlert)
		
		lblName = UILabel(frame: CGRectMake(0,
			10,
			viewAlert.frame.size.width,
			viewAlert.frame.size.height * 0.2))
		lblName.font = UIFont.systemFontOfSize(20)
		lblName.textAlignment = .Center
		lblName.textColor = UIColor.blackColor()
		lblName.text = "Hello World"
		viewAlert.addSubview(lblName)
		
		lblDetail = UILabel(frame: CGRectMake(0,
			lblName.frame.origin.y + lblName.frame.size.height - 10,
			viewAlert.frame.size.width,
			viewAlert.frame.size.height * 0.2))
		lblDetail.font = UIFont.systemFontOfSize(16)
		lblDetail.textAlignment = .Center
		lblDetail.textColor = UIColor.blackColor()
		lblDetail.text = "Please enter your daily step goal"
		viewAlert.addSubview(lblDetail)
		
		txtSteps = UITextField(frame: CGRectMake(0,
			lblDetail.frame.origin.y + lblDetail.frame.size.height,
			viewAlert.frame.size.width,
			viewAlert.frame.size.height * 0.4))
		txtSteps.font = UIFont.systemFontOfSize(50)
		txtSteps.keyboardType = .NumberPad
		txtSteps.textAlignment = .Center
		txtSteps.placeholder = "0"
		viewAlert.addSubview(txtSteps)
		
		btnDone = UIButton(frame: CGRectMake(0,
			txtSteps.frame.origin.y + txtSteps.frame.size.height,
			viewAlert.frame.size.width,
			viewAlert.frame.size.height * 0.2))
		btnDone.setTitle("Done", forState: .Normal)
		btnDone.setTitleColor(UIColor.blueColor(), forState: .Normal)
		viewAlert.addSubview(btnDone)
	}
}