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
    case getHankkiPin(universityId: Int, storeCategory: String, priceCategory: String, sortOption: String)
    case getHankkiList(universityid: Int, storeCategory: String, priceCategory: String, sortOption: String)
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
        var queryParameter: [String: Any]? {
        switch self {
        case .getHankkiPin(let universityid, let storeCategory, let priceCategory, let sortOption):
            return ["universityId": universityid, "storeCategory": storeCategory, "priceCategory": priceCategory, "sortOption": sortOption]
        case .getHankkiList(let universityid, let storeCategory, let priceCategory, let sortOption):
            return ["universityid": universityid, "storeCategory": storeCategory, "priceCategory": priceCategory, "sortOption": sortOption]
        default:
            return .none
        }
    }
    
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
            return utilPath.rawValue + "/pins"
        case .getHankkiList:
            return utilPath.rawValue
        case .getHankkiThumbnail(let id):
            return utilPath.rawValue + "/\(id)/thumbnail"
            return utilPath.rawValue
        case .postHankkiHeart:
            return utilPath.rawValue + "/hearts"
        case .deleteHankkiHeart:
            return utilPath.rawValue + "/hearts"
        case .getHankkiValidate:
            return utilPath.rawValue + "/validate"
        case .getHankkiDetail(id: let id):
            return utilPath.rawValue // 추후에 은수가 수정하길
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCategoryFilter, .getPriceCategoryFilter, .getSortOptionFilter, .getHankkiPin, .getHankkiList, .getHankkiThumbnail, .getHankkiDetail, .getHankkiValidate:
            return .get
        case .postHankkiHeart:
            return .post
        case .deleteHankkiHeart:
            return .delete
        }
    }
}
