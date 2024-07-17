//
//  GetPriceFilterResponseDTO.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/17/24.
//

import Foundation

struct GetPriceFilterResponseData: Codable {
    let priceCategories: [GetPriceFilterData]
}

struct GetPriceFilterData: Codable {
    let name: String
    let tag: String
}
