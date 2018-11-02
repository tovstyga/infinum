//
//  LoginResponseModel.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginResponseModel: Mappable {
    
    private(set) var token: String?
    
    required init?(map: Map) {
        token = try? map.value("token")
    }
    
    func mapping(map: Map) {
        token <- map["token"]
    }
    
}
