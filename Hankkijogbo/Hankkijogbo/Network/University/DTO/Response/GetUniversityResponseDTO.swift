//
//  GetUniversityResponseDTO.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

struct GetUniversityResponseData: Codable {
    let universities: [GetUniversityDetail]
}

struct GetUniversityDetail: Codable {
    let id: Int
    let name: String
    let longitude: Float
    let latitude: Float
}
