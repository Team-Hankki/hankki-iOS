//
//  GetMyZipListResponseDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/19/24.
//

import Foundation

/// 내 식당 족보 목록 바텀시트
struct GetMyZipListResponseData: Codable {
    let favorites: [GetMyZipFavorite]
}

struct GetMyZipFavorite: Codable {
    let id: Int
    let title: String
    let imageType: String
    let details: [String]
    let isAdded: Bool
}
