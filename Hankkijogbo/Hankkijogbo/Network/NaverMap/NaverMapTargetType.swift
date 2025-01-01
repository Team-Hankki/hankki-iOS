//
//  NaverMapTargetType.swift
//  Hankkijogbo
//
//  Created by 서은수 on 12/30/24.
//

import Foundation

import Moya

enum NaverMapTargetType {
    
    case getHankkiAddress(latitude: Double, longitude: Double)
}

extension NaverMapTargetType: BaseTargetType {
    
    var loadingViewType: LoadingViewType {
        switch self {
        case .getHankkiAddress: return .fullView
        }
    }
    
    var headerType: HeaderType {
        return .naverMapHeader(clientId: Config.ReverseGeocodingClientId, clientSecret: Config.ReverseGeocodingClientSecret)
    }
    
    var utilPath: UtilPath { return .naverMap }
    
    var pathParameter: String? {
        switch self {
        case .getHankkiAddress:
            return .none
        }
    }
    
    var queryParameter: [String: Any]? {
        switch self {
        case .getHankkiAddress(let latitude, let longitude):
            return .some([
                "coords": "\(longitude),\(latitude)",
                "orders": "roadaddr", // 도로명주소
                "output": "json"
                ])
        }
    }
    
    var requestBodyParameter: Codable? {
        return .none
    }
    
    var path: String {
        switch self {
        case .getHankkiAddress:
            return utilPath.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getHankkiAddress: .get
        }
    }
}
