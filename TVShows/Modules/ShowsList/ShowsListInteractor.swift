//
//  ShowsListInteractor.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/4/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

class ShowsListInteractor {
    
    private var _data: [ShowListCellModel] = []
    private var source: [ShowWebModel] = []
    
    private var baseUrlString: String? = WebConfiguration(webServiceTag: .base)?.baseUrl
    
}

extension ShowsListInteractor: ShowsListInteractorProtocol {
    
    var data: [ShowListCellModelProtocol] {
        return _data
    }
    
    func reloadData(completion: @escaping ((Error?) -> Void)) {
        ShowListCommand(request: ShowListRequest()) {[weak self] response in
            DispatchQueue.main.async {
                guard let `self` = self else {
                    return
                }
                
                self.source = response?.result ?? []
                self._data = self.source.map({ model -> ShowListCellModel in
                    guard   let urlString = model.imageUrl,
                            let baseUrl = self.baseUrlString,
                            let url = URL(string: baseUrl + urlString) else {
                        return ShowListCellModel(identifier: model.id, title: model.title, url: nil)
                    }
                    
                    return ShowListCellModel(identifier: model.id, title: model.title, url: url)
                })
                
                completion(response?.error)
            }
        }.perform()
    }
    
    func identifierForModel(_ model: ShowListCellModelProtocol) -> String? {
        return _data.filter { show -> Bool in
            return model === show
        }.first?.identifier
    }
    
}

extension ShowsListInteractor: ShowsListCoordinatorDataSource {
    
    func findShow(identifier: String) -> ShowWebModel? {
        return source.filter({ (model) -> Bool in
            return model.id == identifier
        }).first
    }
    
}
