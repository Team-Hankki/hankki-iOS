//
//  PostHankkiValidateResponseDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 8/13/24.
//

import Foundation

// MARK: - 이미 등록된 식당인지 판별

struct PostHankkiValidateResponseData: Codable {
    let id: Int?
    let isRegistered: Bool
}
