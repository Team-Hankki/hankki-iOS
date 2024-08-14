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
    case postHankkiValidate(req: PostHankkiValidateRequestDTO)
    case postHankki(multipartData: [MultipartFormData])
    case postHankkiFromOther(request: PostHankkiFromOtherRequestDTO)
    case deleteHankki(id: Int)
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
    
    var utilPath: UtilPath {
        switch self {
        case .postHankkiFromOther:
            return .universityStores
        default:
            return .hankki
        }
    }
    
    // TODO: - 근데 얜 왜 있는거지 안 쓰이는 거 같은데
    var pathParameter: String? {
        switch self {
        case .getHankkiThumbnail(let id),
                .getHankkiDetail(let id),
                .postHankkiHeart(let id),
                .deleteHankkiHeart(let id),
                .deleteHankki(let id):
            return "\(id)"
        default: return .none
        }
    }
    
    var queryParameter: [String: Any]? {
        switch self {
        case .getHankkiPin(let universityId, let storeCategory, let priceCategory, let sortOption):
            return ["universityId": universityId, "storeCategory": storeCategory, "priceCategory": priceCategory, "sortOption": sortOption]
        case .getHankkiList(let universityId, let storeCategory, let priceCategory, let sortOption):
            return ["universityId": universityId, "storeCategory": storeCategory, "priceCategory": priceCategory, "sortOption": sortOption]
        default:
            return .none
        }
    }
    
    var requestBodyParameter: Codable? {
        // Patch, Post 등 Request
        switch self {
        case .postHankkiValidate(let req):
            return req
        case .postHankkiFromOther(let req):
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
            return utilPath.rawValue + "/pins"
        case .getHankkiList:
            return utilPath.rawValue
        case .getHankkiThumbnail(let id):
            return utilPath.rawValue + "/\(id)/thumbnail"
        case .getHankkiDetail(let id):
            return utilPath.rawValue + "/\(id)"
        case .postHankkiHeart(let id), .deleteHankkiHeart(let id):
            return utilPath.rawValue + "/\(id)/hearts"
        case .postHankkiValidate:
            return utilPath.rawValue + "/validate"
        case .postHankki:
            return utilPath.rawValue
        case .postHankkiFromOther:
            return utilPath.rawValue
        case .deleteHankki(let id):
            return utilPath.rawValue + "/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCategoryFilter, .getPriceCategoryFilter, .getSortOptionFilter, .getHankkiPin, .getHankkiList, .getHankkiThumbnail, .getHankkiDetail:
            return .get
        case .postHankkiHeart, .postHankkiValidate, .postHankki, .postHankkiFromOther:
            return .post
        case .deleteHankkiHeart, .deleteHankki:
            return .delete
        }
    }
}
