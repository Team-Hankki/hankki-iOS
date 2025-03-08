//
//  GetSharedZipListResponseDTO.swift
//  Hankkijogbo
//
//  Created by 심서현 on 12/26/24.
//

import Foundation

struct GetSharedZipDetailResponseData: Codable {
    let title: String
    let details: [String]
    let nickname: String
    let stores: [GetSharedZipDetailData]
}

struct GetSharedZipDetailData: Codable {
    let id: Int
    let name: String
    let imageUrl: String?
    let category: String
    let lowestPrice: Int
    let heartCount: Int
}
