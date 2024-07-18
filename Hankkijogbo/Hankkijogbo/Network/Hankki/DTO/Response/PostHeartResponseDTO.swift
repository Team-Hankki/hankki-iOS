//
//  PostHeartResponseDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/18/24.
//

import Foundation

/// 식당 좋아요 추가
struct PostHeartResponseData: Codable {
    var storeId: Int
    var count: Int
    var isHearted: Bool
}
