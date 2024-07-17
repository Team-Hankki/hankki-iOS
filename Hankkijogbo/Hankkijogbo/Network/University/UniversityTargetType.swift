//
//  UniversityTargetType.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

import Moya

enum UniversityTargetType {
    case getUniversityList
}

extension UniversityTargetType: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .getUniversityList:
            return .accessTokenHeader
        }
    }
    
    var utilPath: UtilPath {
        return .university
    }
    
    var pathParameter: String? {
        return .none
    }
    
    var queryParameter: [String: Any]? {
        return .none
    }
    
    var requestBodyParameter: (any Codable)? {
        switch self {
        case .getUniversityList: return .none
        }
    }
    
    var path: String {
        switch self {
        case .getUniversityList:
            return utilPath.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUniversityList: return .get
        }
    }    
}
