//
//  GetPriceFilterResponseDTO.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/17/24.
//

import Foundation

/// 가격 필터 드롭다운 정보 조회

struct GetPriceFilterResponseData: Codable {
    let priceCategories: [GetPriceFilterData]
}

struct GetPriceFilterData: Codable {
    let name: String
    let tag: String
}
