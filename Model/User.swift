import Foundation

struct User: Decodable {
    var nume = ""
    var albums  = [Album]()
    var newsFeedItems = [NewsFeedItem]()
    
    enum CodingKeys: String, CodingKey {
        case nume = "name"
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nume = (try? container.decode(String.self, forKey: .nume)) ?? ""
    }
}

struct AlbumWrapper: Decodable {
    var albums: [Album]
    
    enum CodingKeys: String, CodingKey {
        case albums = "data"
    }
    
    init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        
        let alb = (try? container?.decode([Album].self, forKey: .albums)) ?? []
        albums = alb ?? []
        print(albums)
    }
}

struct Album: Decodable {
    var coverPhoto = ""
    var title = ""
    var id = ""
    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case id
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        id = (try? container.decode(String.self, forKey: .id)) ?? ""
    }
    
}

struct NewsFeedPage: Decodable {
    static var next = ""
}


struct NewsFeedWrapper: Decodable {
    var feedItems = [NewsFeedItem]()
    
    enum CodingKeys: String, CodingKey {
        case feedItems = "data"
        case paging, next
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        feedItems = (try? container.decode([NewsFeedItem].self, forKey: .feedItems)) ?? []
        
        if let aContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .paging) {
            let next = (try? aContainer.decode(String.self, forKey: .next)) ?? ""
            NewsFeedPage.next = next
        }
    }
}

struct NewsFeedItem: Decodable {
    var newsPhoto = ""
    var story = ""
    var id = ""
    
    enum CodingKeys: String, CodingKey {
        case story = "message"
        case newsPhoto = "picture"
        case id
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        newsPhoto = (try? container.decode(String.self, forKey: .newsPhoto)) ?? ""
        story = (try? container.decode(String.self, forKey: .story)) ?? ""
        id = (try? container.decode(String.self, forKey: .id)) ?? ""
    }
}


