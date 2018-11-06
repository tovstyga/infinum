//
//  CommentsInteractor.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/6/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

class CommentsInteractor {
    
    private var source: [CommentWebModel] = []
    private let episode: EpisodeWebModel
    private var _comments: [CommentCellModel] = []
    
    init(episode: EpisodeWebModel) {
        self.episode = episode
    }
    
}

extension CommentsInteractor: CommentsInteractorProtocol {
    
    var comments: [CommentCellModelProtocol] {
        return _comments
    }
    
    func postComment(comment: String, completion: @escaping (Error?) -> Void) {
        
        PublishCommentCommand(request: PublishCommentRequest(episodeId: episode.id, text: comment)) { [weak self] response in
            guard let `self` = self else {
                return
            }
            
            if let publishedModel = response?.result {
                self.source.append(publishedModel)
                self._comments.append(CommentCellModel(imageUrl: nil, userName: publishedModel.userEmail, comment: publishedModel.text))
            }
            
            DispatchQueue.main.async {
                completion(response?.error)
            }
            
        }.perform()
    }
    
    func reload(completion: @escaping (Error?) -> Void) {
        
        CommentsCommand(request: CommentsRequest(episodeIdentifier: episode.id)) { [weak self] response in
            guard let `self` = self else { return }
            
            self.source = response?.result ?? []
            self._comments = self.source.map({ model -> CommentCellModel in
                return CommentCellModel(imageUrl: nil, userName: model.userEmail, comment: model.text)
            })
            DispatchQueue.main.async {
                completion(response?.error)
            }
        }.perform()
        
    }
    
    
}
