//
//  BaseNetworkingService.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import Alamofire

class BaseNetworkingService {
    
    fileprivate var requests: [String: Alamofire.Request] = [:]
    
    internal var baseServiceTag: WebServiceTag {
        return .base
    }
    
    internal var baseURLString: String? {
        return WebConfiguration(webServiceTag: baseServiceTag)?.baseUrl
    }
    
    var additionalHeaders: [AnyHashable: Any]? {
        return nil
    }
    
    var configuration: URLSessionConfiguration {
        let defaultHeaders = Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders
        var resultDictionary = [AnyHashable: Any]()
        if let _defaultHeaders = defaultHeaders {
            resultDictionary += _defaultHeaders
        }
        if let _additionalHeaders = self.additionalHeaders {
            resultDictionary += _additionalHeaders
        }
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = resultDictionary
        config.timeoutIntervalForRequest = 2 * 60
        config.timeoutIntervalForResource = 2 * 60
        return config
    }
    
    var _manager: Alamofire.SessionManager? = nil
    var manager: Alamofire.SessionManager {
        if _manager == nil {
            _manager = Alamofire.SessionManager(configuration: configuration)
            _manager?.startRequestsImmediately = false
        }
        return _manager!
    }
    
    var removeRequestWhenComplete: Bool {
        return true
    }
}

extension BaseNetworkingService {
    
    internal func addRequest(request: Alamofire.Request, forKey key: String) {
        self.requests.updateValue(request, forKey: key)
    }
    
    internal func removeRequest(withKey key: String) {
        self.requests.removeValue(forKey: key)
    }
    
    internal func removeAll() {
        self.requests.removeAll()
    }
    
    internal func cancelRequest(withKey key: String) {
        if let data = self.requests[key] {
            data.cancel()
        }
    }
    
    internal func cancelAll() {
        for data in self.requests.values {
            data.cancel()
        }
    }
}

class URLStringBuilder {
    fileprivate var result: String
    fileprivate var hasFirstParameter = false

    init() {
        result = String()
    }

    convenience init?(baseUrl: String?) {
        guard let x = baseUrl else { return nil }
        guard URL(string: x) != nil else { return nil }
        self.init()
        result = removeTrailingSlash(x)
    }

    @discardableResult
    func append(_ part: String?) -> URLStringBuilder {
        if let x = part {
            result += "/" + removeTrailingSlash(removeLeadingSlash(x))
        }
        return self
    }

    @discardableResult
    func appendPathParameter(_ name: String, value: String?) -> URLStringBuilder {
        if let value = value {
            if self.hasFirstParameter {
                self.result += "&"
            } else {
                self.result += "?"
                self.hasFirstParameter = true
            }
            self.result += name
            self.result += "="
            self.result += value
        }
        return self
    }

    func build() -> String? {
        return result.removingPercentEncoding
    }

    func buildUrl() -> URL? {
        var result: URL?
        if let x = build()?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            result = URL(string: x)
        }
        return result
    }

    fileprivate func removeTrailingSlash(_ aSrc: String) -> String {
        var result = aSrc
        if result.hasSuffix("/") {
            let index = result.index(before: result.endIndex)
            result = String(result[..<index])
        }
        return result
    }

    fileprivate func removeLeadingSlash(_ aSrc: String) -> String {
        var result = aSrc
        if result.hasPrefix("/") {
            let index = result.index(after: result.startIndex)
            result = String(result[index...])
        }
        return result
    }

}

class WebServiceURLStringBuilder {

    fileprivate var builder: URLStringBuilder

    convenience init?(serviceAlias: WebServiceTag) {
        if let baseUrl = WebConfiguration(webServiceTag: serviceAlias)?.baseUrl {
            self.init(baseUrl: baseUrl)
        } else {
            return nil
        }
    }

    init?(baseUrl: String?) {
        if let x = URLStringBuilder(baseUrl: baseUrl) {
            self.builder = x
        } else {
            return nil
        }
    }

    func append() -> WebServiceURLStringBuilder {
        return self
    }

    func appendEndpoint(_ endpoint: String?) -> WebServiceURLStringBuilder {
        _ = builder.append(endpoint)
        return self
    }

    func build() -> String? {
        return builder.build()
    }

}
