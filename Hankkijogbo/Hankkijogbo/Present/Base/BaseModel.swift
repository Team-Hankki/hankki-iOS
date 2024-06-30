//
//  BaseModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 6/30/24.
//

import Foundation

/// result가 들어있을 때 Base Model
struct BaseModel<T: Codable>: Codable {
    let status: Int
    let success: Bool
    let message: String
    let result: T
}

/// result가 비었을 경우에 사용
struct EmptyResultModel: Codable {
    let status: Int
    let success: Bool
    let message: String
    let result: [String: String]?
}
