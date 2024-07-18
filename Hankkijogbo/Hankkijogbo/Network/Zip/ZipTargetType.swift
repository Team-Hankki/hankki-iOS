//
//  ZipTargetService.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

import Moya

enum ZipTargetType {
    case getZipList(storedId: Int)
    case getZipDetail(storeId: Int)
    case postZip
    case postZipBatchDelete(requestBodt: PostZipBatchDeleteRequestDTO)
    case postZipToHankki(requestBody: PostZipToHankkiRequestDTO)
    case deleteZipToHankki(requestBody: DeleteZipToHankkiRequestDTO)
    case getMyZipList(id: Double)
}

extension ZipTargetType: BaseTargetType {
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var utilPath: UtilPath {
        return .zip
    }
    
    var pathParameter: String? {
        return .none
    }
    
    var queryParameter: [String: Any]? {
        switch self {
        case .getMyZipList(let id):
            return .some(["candidate": id])
        default:
            return .none
        }
    }
    
    var requestBodyParameter: (any Codable)? {
        switch self {
        case .getZipList(let storeId): return storeId
        case .getZipDetail: return .none
        case .postZip: return .none
        case .postZipBatchDelete(let requestBody): return requestBody
        case .postZipToHankki: return .none
        case .deleteZipToHankki: return .none
        case .getMyZipList: return .none
        }
    }
    
    var path: String {
        switch self {
        case .getZipList:
            return utilPath.rawValue
        case .getZipDetail:
            return utilPath.rawValue
        case .postZip:
            return utilPath.rawValue
        case .postZipBatchDelete:
            return utilPath.rawValue + "batch-delete"
        case .postZipToHankki(let requestBody):
            return utilPath.rawValue + "\(requestBody.favoriteId)/stores/\(requestBody.storeId)"
        case .deleteZipToHankki(let requestBody):
            return utilPath.rawValue + "\(requestBody.favoriteId)/stores/\(requestBody.storeId)"
        case .getMyZipList:
            return utilPath.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getZipList, .getZipDetail, .getMyZipList:
            return .get
        case .postZip, .postZipBatchDelete, .postZipToHankki:
            return .post
        case .deleteZipToHankki: 
            return .delete
        }
    }
}
