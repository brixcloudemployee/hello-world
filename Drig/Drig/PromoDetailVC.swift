import UIKit

class PromoDetailVC: UIViewController {
	
    // MARK: - Properties
    var sizeScreen: CGSize!
    var strVideo: String?
    var strLink: String?
    var strImage: String?
    
    
    // MARK: - View
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.lightGrayColor()
		
		sizeScreen = UIScreen.mainScreen().bounds.size
		
        prepareHeader()

        if let strVideo = strVideo {
            print(strVideo)
            prepareVideoView()
        } else if let strLink = strLink {
            print(strLink)
            prepareLinkView()
        } else if let strImage = strImage {
            print(strImage)
            prepareImageView()
        }
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    
    // MARK: - Methods
    func prepareHeader() {
        let lblTitle = UILabel(frame: CGRectMake(0,0,sizeScreen.width,44))
        lblTitle.backgroundColor = UIColor.colorFromHex(0x7986CB)
        lblTitle.textAlignment = .Center
        lblTitle.textColor = UIColor.whiteColor()
        lblTitle.text = "Promo Detail"
        self.view.addSubview(lblTitle)

        let btnBack = UIButton(frame: CGRectMake(0,0,44,44))
        btnBack.titleLabel?.font = UIFont.systemFontOfSize(30)
        btnBack.setTitle("<", forState: .Normal)
        btnBack.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        btnBack.addTarget(self, action: #selector(goBack), forControlEvents: .TouchUpInside)
        self.view.addSubview(btnBack)
    }

    func prepareImageView() {
        let imageView = UIImageView(frame: CGRectMake(0,
            Constants.Size.HEADER_HEIGHT,
            Constants.Size.SCREEN_WIDTH,
            Constants.Size.SCREEN_HEIGHT - Constants.Size.HEADER_HEIGHT))
        imageView.image = UIImage(named: "Placeholder")
        imageView.downloadImageFrom(link: strImage!, contentMode: .ScaleAspectFit)
        self.view.addSubview(imageView)
    }
    
    func prepareVideoView() {
        let webView = UIWebView(frame: CGRectMake(0,
            Constants.Size.HEADER_HEIGHT,
            Constants.Size.SCREEN_WIDTH,
            Constants.Size.SCREEN_HEIGHT - Constants.Size.HEADER_HEIGHT))
        let request = NSURLRequest(URL: NSURL(string: strVideo!)!)
        webView.loadRequest(request)
        self.view.addSubview(webView)
    }

    func prepareLinkView() {
        let webView = UIWebView(frame: CGRectMake(0,
            Constants.Size.HEADER_HEIGHT,
            Constants.Size.SCREEN_WIDTH,
            Constants.Size.SCREEN_HEIGHT - Constants.Size.HEADER_HEIGHT))
        let request = NSURLRequest(URL: NSURL(string: strLink!)!)
        webView.loadRequest(request)
        self.view.addSubview(webView)
    }

    
    // MARK: - Navigation
    func goBack() {
        self.navigationController?.popViewControllerAnimated(false)
    }
}