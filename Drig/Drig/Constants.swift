import Foundation
import UIKit

enum JSONError: String, ErrorType {
	case NoData = "ERROR: no data"
	case ConversionFailed = "ERROR: conversion from JSON failed"
}

struct Constants {
    struct Size {
        static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
        static let SCREEN_MAX_LENGTH = max(Size.SCREEN_WIDTH, Size.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(Size.SCREEN_WIDTH, Size.SCREEN_HEIGHT)
        
        static let HEADER_HEIGHT:CGFloat = 44
        static let CELL_HEIGHT:CGFloat = 150
    }
}