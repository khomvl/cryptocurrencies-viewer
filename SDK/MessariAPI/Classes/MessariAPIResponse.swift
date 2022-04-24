//
//  MessariAPIResponse.swift
//  ScalableSolutionsTestTask
//
//  Created by vladislav.khomyakov on 13.04.2022.
//

import Foundation

public struct MessariAPIResponse<T: Decodable>: Decodable {
    public struct Status: Decodable {
        public let elapsed: Int
        public let timestamp: String
        public let errorCode: Int?
        public let errorMessage: String?
    }
    
    public let status: Status
    public let data: T?
}
