//
//  GetMenuResponseDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 11/14/24.
//

import Foundation

// MARK: - 메뉴 불러오기 API Res

struct GetMenuResponseData: Codable {
    let menus: [MenuData]
}
