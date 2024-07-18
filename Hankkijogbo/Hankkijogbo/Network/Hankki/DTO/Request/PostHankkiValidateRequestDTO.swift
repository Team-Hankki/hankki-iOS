//
//  PostHankkiValidateRequestDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/18/24.
//

import Foundation

// MARK: - 이미 등록된 식당인지 판별

struct PostHankkiValidateRequestDTO: Codable {
    var universityId: Int64
    var latitude: Double
    var longitude: Double
}
