//
//  OfficialLink.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 14.04.2022.
//

import Foundation

public struct OfficialLink: Decodable {
    public let name: String
    public let url: URL
    
    public var linkType: LinkType? {
        LinkType(rawValue: name.lowercased())
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        name = try container.decode(String.self, forKey: .name).trimmingCharacters(in: .whitespacesAndNewlines)
        url = try container.decode(URL.self, forKey: .link)
    }
    
    @frozen
    enum Keys: String, CodingKey {
        case name
        case link
    }
}

extension OfficialLink: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}
