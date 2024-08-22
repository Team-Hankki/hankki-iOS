//
//  GetHankkiPinRequestDTO.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/18/24.
//

import Foundation

struct GetHankkiPinRequestDTO {
    let universityId: Int?
    let storeCategory: String
    let priceCategory: String
    let sortOption: String
}
