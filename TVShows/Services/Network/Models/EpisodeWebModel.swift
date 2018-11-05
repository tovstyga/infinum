//
//  EpisodeWebModel.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/2/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import ObjectMapper

struct EpisodeWebModel: Mappable {
    
    private(set) var id: String
    private(set) var title: String?
    private(set) var info: String?
    private(set) var imageUrl: String?
    private(set) var episodeNumber: String?
    private(set) var season: String?
    private(set) var showId: String?
    private(set) var type: String?
    
    private enum Keys: String {
        case id = "_id"
        case title = "title"
        case info = "description"
        case imageUrl = "imageUrl"
        case episodeNumber = "episodeNumber"
        case season = "season"
        case showId = "showId"
        case type = "type"
    }
    
    init?(map: Map) {
        let source: String? = try? map.value(Keys.id.rawValue)
        guard let _id = source else {
            return nil;
        }
        id = _id
        title = try? map.value(Keys.title.rawValue)
        info = try? map.value(Keys.info.rawValue)
        imageUrl = try? map.value(Keys.imageUrl.rawValue)
        episodeNumber = try? map.value(Keys.episodeNumber.rawValue)
        season = try? map.value(Keys.season.rawValue)
        showId = try? map.value(Keys.showId.rawValue)
        type = try? map.value(Keys.type.rawValue)
    }
    
    mutating func mapping(map: Map) {
        id <- map[Keys.id.rawValue]
        title <- map[Keys.title.rawValue]
        info <- map[Keys.info.rawValue]
        imageUrl <- map[Keys.imageUrl.rawValue]
        episodeNumber <- map[Keys.episodeNumber.rawValue]
        season <- map[Keys.season.rawValue]
        showId <- map[Keys.showId.rawValue]
        type <- map[Keys.type.rawValue]
    }
    
}
