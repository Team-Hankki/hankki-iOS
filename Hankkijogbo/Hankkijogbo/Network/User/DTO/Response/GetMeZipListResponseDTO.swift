//
//  GetMeFavorities.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

struct GetMeZipListResponseData: Codable {
    let favorites: [GetMeZipResponseData]
}

struct GetMeZipResponseData: Codable {
    let Id: Int
    let title: String
    let imageType: String
}
