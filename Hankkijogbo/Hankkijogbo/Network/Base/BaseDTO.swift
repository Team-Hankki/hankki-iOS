//
//  BaseDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 6/30/24.
//

import Foundation

/// data가 들어있을 때 Base Model
struct BaseDTO<T: Codable>: Codable {
    var code: Int
    var message: String
    var data: T
}

/// data가 비었을 경우에 사용
struct EmptyDTO: Codable {
    let code: Int
    let message: String
    let data: [String: String]?
}
