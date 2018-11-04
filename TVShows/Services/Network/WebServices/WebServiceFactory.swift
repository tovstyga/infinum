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
    
    private let authService: AuthorizationServiceProtocol = AuthorizationService(service: CredentialService())
    
    override func loginService() -> WebService<LoginRequest, LoginResponse>? {
        return LoginService()
    }
    
    override func showListService() -> WebService<ShowListRequest, ShowListResponse>? {
        let service = ShowListService()
        service.authService = authService
        return service
    }
    
    override func showService() -> WebService<ShowRequest, ShowResponse>? {
        let service = ShowService()
        service.authService = authService
        return service
    }
    
    override func episodesListService() -> WebService<EpisodesListRequest, EpisodesListResponse>? {
        let service = EpisodesListService()
        service.authService = authService
        return service
    }
    
    override func episodeService() -> WebService<EpisodeRequest, EpisodeResponse>? {
        let service = EpisodeService()
        service.authService = authService
        return service
    }
    
    override func publishEpisodeService() -> WebService<PublishEpisodeRequest, PublishEpisodeResponse>? {
        let service = PublishEpisodeService()
        service.authService = authService
        return service
    }
    
    override func commentsService() -> WebService<CommentsRequest, CommentsResponse>? {
        let service = CommentsService()
        service.authService = authService
        return service
    }
    
    override func publishCommentService() -> WebService<PublishCommentRequest, PublishCommentResponse>? {
        let service = PublishCommentService()
        service.authService = authService
        return service
    }
    
    override func uploadMediaService() -> WebService<UploadMediaRequest, UploadMediaResponse>? {
        let service = UploadMediaService()
        service.authService = authService
        return service
    }
}
