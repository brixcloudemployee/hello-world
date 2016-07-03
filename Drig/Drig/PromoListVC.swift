import UIKit
import CoreLocation
import CoreBluetooth

class PromoListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, CBCentralManagerDelegate {
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    var bluetoothManager = CBCentralManager()
	
    var arrData = [AnyObject]()
    var beacon1 = CLBeacon()
		var beacon2 = CLBeacon()
		var noBeacon = false
    var tblvList: UITableView!
		var lblTitle: UILabel!
	
    // MARK: - View
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        checkBluetooth()
        startLocMan()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        
        stopLocMan()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Promos"
        
        setupLocMan()
        prepareUI()
        
//        requestBeaconData("710", min: "1")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareUI() {
				let imgvBG = UIImageView(frame: CGRectMake(0,0,Constants.Size.SCREEN_WIDTH,Constants.Size.SCREEN_HEIGHT))
				imgvBG.backgroundColor = UIColor.colorFromHex(0xC5CAE9)
				imgvBG.image = UIImage(named: "Launch")
				imgvBG.contentMode = .ScaleAspectFit
				self.view.addSubview(imgvBG)
			
        lblTitle = UILabel(frame: CGRectMake(0,
            0,
            Constants.Size.SCREEN_WIDTH,
            Constants.Size.HEADER_HEIGHT))
        lblTitle.backgroundColor = UIColor.colorFromHex(0x7986CB)
        lblTitle.textAlignment = .Center
        lblTitle.textColor = UIColor.whiteColor()
        lblTitle.text = "Promos"
        self.view.addSubview(lblTitle)
        
        tblvList = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain);
        tblvList.delegate = self;
        tblvList.dataSource = self;
        tblvList.frame = CGRectMake(0,
                                    Constants.Size.HEADER_HEIGHT,
                                    Constants.Size.SCREEN_WIDTH,
                                    Constants.Size.SCREEN_HEIGHT - Constants.Size.HEADER_HEIGHT);
