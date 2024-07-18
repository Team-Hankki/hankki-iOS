//
//  GetMeUniversityResponseDTO.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

struct GetMeUniversityResponseData: Codable {
    let id: Int
    let name: String
    let longitude: Double
    let latitude: Double
}
