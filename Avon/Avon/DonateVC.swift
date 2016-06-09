import UIKit

class DonateVC: ViewController {
	
	
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
		self.imgvBG.image = UIImage(named: "Donate-BG")

		let imgvTitle = UIImageView(frame: CGRectMake(Constants.Size.SCREEN_WIDTH * 0.1,
			Constants.Size.SCREEN_HEIGHT * 0.15,
			Constants.Size.SCREEN_WIDTH * 0.80,
			Constants.Size.SCREEN_HEIGHT * 0.1))
		imgvTitle.contentMode = .ScaleAspectFit
		imgvTitle.image = UIImage(named: "Donate-Title")
		self.view.addSubview(imgvTitle)
		
		let imgvLongText = UIImageView(frame: CGRectMake(0,
			imgvTitle.frame.origin.y + imgvTitle.frame.size.height + 5,
			Constants.Size.SCREEN_WIDTH,
			Constants.Size.SCREEN_HEIGHT * 0.7))
		imgvLongText.contentMode = .ScaleAspectFit
		imgvLongText.image = UIImage(named: "Donate-LongText")
		self.view.addSubview(imgvLongText)

	}
}