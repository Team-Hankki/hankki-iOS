//
//  GetMeHankkiHeartDTO.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

struct GetMeHankkiListResponseData: Codable {
    let stores: [GetMeHankkiResponseData]
}

struct GetMeHankkiResponseData: Codable {
    let id: Int
    let name: String
    let imageUrl: String
    let category: String
    let lowestPrice: Int
    let heartCount: Int
}
