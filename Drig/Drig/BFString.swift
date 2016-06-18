import Foundation
import UIKit

extension UIAlertController {
    static func showMessage(target: AnyObject, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        target.presentViewController(alert, animated: true, completion: nil)
    }
}

extension UIImageView {
    func downloadImageFrom(link link:String, contentMode: UIViewContentMode) {
        NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}


extension String {
    
    func isAlphaNumeric() -> Bool {
        var strSelf:String = self
        
        let alphaSet:NSCharacterSet = NSCharacterSet.alphanumericCharacterSet()
        strSelf = strSelf.stringByTrimmingCharactersInSet(alphaSet)
        return strSelf.characters.count == 0
    }   // SAMPLE CALL = strTest.isAlphaNumeric()

    func isNumber() -> Bool {
        let strSelf:String = self
        
        let alphaNums:NSCharacterSet = NSCharacterSet.decimalDigitCharacterSet()
        let inStringSet:NSCharacterSet = NSCharacterSet(charactersInString:strSelf)
        
        return alphaNums.isSupersetOfSet(inStringSet)
    }   // SAMPLE CALL = strTest.isNumber()

    func isURL() -> Bool {
        let strSelf:String = self
        
        if strSelf.characters.count < 7 {
            return false
        }
        
        let range = strSelf.startIndex.advancedBy(0)...strSelf.startIndex.advancedBy(6)
        let prefix:String = strSelf.substringWithRange(range)
        
        if prefix == "http://" {
            return true
        }
        return false
    }   // SAMPLE CALL = strTest.isURL()

    func isEmail() -> Bool {
        let strSelf:String = self
        
        let emailRegex:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluateWithObject(strSelf)
    }   // SAMPLE CALL = strTest.isEmail()
    
    func stringContainingString(string: String) -> Bool {
        let strSelf:String = self
        return strSelf.lowercaseString.rangeOfString(string.lowercaseString) != nil
    }   // SAMPLE CALL = strTest.stringContainingString("test")

    func stringBetweenString(fromString: String, toString: String) -> String {
        let strSelf:String = self
        
        let rangeFrom:Range<String.Index> = strSelf.lowercaseString.rangeOfString(fromString.lowercaseString)!
        let rangeTo:Range<String.Index> = strSelf.lowercaseString.rangeOfString(toString.lowercaseString)!
        
        if rangeFrom.count > 0 && rangeTo.count > 0 {
            let rangeBetween:Range = Range(start: rangeFrom.startIndex.advancedBy(rangeFrom.count),
                end:rangeTo.startIndex )
            return strSelf.substringWithRange(rangeBetween)
        }
        return ""
    }   // SAMPLE CALL = strTest.stringBetweenString("brix", toString:"fernando")
    
    func stringByStrippingHTML() -> String {
        let strSelf:String = self
    
        //NSRange range;
        //while ((range = [strSelf rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        //    strSelf = [strSelf stringByReplacingCharactersInRange:range withString:@""];
        //return [strSelf stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        return ""
    }

//    + (NSString*)dataFilePath:(NSString*)name {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    return [documentsDirectory stringByAppendingPathComponent:name];
//    }
}

extension UIColor {
    static func colorFromHex(hexValue: Int) -> UIColor {
        let div:CGFloat = 255.0
        return UIColor(red:((CGFloat)((hexValue & 0xFF0000) >> 16))/div,
            green:((CGFloat)((hexValue & 0x00FF00) >>  8))/div,
            blue:((CGFloat)((hexValue & 0x0000FF) >>  0))/div,
            alpha:1.0)
    }
}
