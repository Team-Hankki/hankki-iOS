//
//  UniversityTargetType.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation
import Moya

enum UniversityTargetType {
    case getUniversities
}

extension UniversityTargetType: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .getUniversities:
            return .accessTokenHeader
        }
    }
    
    var utilPath: UtilPath {
        return .university
    }
    
    var pathParameter: String? {
        return .none
    }
    
    var queryParameter: [String : Any]? {
        return .none
    }
    
    var requestBodyParameter: (any Codable)? {
        switch self {
        case .getUniversities:
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .getUniversities:
            return utilPath.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUniversities:
            return .get
        }
    }    
}


