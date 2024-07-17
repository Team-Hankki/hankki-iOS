//
//  GetHankkiListRequestDTO.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation

struct GetHankkiListRequestDTO {
    let universityId: Int
    let storeCategory: String
    let priceCategory: String
    let sortOption: String
}
