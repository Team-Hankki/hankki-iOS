//
//  GetHankkiListResponseDTO.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation

struct GetHankkiListResponseData: Codable {
    let stores: [GetHankkiListData]
}

struct GetHankkiListData: Codable {
    let imageUrl: String
    let category: String
    let name: String
    let lowestPrice: Int
    let heartCount: Int
    let id: Int
}
