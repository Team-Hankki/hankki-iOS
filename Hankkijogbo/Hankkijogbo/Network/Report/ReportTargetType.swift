//
//  ReportTargetType.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/17/24.
//

import Foundation

import Moya

enum ReportTargetType {
    case getReportedNumber
}

extension ReportTargetType: BaseTargetType {
    var headerType: HeaderType { return .accessTokenHeader }
    var utilPath: UtilPath { return .report }
    
    var pathParameter: String? {
        switch self {
        case .getReportedNumber:
            return .none
        }
    }
    
    var queryParameter: [String: Any]? { return .none }
    
    var requestBodyParameter: Codable? {
        return .none
    }
    
    var path: String {
        switch self {
        case .getReportedNumber:
            return utilPath.rawValue + "/count"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getReportedNumber: .get
        }
    }
    
    var loadingViewType: LoadingViewType {
        switch self {
        case .getReportedNumber: return .none
        }
    }
}
