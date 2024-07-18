//
//  GetUniversityResponseDTO.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

struct GetUniversityListResponseData: Codable {
    let universities: [GetUniversityListData]
}

struct GetUniversityListData: Codable {
    let id: Int
    let name: String
    let longitude: Double
    let latitude: Double
}
