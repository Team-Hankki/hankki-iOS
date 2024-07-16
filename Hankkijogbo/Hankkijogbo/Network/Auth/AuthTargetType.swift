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
    case patchLogout
    case deleteWithdraw
    case postLogin
}

extension AuthTargetType: BaseTargetType {
    var headerType: HeaderType {
        // TODO: - Header 타입 Base Target Type 에 추가하기
        switch self {
        case .postReissue:
            return .refreshTokenHeader
        case .patchLogout:
            return .accessTokenHeader
        case .deleteWithdraw:
            return .accessTokenHeader
        case .postLogin:
            return .accessTokenHeader
        }
    }
    
    var utilPath: UtilPath { return .auth }
    
    var pathParameter: String? {
        return .none
    }
    
    var queryParameter: [String : Any]? {
        return .none
    }
    
    var requestBodyParameter: (any Codable)? {
        switch self {
        case .postReissue:
            <#code#>
        case .patchLogout:
            <#code#>
        case .deleteWithdraw:
            <#code#>
        case .postLogin:
            <#code#>
        }
    }
    
    var path: String {
        switch self {
        case .postReissue:
            <#code#>
        case .patchLogout:
            <#code#>
        case .deleteWithdraw:
            <#code#>
        case .postLogin:
            <#code#>
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postReissue:
            <#code#>
        case .patchLogout:
            <#code#>
        case .deleteWithdraw:
            <#code#>
        case .postLogin:
            <#code#>
        }
    }
    
    
}
