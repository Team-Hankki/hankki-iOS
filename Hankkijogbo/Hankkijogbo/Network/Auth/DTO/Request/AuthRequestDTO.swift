//
//  AuthRequestDTO.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

struct PostLoginRequestDTO: Codable {
    let name: String
    var platform: String = "APPLE"
}
