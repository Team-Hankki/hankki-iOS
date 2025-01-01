//
//  BaseTargetType.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation

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
    case formdataHeader(multipartData: [MultipartFormData])
    case naverMapHeader(clientId: String, clientSecret: String)
}

/// 각 API에 따라 공통된 Path 값 (존재하지 않는 경우 빈 String 값)
enum UtilPath: String {
    case auth = "/v1/auth"
    case user = "/v1/users"
    case menu = "/v1"
    case hankki = "/v1/stores"
    case zip = "/v1/favorites"
    case report = "/v1/reports"
    case university = "/v1/universities"
    case location = "/v1/locations"
    case universityStores = "/v1/university-stores"
    case naverMap = "/v2/gc"
}

protocol BaseTargetType: TargetType {
    var headerType: HeaderType { get }
    var utilPath: UtilPath { get }
    var pathParameter: String? { get }
    var queryParameter: [String: Any]? { get }
    var requestBodyParameter: Codable? { get }
    var loadingViewType: LoadingViewType { get }
}

extension BaseTargetType {
    var baseURL: URL {
        switch utilPath {
        case .naverMap:
            guard let reverseGeocodingBaseURL = URL(string: URLConstant.reverseGeocodingBaseURL) else {
                fatalError("ERROR - NAVER MAP Reverse Geocoding BASEURL")
            }
            return reverseGeocodingBaseURL
        default:
            guard let baseURL = URL(string: URLConstant.baseURL) else {
                fatalError("ERROR - BASEURL")
            }
            return baseURL
        }
    }
    
    var headers: [String: String]? {
        var header: [String: String] = [:]
        
        switch headerType {
            
        case .loginHeader(let accessToken):
            header["Content-Type"] = "application/json"
            header["Authorization"] = "\(accessToken)"
            
        case .refreshTokenHeader:
            header["Content-Type"] = "application/json"
            let refreshToken = UserDefaults.standard.getRefreshToken()
            header["Authorization"] = URLConstant.bearer + "\(refreshToken)"
            
        // 이후부터는 access token이 헤더에 필요합니다.
        case .withdrawHeader(let authorizationCode):
            header["Content-Type"] = "application/json"
            header["X-Apple-Code"] = "\(authorizationCode)"
               
        case .formdataHeader:
            header["Content-Type"] = "multipart/form-data"
            
        case .naverMapHeader(let clientId, let clientSecret):
            header["x-ncp-apigw-api-key-id"] = clientId
            header["x-ncp-apigw-api-key"] = clientSecret
            
        default:
            header["Content-Type"] = "application/json"
        }
        
        if UserDefaults.standard.isLogin {
            // 유저가 로그인 한 회원일 경우
            // Access Token을 header-Authorization 에 삽입해 전송한다.
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
        switch headerType {
        case .formdataHeader(let multipartData):
            print("최종 \(multipartData[1])")
            return .uploadMultipart(multipartData)
        default:
            return .requestPlain
        }
    }
}
