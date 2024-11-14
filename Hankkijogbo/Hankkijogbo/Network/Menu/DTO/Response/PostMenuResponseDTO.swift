//
//  PostMenuResponseDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/8/24.
//

import Foundation

// MARK: - 메뉴 추가 API Res

struct PostMenuResponseData: Codable {
    let menuList: [MenuData]
}
