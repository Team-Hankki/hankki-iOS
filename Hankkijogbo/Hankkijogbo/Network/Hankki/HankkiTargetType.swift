//
//  HankkiTargetType.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation

import Moya

enum HankkiTargetType {
    case getCategoryFilter
    case getPriceCategoryFilter
    case getSortOptionFilter
    case getHankkiPin(university: String, category: String, lowestPrice: String, order: String)
    case getHankkiList(university: String, category: String, lowestPrice: String, order: String)
    case getHankkiThumbnail(id: Int)
    case getHankkiDetail(id: Int)
    case postHankkiHeart(id: Int)
    case deleteHankkiHeart(id: Int)
    case getHankkiValidate
}

extension HankkiTargetType: BaseTargetType {
    var headerType: HeaderType { return .accessTokenHeader }
    var utilPath: UtilPath { return .hankki }
    
    var pathParameter: String? {
        switch self {
        case .getHankkiThumbnail(let id): return "\(id)"
        case .getHankkiDetail(let id): return "\(id)"
        case .postHankkiHeart(let id): return "\(id)"
        case .deleteHankkiHeart(let id): return "\(id)"
        default: return .none
        }
    }
    
    var queryParameter: [String: Any]? { return .none }
    
    var requestBodyParameter: Codable? {
        // Patch, Post 등 Request
        return .none
    }
    
    var path: String {
        switch self {
        case .getCategoryFilter:
            return utilPath.rawValue + "/categories"
        case .getPriceCategoryFilter:
            return utilPath.rawValue + "/price-categories"
        case .getSortOptionFilter:
            return utilPath.rawValue + "/sort-options"
        case .getHankkiPin:
            return utilPath.rawValue
        case .getHankkiList:
            return utilPath.rawValue
        case .getHankkiThumbnail:
            return utilPath.rawValue + "/thumbnail"
        case .getHankkiDetail:
            return utilPath.rawValue
        case .postHankkiHeart:
            return utilPath.rawValue + "/hearts"
        case .deleteHankkiHeart:
            return utilPath.rawValue + "/hearts"
        case .getHankkiValidate:
            return utilPath.rawValue + "/validate"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCategoryFilter: .get
        case .getPriceCategoryFilter: .get
        case .getSortOptionFilter: .get
        case .getHankkiPin: .get
        case .getHankkiList: .get
        case .getHankkiThumbnail: .get
        case .getHankkiDetail: .get
        case .postHankkiHeart: .post
        case .deleteHankkiHeart: .delete
        case .getHankkiValidate: .get
            
        }
    }
}
