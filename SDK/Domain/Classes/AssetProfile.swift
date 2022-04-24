//
//  AssetProfile.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 14.04.2022.
//

import Foundation

public struct AssetProfile {
    public let tagline: String?
    public let projectDetails: String
    public let officialLinks: [OfficialLink]
    
    @frozen
    enum Keys: String, CodingKey {
        case profile
        
        @frozen
        enum ProfileKeys: String, CodingKey {
            case general
            
            @frozen
            enum GeneralKeys: String, CodingKey {
                case overview
                
                @frozen
                enum OverviewKeys: String, CodingKey {
                    case tagline
                    case projectDetails
                    case officialLinks
                }
            }
        }
    }
}

extension AssetProfile: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let profileContainer = try container.nestedContainer(
            keyedBy: Keys.ProfileKeys.self,
            forKey: .profile
        )
        let generalContainer = try profileContainer.nestedContainer(
            keyedBy: Keys.ProfileKeys.GeneralKeys.self,
            forKey: .general
        )
        let overviewContainer = try generalContainer.nestedContainer(
            keyedBy: Keys.ProfileKeys.GeneralKeys.OverviewKeys.self,
            forKey: .overview
        )
        
        tagline = try overviewContainer.decode(String?.self, forKey: .tagline)
        projectDetails = try overviewContainer.decode(String.self, forKey: .projectDetails)
        officialLinks = try overviewContainer.decode([OfficialLink]?.self, forKey: .officialLinks) ?? []
    }
}


