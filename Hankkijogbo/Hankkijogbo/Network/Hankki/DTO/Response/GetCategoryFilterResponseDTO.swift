//
//  GetCategoryFilterResponseDTO.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation

struct GetCategoryFilterResponseDTO: Codable {
    let code: Int
    let message: String
    let data: GetCategoryFilterResponseData
}

struct GetCategoryFilterResponseData: Codable {
    let categories: [GetCategoryFilterData]
}

struct GetCategoryFilterData: Codable {
    let name: String
    let tag: String
    let imageUrl: String
}
