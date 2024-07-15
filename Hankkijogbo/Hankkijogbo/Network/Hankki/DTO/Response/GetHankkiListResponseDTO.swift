//
//  GetHankkiListResponseDTO.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation

struct GetHankkiListResponseDTO: Codable {
    let code: Int
    let message: String
    let data: GetHankkiListResponseData
}

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
