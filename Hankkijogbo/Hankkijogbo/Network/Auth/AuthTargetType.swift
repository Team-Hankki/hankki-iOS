//
//  File.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

import Moya

enum AuthTargetType {
    case postReissue
    case postLogin(requestBody: PostLoginRequestDTO)
    case deleteWithdraw
    case patchLogout
}

extension AuthTargetType: BaseTargetType {
    var headerType: HeaderType {
        // TODO: - Header 타입 Base Target Type 에 추가하기
        switch self {
        case .postReissue:
            return .refreshTokenHeader
        case .postLogin(let requestBody):
            return .loginHeader(accessToken: requestBody.identifyToken)
        case .deleteWithdraw:
            return .accessTokenHeader
        case .patchLogout:
            return .accessTokenHeader
        }
    }
    
    var utilPath: UtilPath { return .auth }
    
    var pathParameter: String? {
        return .none
    }
    
    var queryParameter: [String: Any]? {
        return .none
    }
    
    var requestBodyParameter: (any Codable)? {
        switch self {
        case .postReissue: return .none
        case .postLogin(let requestBody): return requestBody
        case .deleteWithdraw: return .none
        case .patchLogout: return .none
        }
    }
    
    var path: String {
        switch self {
        case .postReissue:
            return utilPath.rawValue + "/reissue"
        case .postLogin:
            return utilPath.rawValue + "/login"
        case .deleteWithdraw:
            return utilPath.rawValue + "/withdraw"
        case .patchLogout:
            return utilPath.rawValue + "/logout"
        }
    }
    
    var method: Moya.Method {
        switch self {
        
        case .postReissue: return .post
        case .postLogin: return .post
        case .deleteWithdraw: return .delete
        case .patchLogout: return .patch
        }
    }
}
