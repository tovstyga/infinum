//
//  ShowWebModel.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/2/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import ObjectMapper

struct ShowWebModel: Mappable {
    
    private(set) var type: String?
    private(set) var title: String?
    private(set) var info: String?
    private(set) var id: String
    private(set) var likesCount: Int?
    private(set) var imageUrl: String?
    
    private enum Keys: String {
        case type = "type"
        case title = "title"
        case info = "description"
        case id = "_id"
        case likesCount = "likesCount"
        case imageUrl = "imageUrl"
    }
    
    init?(map: Map) {
        let source: String? = try? map.value(Keys.id.rawValue)
        guard let _id = source else {
            return nil;
        }
        id = _id
        type = try? map.value(Keys.type.rawValue)
        title = try? map.value(Keys.title.rawValue)
        info = try? map.value(Keys.info.rawValue)
        likesCount = try? map.value(Keys.likesCount.rawValue)
        imageUrl = try? map.value(Keys.imageUrl.rawValue)
    }
    
    mutating func mapping(map: Map) {
        type <- map[Keys.type.rawValue]
        title <- map[Keys.title.rawValue]
        info <- map[Keys.info.rawValue]
        id <- map[Keys.id.rawValue]
        likesCount <- map[Keys.likesCount.rawValue]
        imageUrl <- map[Keys.imageUrl.rawValue]
    }

}
