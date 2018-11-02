//
//  LoginResponseModel.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import ObjectMapper

struct LoginWebModel: Mappable {
    
    private(set) var token: String?
    
    private enum Keys: String {
        case token = "token"
    }
    
    init?(map: Map) {
        token = try? map.value(Keys.token.rawValue)
    }
    
    mutating func mapping(map: Map) {
        token <- map[Keys.token.rawValue]
    }
    
}
