//
//  AuthResponseDTO.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

struct PostReissueData: Codable {
    let accessToken: String
    let refreshToken: String
}

struct PostLoginData: Codable {
    let accessToken: String
    let refreshToken: String
    let isRegistered: Bool
}
