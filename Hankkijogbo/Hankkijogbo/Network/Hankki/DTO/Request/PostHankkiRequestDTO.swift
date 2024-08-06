//
//  PostHankkiRequestDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/19/24.
//

import Foundation

/// 식당 제보하기 Request
struct PostHankkiRequestDTO: Codable {
    var name: String
    var category: String
    var address: String
    var latitude: Double
    var longitude: Double
    var universityId: Int
    var menus: [MenuData]
}
