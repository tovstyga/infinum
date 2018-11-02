//
//  WebConfiguration.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

enum APIConfiguration: String {
    case develop = "Dev"
    case production = "Prod"
}

enum WebServiceTag: String {
    case base = "BaseURL"
    case login = "Login"
    case showList = "ShowList"
    case show = "Show"
    case episode = "Episode"
    case episodes = "Episodes"
    case media = "Media"
    case commects = "Comments"
    case addComment = "AddComment"
    case addEpisode = "AddEpisode"
}

final class WebConfiguration {
    
    let tag: WebServiceTag
    let baseUrl: String
    let configuration: APIConfiguration
    
    init?(webServiceTag: WebServiceTag) {
        tag = webServiceTag
        configuration = APICallConfigurationLoader.sharedLoader.defaultConfiguration
        if let url = APICallConfigurationLoader.sharedLoader.loadAPICallsURLForService(tag) {
            baseUrl = url
        } else {
            return nil;
        }
    }
}

final class APICallConfigurationLoader {
    
    typealias ServiceConfiguration = [String: AnyObject]
    typealias Configuration = [String: String]
    typealias APICallsConfigurationSettings = [String: ServiceConfiguration]
    
    fileprivate struct Keys {
        static let fileName = "APICallsConfigurations"
        static let configurationsKey = "Configurations"
    }
    
    static let sharedLoader = APICallConfigurationLoader()
    
    fileprivate let appConfig = ApplicationBuildConfig()
    let defaultConfiguration: APIConfiguration
    
    fileprivate(set) lazy var settings: APICallsConfigurationSettings = {
        if let path = Bundle.main.path(forResource: Keys.fileName, ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? APICallsConfigurationSettings {
            return dict
        }
        return APICallsConfigurationSettings()
    }()
    
    init() {
        if  let config = appConfig.valueFor(ApplicationBuildConfig.ApplicationConfigItem.apiConfiguration),
            let configuration = APIConfiguration(rawValue: config) {
            defaultConfiguration = configuration
        } else {
            defaultConfiguration = .production
        }
    }
    
    func loadAPICallsURLForService(_ service: WebServiceTag) -> String? {
        
        guard let apiUrl = loadAPICallsURLForService(service, configuration: defaultConfiguration) else {
            return nil
        }
        return apiUrl
    }
    
    fileprivate func loadAPICallsURLForService(_ service: WebServiceTag, configuration: APIConfiguration) -> String? {
        return (settings[service.rawValue]?[Keys.configurationsKey] as? Configuration)?[configuration.rawValue]
    }

}
