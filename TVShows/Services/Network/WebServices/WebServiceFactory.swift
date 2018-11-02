//
//  WebServiceFactory.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

class WebServiceFactoryAbstract {
    
    func loginService() -> WebService<LoginRequest, LoginResponse>? {
        return nil
    }
    
    func showListService() -> WebService<ShowListRequest, ShowListResponse>? {
        return nil
    }
    
    func showService() -> WebService<ShowRequest, ShowResponse>? {
        return nil
    }
    
    func episodesListService() -> WebService<EpisodesListRequest, EpisodesListResponse>? {
        return nil
    }
    
    func episodeService() -> WebService<EpisodeRequest, EpisodeResponse>? {
        return nil
    }
    
    func publishEpisodeService() -> WebService<PublishEpisodeRequest, PublishEpisodeResponse>? {
        return nil
    }
    
    func commentsService() -> WebService<CommentsRequest, CommentsResponse>? {
        return nil
    }
    
    func publishCommentService() -> WebService<PublishCommentRequest, PublishCommentResponse>? {
        return nil
    }
    
    func uploadMediaService() -> WebService<UploadMediaRequest, UploadMediaResponse>? {
        return nil
    }
}

class WebServiceFactory: WebServiceFactoryAbstract {
    
    override func loginService() -> WebService<LoginRequest, LoginResponse>? {
        return LoginService()
    }
    
    override func showListService() -> WebService<ShowListRequest, ShowListResponse>? {
        return ShowListService()
    }
    
    override func showService() -> WebService<ShowRequest, ShowResponse>? {
        return ShowService()
    }
    
    override func episodesListService() -> WebService<EpisodesListRequest, EpisodesListResponse>? {
        return EpisodesListService()
    }
    
    override func episodeService() -> WebService<EpisodeRequest, EpisodeResponse>? {
        return EpisodeService()
    }
    
    override func publishEpisodeService() -> WebService<PublishEpisodeRequest, PublishEpisodeResponse>? {
        return PublishEpisodeService()
    }
    
    override func commentsService() -> WebService<CommentsRequest, CommentsResponse>? {
        return CommentsService()
    }
    
    override func publishCommentService() -> WebService<PublishCommentRequest, PublishCommentResponse>? {
        return PublishCommentService()
    }
    
    override func uploadMediaService() -> WebService<UploadMediaRequest, UploadMediaResponse>? {
        return UploadMediaService()
    }
}
