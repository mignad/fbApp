//
//  AlbumPhotos.swift
//  fbApp
//
//  Created by Ioana Gadinceanu on 22/02/2019.
//  Copyright © 2019 Ioana Gadinceanu. All rights reserved.
//

import Foundation

struct PhotoWrapper: Decodable {
    var photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case photos = "data"
    }
    
    init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        
        let alb = (try? container?.decode([Photo].self, forKey: .photos)) ?? []
        photos = alb ?? []
    }
}

struct Photo: Decodable {
    var text = ""
    var id = ""
    var photoUrl = ""

    enum CodingKeys: String, CodingKey {
        case text = "name"
        case photoUrl = "source"
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = (try? container.decode(String.self, forKey: .text)) ?? ""
        id = (try? container.decode(String.self, forKey: .id)) ?? ""
        photoUrl = (try? container.decode(String.self, forKey: .photoUrl)) ?? ""
    }
}
