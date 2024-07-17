//
//  LocationTargetType.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/17/24.
//

import Foundation

import Moya

enum LocationTargetType {
    case getSearchedLocation(query: String)
}

extension LocationTargetType: BaseTargetType {
    var headerType: HeaderType { return .accessTokenHeader }
    var utilPath: UtilPath { return .location }
    
    var pathParameter: String? {
        switch self {
        case .getSearchedLocation:
            return .none
        }
    }
    
    var queryParameter: [String: Any]? {
        switch self {
        case .getSearchedLocation(let query):
            return .some(["query": query])
        }
    }
    
    var requestBodyParameter: Codable? {
        return .none
    }
    
    var path: String {
        switch self {
        case .getSearchedLocation:
            return utilPath.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSearchedLocation: .get
        }
    }
}
