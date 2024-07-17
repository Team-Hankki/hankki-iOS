//
//  GetReportedNumberResponseDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/17/24.
//

import Foundation

// MARK: - 제보수 조회 API Res

struct GetReportedNumberResponseDTO: Codable {
    var code: Int
    var message: String
    var data: GetReportedNumberResponseData
}

struct GetReportedNumberResponseData: Codable {
    var count: Int64
}
