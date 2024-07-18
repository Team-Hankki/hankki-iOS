//
//  GetCategoryFilterResponseDTO.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation

/// 카테고리 필터 드롭다운 정보 조회

struct GetCategoryFilterResponseData: Codable {
    let categories: [GetCategoryFilterData]
}

struct GetCategoryFilterData: Codable {
    let name: String
    let tag: String
    let imageUrl: String
}
