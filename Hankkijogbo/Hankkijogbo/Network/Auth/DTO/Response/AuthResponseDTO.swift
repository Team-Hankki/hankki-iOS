//
//  AuthResponseDTO.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

struct PostReissueDTO: Codable {
    let code: Int
    let message: String
    let data: GetCategoryFilterResponseData
}

struct PostReissueData: Codable {
    let accessToken: String
    let refreshToken: String
}
