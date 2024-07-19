//
//  GetMeHankkiHeartDTO.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

struct GetMeHankkiListResponseData: Codable {
    let stores: [GetMeHankkiListData]
}

struct GetMeHankkiListData: Codable {
    let id: Int64
    let name: String
    let imageUrl: String
    let category: String
    let lowestPrice: Int
    let heartCount: Int
}
