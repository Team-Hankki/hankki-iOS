//
//  PatchMenuRequestDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 11/4/24.
//

import Foundation

// MARK: - 메뉴 수정 API Req

struct PatchMenuRequestDTO: Codable {
    let name: String
    let price: Int
}
