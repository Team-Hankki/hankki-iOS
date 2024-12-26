//
//  GetHankkiDetailResponseDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/18/24.
//

import Foundation

/// 식당 세부 조회
struct GetHankkiDetailResponseData: Codable {
    let name: String
    let category: String
    let heartCount: Int
    let isLiked: Bool
    let imageUrls: [String]
    let menus: [MenuData]
}

struct MenuData: Codable {
    var id: Int = 0
    var name: String = ""
    var price: Int = 0
}

struct SelectableMenuData {
    var isSelected: Bool = false
    var id: Int = 0
    var name: String = ""
    var price: Int = 0
}

extension MenuData {
    
    func toSelectableMenuData() -> SelectableMenuData {
        return SelectableMenuData(
            isSelected: false,
            id: self.id,
            name: self.name,
            price: self.price
        )
    }
    
    func toMenuRequestDTO() -> MenuRequestDTO {
        return MenuRequestDTO(
            name: self.name,
            price: self.price
        )
    }
}
