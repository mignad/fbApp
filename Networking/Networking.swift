//
//  Networking.swift
//  fbApp
//
//  Created by Ioana Gadinceanu on 17/02/2019.
//  Copyright © 2019 Ioana Gadinceanu. All rights reserved.
//

import Foundation
import Alamofire

class Networking {
    
    static func getMyProfile(_ callback: @escaping ((User?, Error?)) ->() ) {
        guard let token = Session.authToken else { return }
        
        let baseUrl = "https://graph.facebook.com/me?fields=id,name,birthday,email&access_token=\(token)"
        
        Alamofire.request(baseUrl, method: .get, encoding: JSONEncoding.default).responseData
            { response in
                switch response.result {
                case .success:
                    let user = try? JSONDecoder().decode(User.self, from: response.result.value!)
                    callback((user, nil))
                case .failure(let error):
                    callback((nil, error))
                }
        }
    }
    
    static func getUserAlbums(_ callback: @escaping (([Album], Error? )) ->() ) {
        guard let token = Session.authToken else { return }
        
        if let id = Session.userId {
            let baseUrl = "https://graph.facebook.com/" + id + "/albums?access_token=\(token)"
            
            Alamofire.request(baseUrl, method: .get, encoding: JSONEncoding.default).responseData
                { response in
                    switch response.result {
                    case .success:
                        if let data = response.result.value, let wrapper = try? JSONDecoder().decode(AlbumWrapper.self, from: data) {
                            callback((wrapper.albums, nil))
                        } else {
                            callback(([], nil))
                        }
                    case .failure(let error):
                        callback(([], error))
                    }
            }
        }
    }
    
    static func getNewsFeed(_ callback: @escaping (([NewsFeedItem], Error?)) ->() ) {
        guard let token = Session.authToken else { return }
        guard let id = Session.userId  else { return }
        
        let params = ["fields": "picture, message", "access_token": token, "limit": 15] as [String : Any]
        let baseUrl = "https://graph.facebook.com/" + id + "/posts"
        
        Alamofire.request(baseUrl, method: .get, parameters: params).responseData { response in
            switch response.result {
            case .success:
                if let data = response.result.value, let wrapper = try? JSONDecoder().decode(NewsFeedWrapper.self, from: data) {
                    callback((wrapper.feedItems, nil))
                } else {
                    callback(([], nil))
                }
            case .failure(let error ):
                callback(([], error))
            }
        }
    }
    
    
    static func getNextPageFeed(_ callback: @escaping (([NewsFeedItem], Error?)) ->() ) {
        
        Alamofire.request(NewsFeedPage.next, method: .get).responseData { response in
            switch response.result {
            case .success:
                if let data = response.result.value, let wrapper = try? JSONDecoder().decode(NewsFeedWrapper.self, from: data) {
                    callback((wrapper.feedItems, nil))
                } else {
                    callback(([], nil))
                }
            case .failure(let error ):
                callback(([], error))
            }
        }
    }
    
    
    static func getPhotos(for albumId: String, _ callback: @escaping (([Photo], Error?)) ->() ) {
        guard let token = Session.authToken else { return }
        
        
        let baseUrl = "https://graph.facebook.com/\(albumId)/photos?fields=source,name&access_token=\(token)"
        
        Alamofire.request(baseUrl, method: .get, encoding: JSONEncoding.default).responseData { response in
            switch response.result {
            case .success:
                if let data = response.result.value, let wrapper = try? JSONDecoder().decode(PhotoWrapper.self, from: data) {
                    callback((wrapper.photos, nil))
                } else {
                    callback(([],nil))
                }
            case .failure(let error ):
                callback(([], error))
            }
        }
    }
}




