//
//  NSError+Presets.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

extension NSError {
    
    static var invalidRequestError: NSError {
        return networkErrorWithMessage("Invalid request")
    }
    
    class func networkErrorWithMessage(_ message: String) -> NSError {
       return NSError(domain: ErrorDomains.network.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: message.localized])
    }
    
}
