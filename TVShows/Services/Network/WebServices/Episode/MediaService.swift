//
//  MediaService.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/2/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class UploadMediaRequest: WebServiceRequest {
    
    private(set) var url: URL?
    
    override var tag: WebServiceTag? {
        return WebServiceTag.media
    }
    
    convenience init(url: URL) {
        self.init()
        self.url = url
    }

}

class UploadMediaResponse: WebServiceResponse {
    
    private(set) var result: MediaWebModel?
    
    override func parseDataDictionary(_ data: [String : AnyObject]) {
        result = MediaWebModel(JSON: data)
    }
    
}

class UploadMediaService: WebService<UploadMediaRequest, UploadMediaResponse> {
    
    override func performRequest(_ request: UploadMediaRequest?, retryIfNeeded retry: Bool, completion: ((UploadMediaResponse) -> Void)?) -> Bool {
        
        if let request = request, let url = request.url {
            
            guard let URLString = WebServiceURLStringBuilder(baseUrl: self.baseURLString)?.appendEndpoint(request.endpoint).build() else {
                return false
            }
            
            if let authHeaders = authService?.authorizationHeaders(), request.headers != nil {
                for (key, value) in authHeaders {
                    request.headers![key] = value
                }
            }
            
            if request.headers == nil {
                request.headers = authService?.authorizationHeaders()
            }
            
            manager.upload(multipartFormData: { formData in
                formData.append(url, withName: "file")
            }, to: URLString,
               method: request.method,
               headers: request.headers) { encodingResult in
                switch encodingResult {
                case .success(let uploadRequest, _, _): do {
                    uploadRequest.validate(statusCode: 200...500).responseJSON(completionHandler: { response in
                        let processBlock = {
                            if self.removeRequestWhenComplete == true {
                                self.removeRequest(withKey: request.identifier)
                            }
                            
                            let result = UploadMediaResponse(source: response.result.value as AnyObject, error: response.result.error as NSError?, statusCode:response.response?.statusCode)
                            result.process(nativeResponse: response.response)
                            self.response = result
                            completion?(result)
                        }
                        
                        if let _authService = self.authService, let _response = response.response, retry == true {
                            if _authService.isContainAuthError(_response) {
                                _authService.relogin({ (success) in
                                    if success {
                                        if !self.performRequest(request, retryIfNeeded: false, completion: completion) {
                                            processBlock()
                                        }
                                    } else {
                                        processBlock()
                                    }
                                })
                            } else {
                                processBlock()
                            }
                        } else {
                            processBlock()
                        }
                    })
                    
                    self.addRequest(request: uploadRequest, forKey: request.identifier)
                    uploadRequest.resume()
                    
                    }
                case .failure(let err): do {
                    completion?(UploadMediaResponse(source: nil, error: err, statusCode:400))
                    }
                }
            }
            
            return true
        } else {
            return false
        }
    }
    
}

class UploadMediaCommand: Command<UploadMediaRequest, UploadMediaResponse> {
    
    internal override func constructService() -> WebService<UploadMediaRequest, UploadMediaResponse>? {
        return factory.uploadMediaService()
    }
}
