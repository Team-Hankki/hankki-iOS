//
//  MenuResponseDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 11/14/24.
//

import Foundation

// MARK: - 메뉴 불러오기 API, 메뉴 추가 API Res

struct MenuResponseData: Codable {
    let menus: [MenuData]
}
