//
//  GetSortOptionFilterResponseDTO.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/17/24.
//

import Foundation

struct GetSortOptionFilterResponseDTO: Codable {
    let code: Int
    let message: String
    let data: GetSortOptionFilterResponseData
}

struct GetSortOptionFilterResponseData: Codable {
    let options: [GetSortOptionFilterData]
}

struct GetSortOptionFilterData: Codable {
    let name: String
    let tag: String
}
