//
//  BaseTargetType.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation
import UIKit

import Moya

enum TokenHealthType {
    case accessToken
    case refreshToken
}

///  헤더에 들어가는 토큰의 상태에 따른 Type
enum HeaderType {
    case socialTokenHeader(socialToken: String)
    case accessTokenHeader
    case refreshTokenHeader
    case tokenHealthHeader(tokenHealthType: TokenHealthType)
}

/// 각 API에 따라 공통된 Path 값 (존재하지 않는 경우 빈 String 값)
enum UtilPath: String {
    case auth = "auth"
    case user = "users"
    case menu = "menus"
    case hankki = "stores"
    case zip = "favorites"
    case report = "reports"
    case university = "universities"
}

protocol BaseTargetType: TargetType {
    var headerType: HeaderType { get }
    var utilPath: UtilPath { get }
    var pathParameter: String? { get }
    var queryParameter: [String: Any]? { get }
    var requestBodyParameter: Codable? { get }
}

extension BaseTargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var headers: [String: String]? {
        var header = ["Content-Type": "application/json"]
//        header["Authorization"] 
        return header
    }
    
    var task: Task {
        if let queryParameter {
            return .requestParameters(parameters: queryParameter, encoding: URLEncoding.default)
        }
        if let requestBodyParameter {
            return .requestJSONEncodable(requestBodyParameter)
        }
        return .requestPlain
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
