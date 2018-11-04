//
//  CredentialService.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/3/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

class CredentialService {
    
    private struct Credentials {
        var username: String
        var password: String
    }
    
    private enum Tag: String {
        case user = "TVShows.user"
        case token = "TVShows.token"
    }
    
    private(set) var userName: String?
    private(set) var password: String?
    private(set) var token: String?
    
    var isUserSaved: Bool {
        return userName != nil && password != nil
    }
    
    private var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    private var notificationCenret: NotificationCenter {
        return NotificationCenter.default
    }
    
    init() {
        update()
        notificationCenret.addObserver(self, selector: #selector(CredentialService.update), name: Notification.Name.app.credentialsChanged, object: nil)
    }
    
    deinit {
        notificationCenret.removeObserver(self)
    }
    
    func saveUserData(userName: String, password: String, token: String) -> Error? {
        
        if let error = saveCredentials(CredentialService.Credentials(username: userName, password: password)) {
            return error
        }
        
        defaults.setValue(userName, forKey: Tag.user.rawValue)
        defaults.setValue(token, forKey: Tag.token.rawValue)
        
        self.token = token
        self.userName = userName
        self.password = password
        
        notificationCenret.post(name: Notification.Name.app.credentialsChanged, object: nil, userInfo: nil)
        
        return nil
    }
    
    func updateToken(_ token: String) {
        defaults.setValue(token, forKey: Tag.token.rawValue)
        self.token = token
        notificationCenret.post(name: Notification.Name.app.credentialsChanged, object: nil, userInfo: nil)
    }
    
    func removeAll() {
        removeCredentials()
        defaults.removeObject(forKey: Tag.token.rawValue)
        token = nil
        password = nil
        notificationCenret.post(name: Notification.Name.app.credentialsChanged, object: nil, userInfo: nil)
    }
    
    @objc private func update() {
        userName = defaults.string(forKey: Tag.user.rawValue)
        token = defaults.string(forKey: Tag.token.rawValue)
        if let user = userName, let pass = loadCredentials(account: user).credentials?.password {
            password = pass
        }
    }
    
    private func saveCredentials(_ credentials: Credentials) -> Error? {
        
        let encodedPassword = credentials.password.data(using: String.Encoding.utf8)!
        removeCredentials()
        
        var item = keychainQuery(withService: Domains.common.rawValue, account: credentials.username)
        item[kSecValueData as String] = encodedPassword as AnyObject?
        
        let status = SecItemAdd(item as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            return NSError.keychainError
        }
    
        return nil
    }
    
    private func removeCredentials() {
        
        let query = keychainQuery(withService: Domains.common.rawValue, account: userName)
        SecItemDelete(query as CFDictionary)
        
    }
    
    private func loadCredentials(account: String) -> (credentials: Credentials?, error: Error?) {
        
        var query = keychainQuery(withService: Domains.common.rawValue, account: account)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard status == errSecSuccess else {
            return (nil, NSError.keychainError)
        }
        
        guard let existingItem = queryResult as? [String : AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let storedAccount = existingItem[kSecAttrAccount as String] as? String
            else {
                return (nil, NSError.keychainError)
        }
        
        let credentials = Credentials(username: storedAccount, password: password)

        return (credentials, nil)
    }
    
    private func keychainQuery(withService service: String, account: String? = nil) -> [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        return query
    }
    
}
