//
//  LinkType.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 14.04.2022.
//

import Foundation
import UIKit

@frozen
public enum LinkType: String, Decodable {
    case whitepaper
    case website
    case twitter
    case facebook
    case reddit
    case github
    case telegram
    case youtube
    case linkedin
    case medium
    case instagram
    case tiktok
    
    public var image: UIImage? {
        UIImage(named: self.rawValue, in: .main, compatibleWith: nil)
    }
}
