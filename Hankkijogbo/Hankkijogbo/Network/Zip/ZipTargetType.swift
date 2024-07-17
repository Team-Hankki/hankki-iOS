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
    
    var queryParameter: [String : Any]? {
        return .none
    }
    
    var requestBodyParameter: (any Codable)? {
        switch self {
        case .getZipList(let storeId): return storeId
        case .getZipDetail: return .none
        case .postZip: return .none
        case .postZipBatchDelete(let requestBody): return requestBody
        case .postZipToHankki: return .none
        case .deleteZipToHankki: return .none
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getZipList: return .get
        case .getZipDetail: return .get
        case .postZip: return .post
        case .postZipBatchDelete: return .post
        case .postZipToHankki: return .post
        case .deleteZipToHankki: return .delete
        }
    }
}

