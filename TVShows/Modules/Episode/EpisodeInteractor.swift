//
//  EpisodeInteractor.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/5/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

class EpisodeInteractor {
    
    private var episode: EpisodeWebModel?
    private var baseUrlString: String? = WebConfiguration(webServiceTag: .base)?.baseUrl
    
    init(episode: EpisodeWebModel?) {
        self.episode = episode
    }
    
}

extension EpisodeInteractor: ShowDetailsInteractorProtocol {
    
    var episodes: [EpisodeCellModelProtocol] {
        return []
    }
    
    var showInfo: ShowDescriptionModelProtocol {
        return EpisodeInfoModel(title: episode?.title, info: episode?.info, season: episode?.season, number: episode?.episodeNumber)
    }
    
    var imageUrl: URL? {
        guard let base = baseUrlString, let imageUrl = episode?.imageUrl, let url = URL(string: base + imageUrl) else {
            return nil
        }
        
        return url
    }
    
    func reloadData(completion: @escaping ((Error?) -> Void)) {
        
        guard let id = episode?.id else {
            completion(nil)
            return
        }
        
        let request = EpisodeRequest(id: id)
        EpisodeCommand.init(request: request) { [weak self] response in
            guard let `self` = self else { return }
            
            if let model = response?.result {
                self.episode = model
            }
            
            DispatchQueue.main.async {
                completion(response?.error)
            }
            
        }.perform()
        
    }
    
    func identifierForModel(_ model: EpisodeCellModelProtocol) -> String? {
        return nil
    }
    
    
}
