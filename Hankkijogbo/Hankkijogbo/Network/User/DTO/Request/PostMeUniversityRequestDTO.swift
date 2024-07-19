//
//  GetMeUniversity.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

struct PostMeUniversityRequestDTO: Codable {
    let universityId: Int
    let name: String
    let longitude: Double
    let latitude: Double
}
