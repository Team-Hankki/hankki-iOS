//
//  MenuRequestDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 11/14/24.
//

import Foundation

// MARK: - 메뉴 쪽 API Request Body

struct MenuRequestDTO: Codable {
    var name: String?
    var price: Int?
}
