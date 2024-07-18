//
//  GetHankkiThumbnailResponseDTO.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/18/24.
//

import Foundation

/// 메인 페이지 식당 핀 조회

struct GetHankkiThumbnailResponseData: Codable {
    let thumbnails: [GetHankkiThumbnailData]
}

struct GetHankkiThumbnailData: Codable {
    let id: Int
    let name: String
    let category: String
    let lowestPrice: Int
    let heartCount: Int
    let imageUrl: String
}
