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
    case getHankkiList(universityid: Int, storeCategory: String, priceCategory: String, sortOption: String)
    case getHankkiThumbnail(id: Int)
    case getHankkiDetail(id: Int)
    case postHankkiHeart(id: Int64)
    case deleteHankkiHeart(id: Int64)
    case postHankkiValidate(req: PostHankkiValidateRequestDTO)
    case postHankki(multipartData: [MultipartFormData])
}

extension HankkiTargetType: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .postHankki(let multipartData):
            return .formdataHeader(multipartData: multipartData)
        default:
            return .accessTokenHeader
        }
    }
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
    
    // var queryParameter: [String: Any]? { return .none }
    var queryParameter: [String: Any]? {
        switch self {
        case .getHankkiPin(let university, let category, let lowestPrice, let order):
            return ["university": university, "category": category, "lowestPrice": lowestPrice, "order": order]
        case .getHankkiList(let universityid, let storeCategory, let priceCategory, let sortOption):
            return ["universityid": universityid, "storeCategory": storeCategory, "priceCategory": priceCategory, "sortOption": sortOption]
        default:
            return .none
        }
    }
    
    var requestBodyParameter: Codable? {
        // Patch, Post 등 Request
        switch self {
        case .postHankkiValidate(let req):
            return req
        default:
            return .none
        }
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
        case .getHankkiDetail(let id):
            return utilPath.rawValue + "/\(id)"
        case .postHankkiHeart(let id), .deleteHankkiHeart(let id):
            return utilPath.rawValue + "/\(id)/hearts"
        case .postHankkiValidate:
            return utilPath.rawValue + "/validate"
        case .postHankki:
            return utilPath.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCategoryFilter, .getPriceCategoryFilter, .getSortOptionFilter, .getHankkiPin, .getHankkiList, .getHankkiThumbnail, .getHankkiDetail:
            return .get
        case .postHankkiHeart, .postHankkiValidate, .postHankki:
            return .post
        case .deleteHankkiHeart:
            return .delete
        }
    }
}
