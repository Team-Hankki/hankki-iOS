//
//  UserTargetType.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation
import Moya

enum UserTargetType {
    case getMe
    case getMeUniversity
    case getMeHankkiHeartList
    case getMeHankkiReportList
    case getMeZipList
    case postMeUniversity(requestBody: PostMeUniversityRequestDTO)
}

extension UserTargetType: BaseTargetType {
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var utilPath: UtilPath {
        return .user
    }
    
    var pathParameter: String? {
        return .none
    }
    
    var queryParameter: [String : Any]? {
        return .none
    }
    
    var requestBodyParameter: (any Codable)? {
        return .none
    }
    
    var path: String {
        switch self {
        case .getMe:
            return utilPath.rawValue
        case .getMeUniversity:
            return utilPath.rawValue
        case .getMeHankkiHeartList:
            return utilPath.rawValue + "university"
        case .getMeHankkiReportList:
            return utilPath.rawValue + "stores/hearts"
        case .getMeZipList:
            return utilPath.rawValue + "stores/reports"
        case .postMeUniversity:
            return utilPath.rawValue + "university"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMe:
            return .get
        case .getMeUniversity:
            return .get
        case .getMeHankkiHeartList:
            return .get
        case .getMeHankkiReportList:
            return .get
        case .getMeZipList:
            return .get
        case .postMeUniversity:
            return .post
        }
    }
    
    
}

