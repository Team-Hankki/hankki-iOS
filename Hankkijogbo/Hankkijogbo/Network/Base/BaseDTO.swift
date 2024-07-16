//
//  BaseDTO.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

struct BaseDTO<T: Codable>: Codable {
    let status: Int
    let message: String
    let data: T
}

struct EmptyResultDTO: Codable {
    let status: Int
    let message: String
    let data: [String: String]?
}
