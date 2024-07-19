//
//  GetZipListResponseDTO.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/18/24.
//

import Foundation

struct GetZipDetailResponseData: Codable {
    let title: String
    let details: [String]
    let stores: [GetZipDetailData]
}

struct GetZipDetailData: Codable {
    let id: Int64
    let name: String
    let imageUrl: String
    let category: String
    let lowestPrice: Int
    let heartCount: Int
}
