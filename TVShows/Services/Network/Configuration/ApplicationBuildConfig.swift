//
//  ApplicationBuildConfig.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

class ApplicationBuildConfig {
    
    enum ApplicationConfigItem: String {
        case apiConfiguration = "API_CONFIGURATION"
    }
    
    func valueFor(_ argument: ApplicationConfigItem) -> String? {
        if let config = buildConfig {
            return config[argument.rawValue] as? String
        }
        return nil
    }
    
    fileprivate let buildConfig = Bundle.main.infoDictionary
}
