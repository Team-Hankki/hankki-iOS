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
    
    var queryParameter: [String: Any]? {
        return .none
    }
    
    var requestBodyParameter: (any Codable)? {
        switch self {
        case .postMeUniversity(requestBody: let requestBody):
            return requestBody
        default:
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .getMe:
            return utilPath.rawValue + "/me"
        case .getMeUniversity:
            return utilPath.rawValue + "/me/university"
        case .getMeHankkiHeartList:
            return utilPath.rawValue + "/me/stores/hearts"
        case .getMeHankkiReportList:
            return utilPath.rawValue + "/me/stores/reports"
        case .getMeZipList:
            return utilPath.rawValue + "/me/favorites"
        case .postMeUniversity:
            return utilPath.rawValue + "/me/university"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMe, .getMeUniversity, .getMeHankkiHeartList, .getMeHankkiReportList, .getMeZipList:
            return .get
        case .postMeUniversity: 
             return .post
        }
    }
    
    var loadingViewType: LoadingViewType {
        switch self {
        case .getMeHankkiHeartList, .getMeHankkiReportList, .getMeZipList: return .fullView
        case .postMeUniversity: return .submit
        default: return .none
        }
    }
}
