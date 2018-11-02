//
//  DictionaryBuilder.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

class DictionaryBuilder {
    fileprivate var result = [String: Any]()
    
    init() {}
    
    init(dictionary: [String: Any]?) {
        if let x = dictionary {
            result = x
        }
    }
    
    @discardableResult
    func add(_ key: String, value: Any?) -> DictionaryBuilder {
        if let _value = value, !(value is NSNull) {
            result[key] = _value
        }
        return self
    }
    
    @discardableResult
    func add(_ dictionary: [String: Any]?) -> DictionaryBuilder {
        guard let _dictionary = dictionary else {
            return self
        }
        
        for key in _dictionary.keys {
            result[key] = _dictionary[key]
        }
        return self
    }
    
    func build() -> [String: Any] {
        return result
    }
}
