//
//  Presets.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/3/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

extension UIColor {

    enum app {
        static let pink = UIColor(rgbHex: 0xFF758C)
        static let gray = UIColor(rgbHex: 0x505050)
        static let darkGray = UIColor(rgbHex: 0x2E2E2E)
        static let lightGray = UIColor(rgbHex: 0xA0A0A0)
    }
    
    convenience init(rgbHex: Int, alpha: CGFloat = 1) {
        let r = (rgbHex >> 16) & 0xFF
        let g = (rgbHex >> 8) & 0xFF
        let b = rgbHex & 0xFF
        
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: alpha)
    }
    
}
