//
//  GetHankkiPinResponseDTO.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/18/24.
//

import Foundation

/// 메인 페이지 식당 핀 조회

struct GetHankkiPinResponseData: Codable {
    let pins: [GetHankkiPinData]
}

struct GetHankkiPinData: Codable {
    let latitude: Double
    let longitude: Double
    let id: Int64
    let name: String
}
