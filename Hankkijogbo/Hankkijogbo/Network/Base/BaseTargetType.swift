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
    case AuthorizationCode
    case loginHeader(accessToken: String)
    case withdrawHeader(authorizationCode: String)
}

/// 각 API에 따라 공통된 Path 값 (존재하지 않는 경우 빈 String 값)
enum UtilPath: String {
    case auth = "/v1/auth"
    case user = "/v1/users"
    case menu = "/v1/menus"
    case hankki = "/v1/stores"
    case zip = "/v1/favorites"
    case report = "/v1/reports"
    case university = "/v1/universities"
    case location = "/v1/locations"
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
        guard let baseURL = URL(string: URLConstant.baseURL) else {
            fatalError("ERROR - BASEURL")
        }
        return baseURL
    }
    
    var headers: [String: String]? {
        var header = ["Content-Type": "application/json"]
        switch headerType {
        case .loginHeader(let accessToken):
            header["Authorization"] = "\(accessToken)"
        case .withdrawHeader(let authorizationCode):
            let accessToken = UserDefaults.standard.getAccesshToken()
            header["Authorization"] = "Bearer \(accessToken)"
            header["X-Apple-Code"] = "\(authorizationCode)"
        default:
            let accessToken = UserDefaults.standard.getAccesshToken()
            header["Authorization"] = URLConstant.bearer + "\(accessToken)"
        }
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