//        tblvList.backgroundColor = UIColor.colorFromHex(0xC5CAE9)
				tblvList.backgroundColor = UIColor.clearColor()
        tblvList.separatorColor = UIColor.clearColor()
        self.view.addSubview(tblvList);
			
				let imgvButton = UIImageView(frame: CGRectMake(Constants.Size.SCREEN_WIDTH - 60,
					Constants.Size.SCREEN_HEIGHT - 60,
					40,
					40))
				imgvButton.image = UIImage(named: "ColorIcon")
				self.view.addSubview(imgvButton)
    }
	
	
    // MARK: - Location Manager
    func setupLocMan() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func stopLocMan() {
        let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")!, identifier: "test")
        locationManager.stopRangingBeaconsInRegion(region)
    }
    
    func startLocMan() {
        let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")!, identifier: "test")
        locationManager.startRangingBeaconsInRegion(region)
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        
//        print("count: \(knownBeacons.count)")
        if (knownBeacons.count > 0) {
						noBeacon = false
            let closestBeacon = knownBeacons[0] as CLBeacon
            prepareBeacon(closestBeacon)
        } else {
					if noBeacon == true {
            arrData = [AnyObject]()
            tblvList.reloadData()
					}
					noBeacon = true
        }
    }
    
    func prepareBeacon(beacon: CLBeacon) {
        print(beacon.major, beacon.minor)

				if beacon1.major == beacon.major && beacon1.minor == beacon.minor {
					if beacon2.major == beacon.major && beacon2.minor == beacon.minor {
						// same beacon do nothing
					} else {
						beacon2 = beacon
						requestBeaconData(String(beacon.major), min: String(beacon.minor))
					}
				} else {
					beacon1 = beacon
				}
		}
    
    func requestBeaconData(max: String, min: String) {
        print("requestBeaconData")
        
        let strURL:String = "http://beacons.drigmethods.com/displaypromotionbymaxmin?max=\"\(max)\"&min=\"\(min)\""
        
        let strPath = strURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url:NSURL = NSURL(string: strPath! )!
        
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let task = session.dataTaskWithRequest(request) {(
            let data, let response, let error) in
            
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray else {
                    throw JSONError.ConversionFailed
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    print(json)
                    self.arrData = [AnyObject]()
                    self.arrData += json
                    self.tblvList.reloadData()
									
									if self.arrData.count > 0 {
										if let dictPromo = self.arrData[0] as? NSDictionary {
											if let merchant = dictPromo["merchant"] as? String {
												self.lblTitle.text = merchant
											}
										}
									}
                }
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
        task.resume()
    }
    
    
    // MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var viewBG: UIView?
        var imgvIcon: UIImageView?
        var lblTitle: UILabel?
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        if( cell == nil ) {
            cell = UITableViewCell(style:.Default, reuseIdentifier: "Cell")
            cell.backgroundColor = UIColor.clearColor()
            
            viewBG = UIView(frame: CGRectMake(5,
                5,
                Constants.Size.SCREEN_WIDTH - 10,
                Constants.Size.CELL_HEIGHT - 6))
            viewBG?.backgroundColor = UIColor.colorFromHex(0xE8EAF6)
            viewBG?.layer.shadowColor = UIColor.blackColor().CGColor
            viewBG?.layer.shadowOffset = CGSizeMake(0,0)
            viewBG?.layer.shadowOpacity = 1
            viewBG?.layer.shadowRadius = 1.5
            viewBG?.tag = 1
            cell.contentView.addSubview(viewBG!)
            
            imgvIcon = UIImageView(frame: CGRectMake(Constants.Size.SCREEN_WIDTH-(100+10+10),  // 100 image width, 10 padding from screen, 10 padding from viewBG
                5+22,   // 5 padding from screen, 22 padding from viewBG
                100,
                100))
            imgvIcon?.backgroundColor = UIColor.clearColor()
            imgvIcon?.tag = 2
            cell.contentView.addSubview(imgvIcon!)
            
            lblTitle = UILabel(frame: CGRectMake(5+10,   // 5 padding from screen, 10 padding from viewBG
                imgvIcon!.frame.origin.y,
                viewBG!.frame.size.width - (viewBG!.frame.size.width - imgvIcon!.frame.origin.x) - 15,
                imgvIcon!.frame.size.height))
            lblTitle?.backgroundColor = UIColor.clearColor()
            lblTitle?.textColor = UIColor.blackColor().colorWithAlphaComponent(0.54)
            lblTitle?.numberOfLines = 0
            lblTitle?.tag = 3
            cell.contentView.addSubview(lblTitle!)
        } else {
            viewBG = cell.contentView.viewWithTag(1)
            imgvIcon = cell.contentView.viewWithTag(2) as? UIImageView
            lblTitle = cell.contentView.viewWithTag(3) as? UILabel
        }
        
        let promo = arrData[indexPath.row]
        
        if let promoID = promo["promotionDescription"] as? String {
            lblTitle?.text = promoID
        }
        
        imgvIcon?.image = UIImage(named: "Placeholder")
        if let imageURL = promo["imageURL"] as? String {
            imgvIcon?.downloadImageFrom(link: imageURL, contentMode: .ScaleAspectFit)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let promo = arrData[indexPath.row]
        bumpPromo(promo["max"] as! String, min: promo["min"] as! String, id: promo["_id"] as! String)
			
        let nextVC = PromoDetailVC()
        if let promoVideo = promo["videoURL"] as? String where promoVideo != "null" {
            nextVC.strVideo = promoVideo
        } else if let promoLink = promo["linkURL"] as? String where promoLink != "null" {
            nextVC.strLink = promoLink
        } else if let promoImage = promo["imageURL"] as? String where promoImage != "null" {
            nextVC.strImage = promoImage
        }
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.Size.CELL_HEIGHT;
    }
    
    func bumpPromo(max: String, min: String, id: String) {
        
        if canBump(id) == false {
            return
        }
        
        let strURL:String = "http://beacons.drigmethods.com/thebump"
        let url:NSURL = NSURL(string: strURL )!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let email = NSUserDefaults.standardUserDefaults().objectForKey("std-email") as! String
        let paramString = "max=\(max)&min=\(min)&email=\(email)"
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
    
    func canBump(id: String) -> Bool {
        let date = NSDate()
        
        if let oldDate = NSUserDefaults.standardUserDefaults().objectForKey(id) {
            if date.timeIntervalSinceDate(oldDate as! NSDate) > 3600 {  // 1hr passed
                NSUserDefaults.standardUserDefaults().setObject(date, forKey: id)
                NSUserDefaults.standardUserDefaults().synchronize()
                return true
            }
        } else {
            NSUserDefaults.standardUserDefaults().setObject(date, forKey: id)
            NSUserDefaults.standardUserDefaults().synchronize()
            return true
        }
        return false
    }
    
    
    // MARK: - Bluetooth
    func checkBluetooth() {
        self.bluetoothManager = CBCentralManager(delegate: nil, queue: dispatch_get_main_queue())
        //self.centralManagerDidUpdateState(self.bluetoothManager)
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        var stateString = ""
				var bON = false
        
        switch bluetoothManager.state {
            
        case CBCentralManagerState.Resetting:
            stateString = "The connection with the system service was momentarily lost, update imminent."
            
        case CBCentralManagerState.Unsupported:
            stateString = "The platform doesn't support Bluetooth Low Energy."
            
        case CBCentralManagerState.Unauthorized:
            stateString = "The app is not authorized to use Bluetooth Low Energy."
            
        case CBCentralManagerState.PoweredOff:
            stateString = "Bluetooth is currently powered off."
            
        case CBCentralManagerState.PoweredOn:
            stateString = "Bluetooth is currently powered on and available to use."
						bON = true
            
        default:
            stateString = "State unknown, update imminent."
        }
			
				if bON == true {
					// do nothing
				} else {
					UIAlertController.showMessage(self, title: "Bluetooth state", message: stateString)
					self.performSelector(#selector(checkBluetooth), withObject: nil, afterDelay: 2.0)
				}
    }

    
    // MARK: - Reserve
    func bump() {
        let strURL:String = "http://beacons.drigmethods.com/thebump"
        let url:NSURL = NSURL(string: strURL )!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let paramString = "max=701&min=1&email=b@b.com"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {(
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
            
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                //								guard let json = try NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary else {
                //								guard let json = try NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSArray else {
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options:[]) as? AnyObject else {
                    throw JSONError.ConversionFailed
                }
                
                if let strType = json as? NSDictionary {
                    print("dict")
                }
                if let strType = json as? NSArray {
                    print("array")
                }
                
                print(json)
                //				self.displayReturn(json)
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            
        }
        task.resume()
    }
    
    func data_request() {
        //        let strURL = "http://beacons.drigmethods.com/displaypromotion"
        //        let url:NSURL = NSURL(string: strURL)!
        
        let strURL:String = "http://beacons.drigmethods.com/displaypromotionbymaxmin?max=\"701\"&min=\"1\""
        let strPath = strURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url:NSURL = NSURL(string: strPath! )!
        
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        //        let paramString = "email=" + "a" + "&maxmin=" + "7011"
        //		let paramString = "maxmin=" + "7011"
        //		request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {(
            let data, let response, let error) in
            
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray else {
                    throw JSONError.ConversionFailed
                }
                print(json)
                //self.displayReturn(json)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.arrData += json
                    self.tblvList.reloadData()
                }
                
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