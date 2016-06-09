import UIKit

class BFLoader: NSObject {

	// MARK: - Properties
	static let sharedInstance = BFLoader()
	private var viewLoader: UIView!

	
	// MARK: - Methods
	private func prepareLoader(view: UIView) {
		
		if let loader = viewLoader  {
			loader.hidden = false
		} else {
			viewLoader = UIView(frame: CGRectMake(0,0,170,170))
			viewLoader.center = view.center
			viewLoader.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
			viewLoader.clipsToBounds = true
			viewLoader.layer.cornerRadius = 10.0
			view.addSubview(viewLoader)
			
			let acivLoader = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
			acivLoader.frame = CGRectMake(65, 40, acivLoader.bounds.size.width, acivLoader.bounds.size.height)
			viewLoader.addSubview(acivLoader)
			acivLoader.startAnimating()
			
			let lblCaption = UILabel(frame: CGRectMake(20,85,130,66))
			lblCaption.backgroundColor = UIColor.clearColor()
			lblCaption.textColor = UIColor.whiteColor()
			lblCaption.adjustsFontSizeToFitWidth = true
			lblCaption.textAlignment = .Center
			lblCaption.text = "Loading Data... Please wait..."
			lblCaption.lineBreakMode = .ByWordWrapping
			lblCaption.numberOfLines = 0;
			viewLoader.addSubview(lblCaption)
		}
	}	
	
	func showLoader(view: UIView) {
		self.performSelectorOnMainThread(#selector(showLoaderOnMain(_:)), withObject: view, waitUntilDone: false)
	}

	@objc private func showLoaderOnMain(view: UIView) {
		print("showLoaderOnMain")
	
		self.prepareLoader(view)

		view.userInteractionEnabled = false
		view.bringSubviewToFront(viewLoader)
		UIApplication.sharedApplication().keyWindow?.bringSubviewToFront(viewLoader)
	}
	
	func hideLoader(view: UIView) {
		self.performSelectorOnMainThread(#selector(hideLoaderOnMain(_:)), withObject: view, waitUntilDone: false)
	}
	
	@objc private func hideLoaderOnMain(view: UIView) {
		print("hideLoaderOnMain")
		
		view.userInteractionEnabled = true
		viewLoader.hidden = true
	}
}