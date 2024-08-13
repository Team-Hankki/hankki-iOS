//
//  PostHankkiFromOtherRequestDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 8/13/24.
//

import Foundation

/// 타학교에 있던 식당 우리 학교에 제보하기 Request
struct PostHankkiFromOtherRequestDTO: Codable {
    let storeId: Int
    let universityId: Int
}
