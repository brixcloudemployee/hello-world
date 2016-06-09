import Foundation
import UIKit

enum JSONError: String, ErrorType {
	case NoData = "ERROR: no data"
	case ConversionFailed = "ERROR: conversion from JSON failed"
}

struct Constants {
	struct Size {
		static let SCREEN_WIDTH		= UIScreen.mainScreen().bounds.size.width
		static let SCREEN_HEIGHT	= UIScreen.mainScreen().bounds.size.height
		static let SCREEN_MAX_LENGTH = max(Size.SCREEN_WIDTH, Size.SCREEN_HEIGHT)
		static let SCREEN_MIN_LENGTH = min(Size.SCREEN_WIDTH, Size.SCREEN_HEIGHT)
		
		static let HEADER_HEIGHT:CGFloat		= 66
		static let KEYBOARD_HEIGHT:CGFloat	= 256
	}
	
	struct STD {
		static let FB_ID		=	"FB_ID"
		static let FB_Email	=	"FB_Email"
		static let FB_FName	=	"FB_FName"
		static let FB_LName	=	"FB_LName"
	}
}