//
//  GetHankkiListResponseDTO.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation

/// 메인 페이지 식당 리스트 조회

struct GetHankkiListResponseData: Codable {
    let stores: [GetHankkiListData]
}

struct GetHankkiListData: Codable {
    let imageUrl: String
    let category: String
    let name: String
    let lowestPrice: Int
    let heartCount: Int
    let id: Int
}
