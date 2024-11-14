//
//  MenuTargetType.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/8/24.
//

import Foundation

import Moya

enum MenuTargetType {
    case postMenu(storeId: Int, requestBody: [MenuRequestDTO])
    case patchMenu(storeId: Int, id: Int, requestBody: MenuRequestDTO)
    case deleteMenu(storeId: Int, id: Int)
}

extension MenuTargetType: BaseTargetType {
    var headerType: HeaderType { return .accessTokenHeader }
    var utilPath: UtilPath { return .menu }
    
    var pathParameter: String? { return .none } // 안 쓰임
    var queryParameter: [String: Any]? { return .none }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .postMenu(_, let requestBody):
            return requestBody
        case .patchMenu(_, _, let requestBody):
            return requestBody
        default:
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .postMenu(let storeId, _):
            return utilPath.rawValue + "/\(storeId)/menus/bulk"
        case .patchMenu(let storeId, let id, _), .deleteMenu(let storeId, let id):
            return utilPath.rawValue + "/\(storeId)/menus/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postMenu: .post
        case .patchMenu: .patch
        case .deleteMenu: .delete
        }
    }
    
    var loadingViewType: LoadingViewType {
        return .submit
    }
}
