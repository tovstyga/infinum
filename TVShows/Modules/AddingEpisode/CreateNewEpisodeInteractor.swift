//
//  CreateNewEpisodeInteractor.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/6/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

class CreateNewEpisodeInteractor  {
    
    private let show: ShowWebModel
    
    init(show: ShowWebModel) {
        self.show = show
    }
    
}

extension CreateNewEpisodeInteractor: CreateNewEpisodeInteractorProtocol {
    
    func publishEpisode(title: String?, info: String?, episode: Int, season: Int, image: UIImage, completion: @escaping ((_ error: Error?) -> Void)) {
        
        DispatchQueue.main.async {
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            guard let data = image.jpegData(compressionQuality: 1.0), let path = (paths.first as NSString?)?.appendingPathComponent("image_for_upload.png") else {
                DispatchQueue.main.async {
                    completion(NSError.commonError)
                }
                return
            }
            
            let imageFileUrl = URL(fileURLWithPath: path)
            
            try? FileManager.default.removeItem(at: imageFileUrl)
            
            do {
                try data.write(to: imageFileUrl)
            } catch {
                DispatchQueue.main.async {
                    completion(NSError.commonError)
                }
                return
            }
            
            self.publishEpisode(title: title, info: info, episode: episode, season: season, imageUrl: imageFileUrl, completion: completion)
            
        }
        
    }
    
    func publishEpisode(title: String?, info: String?, episode: Int, season: Int, imageUrl: URL, completion: @escaping ((Error?) -> Void)) {
        DispatchQueue.global().async {
            
            let semaphore = DispatchSemaphore(value: 0)
            var mediaId: String?
            UploadMediaCommand(request: UploadMediaRequest(url: imageUrl), result: { response in
                mediaId = response?.result?.identifier
                if response?.error != nil {
                    DispatchQueue.main.async {
                        completion(response?.error)
                    }
                }
                semaphore.signal()
            }).perform()
            
            semaphore.wait()
            
            guard let id = mediaId else {
                return
            }
            
            let request = PublishEpisodeRequest.init(showId: self.show.id, mediaId: id, title: title, info: info, number: "\(episode)", season: "\(season)")
            PublishEpisodeCommand(request: request, result: { response in
                DispatchQueue.main.async {
                    completion(response?.error)
                }
            }).perform()
            
        }
    }
    
    var episodeMaxNumber: Int {
        return 100
    }
    
    var seasonMaxNumber: Int {
        return 100
    }
    
}
