//
//  PostHankkiRequestDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/19/24.
//

import Foundation

/// 식당 제보하기 Request
struct PostHankkiRequestDTO: Codable {
    let name: String
    let category: String
    let address: String
    let latitude: Double
    let longitude: Double
    let universityId: Int
    let menus: [MenuData]
}
