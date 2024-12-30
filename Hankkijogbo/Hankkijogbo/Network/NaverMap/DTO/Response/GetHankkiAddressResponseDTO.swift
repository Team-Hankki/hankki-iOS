//
//  GetHankkiAddressResponseDTO.swift
//  Hankkijogbo
//
//  Created by 서은수 on 12/30/24.
//

import Foundation

// MARK: - Naver Reverse Geocoding API Res

struct ReverseGeocodingBaseDTO: Decodable {
    let code: Int
    let name: String
    let message: String
}

struct GetHankkiAddressResponseDTO: Decodable {
    let status: ReverseGeocodingBaseDTO
    let results: [GetHankkiAddressResult?]
}

struct GetHankkiAddressResult: Decodable {
    let region: Region?
    let land: Land?
}
 
struct Region: Decodable {
    let area1: Area1?
    let area2, area3, area4: Area?
}
 
struct Area1: Decodable {
    let name, alias: String?
}
 
struct Area: Decodable {
    let name: String?
}

struct Land: Decodable {
    let name: String?
    let number1, number2: String?
}
