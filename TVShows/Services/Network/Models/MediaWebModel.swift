//
//  MediaWebModel.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/2/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import ObjectMapper

struct MediaWebModel: Mappable {
    
    private(set) var identifier: String?
    private(set) var path: String?
    private(set) var type: String?
    
    private enum Keys: String {
        case identifier = "_id"
        case path = "path"
        case type = "type"
    }
    
    init?(map: Map) {
        identifier = try? map.value(Keys.identifier.rawValue)
        guard let _ = identifier else {
            return nil
        }
        path = try? map.value(Keys.path.rawValue)
        type = try? map.value(Keys.type.rawValue)
    }
    
    mutating func mapping(map: Map) {
        identifier <- map[Keys.identifier.rawValue]
        path <- map[Keys.path.rawValue]
        type <- map[Keys.type.rawValue]
    }
    
}
