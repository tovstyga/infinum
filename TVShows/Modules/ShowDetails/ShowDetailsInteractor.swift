//
//  ShowDetailsInteractor.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/5/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

class ShowDetailsInteractor {
    
    private var show: ShowWebModel
    private var showInfoUpdated: Bool = false
    private var _episodes: [EpisodeCellModel] = []
    private var source: [EpisodeWebModel] = []
    private var baseUrlString: String? = WebConfiguration(webServiceTag: .base)?.baseUrl
    
    init(show: ShowWebModel) {
        self.show = show
    }
    
}

extension ShowDetailsInteractor: ShowDetailsInteractorProtocol {
    
    var imageUrl: URL? {
        guard let base = baseUrlString, let imageUrl = show.imageUrl, let url = URL(string: base + imageUrl) else {
            return nil
        }
        
        return url
    }
    
    var episodes: [EpisodeCellModelProtocol] {
        return _episodes
    }
    
    var showInfo: ShowDescriptionModelProtocol {
        return ShowDescriptionModel(title: show.title, info: show.info)
    }
    
    func reloadData(completion: @escaping ((Error?) -> Void)) {
        
        DispatchQueue.global().async {
            
            let group = DispatchGroup()
            var operationError: Error?
            
            if (self.showInfoUpdated == false) {
                group.enter()
                ShowCommand(request: ShowRequest(identifier: self.show.id)) {[weak self] response in
                    guard let `self` = self else {
                        group.leave()
                        return
                    }
                    
                    if let error = response?.error {
                        operationError = error
                        group.leave()
                        return
                    }
                    
                    guard let updatedShow = response?.result else {
                        group.leave()
                        return
                    }
                    
                    self.showInfoUpdated = true
                    self.show = updatedShow
                    
                    group.leave()
                }.perform()
            }
            
            group.enter()
            EpisodesListCommand(request: EpisodesListRequest(showIdentifier: self.show.id), result: {[weak self] response in
                guard let `self` = self else {
                    group.leave()
                    return
                }
                
                if let error = response?.error {
                    operationError = error
                }
                
                self.source = response?.result ?? []
                self._episodes = self.source.map({ webModel -> EpisodeCellModel in
                    return EpisodeCellModel(identifier: webModel.id, name: webModel.title, number: webModel.episodeNumber, season: webModel.season)
                })
                
                group.leave()
            }).perform()
            
            group.notify(queue: DispatchQueue.main, execute: { [weak self] in
                guard let _ = self else {
                    return
                }
                
                completion(operationError)
            })
        }
        
    }
    
    func identifierForModel(_ model: EpisodeCellModelProtocol) -> String? {
        return _episodes.filter({ episode -> Bool in
            return episode === model
        }).first?.identifier
    }
    
}

extension ShowDetailsInteractor: ShowDetailsCoordinatorDataSource {
    
    func findEpisode(identifier: String) -> EpisodeWebModel? {
        return source.filter({ (model) -> Bool in
            return model.id == identifier
        }).first
    }
    
}
