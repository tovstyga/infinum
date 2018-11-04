//
//  Constants.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

enum Domains: String {
    case network = "com.instinctools.TVShows.network"
    case common = "com.instinctools.TVShows"
}

extension Notification.Name {

    enum app {
        static let credentialsChanged = Notification.Name("credential_changed_notification")
        static let invalidCredentialsNotification = Notification.Name("invalid_credentials_notification_name")
    }
    
}
