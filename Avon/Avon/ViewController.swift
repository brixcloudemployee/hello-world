import UIKit

class ViewController: UIViewController {

	// MARK: - Properties
	var imgvBG: UIImageView!
	var viewHeader: UIView!
	var imgvTitle: UIImageView!
	var btnLeft: UIButton!
	var btnRight: UIButton!
	
	
	// MARK: - View
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		prepUI()
		
	
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goHideKeyboard)))
		
		// TEMP
		let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
		swipeRight.direction = .Right
		self.view.addGestureRecognizer(swipeRight)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	// MARK: - Methods
	func prepUI() {
		imgvBG = UIImageView(frame: CGRectMake(0,
			0,
			Constants.Size.SCREEN_WIDTH,
			Constants.Size.SCREEN_HEIGHT))
		imgvBG.backgroundColor = UIColor.whiteColor()
		//		imgvBG.image = UIImage(named: "App-BG")
		self.view.addSubview(imgvBG)
		
		viewHeader = UIView(frame: CGRectMake(0,
			0,
			Constants.Size.SCREEN_WIDTH,
			Constants.Size.HEADER_HEIGHT))
		//		viewHeader.backgroundColor = UIColor.grayColor()
		viewHeader.backgroundColor = UIColor(patternImage: UIImage(named: "NavBar-BG")!)
		self.view.addSubview(viewHeader)
		
		
		imgvTitle = UIImageView(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.25,
			0,
			Constants.Size.SCREEN_WIDTH * 0.50,
			Constants.Size.HEADER_HEIGHT))
		imgvTitle.contentMode = .ScaleAspectFit
		imgvTitle.image = UIImage(named: "NavBar-Title")
		viewHeader.addSubview(imgvTitle)
		
		btnLeft = UIButton(frame: CGRectMake(0,
			0,
			Constants.Size.HEADER_HEIGHT,
			Constants.Size.HEADER_HEIGHT))
		btnLeft.imageView?.contentMode = .ScaleAspectFit
		btnLeft.setImage(UIImage(named: "NavBar-Burger"), forState: .Normal)
		btnLeft.contentEdgeInsets = UIEdgeInsetsMake(25, 20, 15, 20)
		viewHeader.addSubview(btnLeft)
		
		btnRight = UIButton(frame: CGRectMake(Constants.Size.SCREEN_WIDTH - Constants.Size.HEADER_HEIGHT,
			0,
			Constants.Size.HEADER_HEIGHT,
			Constants.Size.HEADER_HEIGHT))
		btnRight.imageView?.contentMode = .ScaleAspectFit
		btnRight.setImage(UIImage(named: "NavBar-Dots"), forState: .Normal)
		btnRight.contentEdgeInsets = UIEdgeInsetsMake(25, 15, 15, 0)
		viewHeader.addSubview(btnRight)
	}

	func goBack() {
		self.navigationController?.popViewControllerAnimated(false)
	}
	
	func goHideKeyboard() {
		self.view.endEditing(true)
		
	}

}