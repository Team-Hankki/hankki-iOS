//
//  GetSearchedLocationResponseDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/17/24.
//

import Foundation

// MARK: - 장소 검색 API Res

struct GetSearchedLocationResponseDTO: Codable {
    var code: Int
    var message: String
    var data: GetSearchedLocationResponseData
}

struct GetSearchedLocationResponseData: Codable {
    var latitude: Double
    var longitude: Double
    var name: String
    var address: String?
}
