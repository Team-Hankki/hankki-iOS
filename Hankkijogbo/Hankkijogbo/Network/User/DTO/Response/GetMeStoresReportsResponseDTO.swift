//
//  GetMeStoresReports.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

struct GetMeHankkiReportListResponseData: Codable {
    let stores: [GetMeHankkiReportResponseData]
}

struct GetMeHankkiReportResponseData: Codable {
    let id: Int
    let name: String
    let imageUrl: String
    let category: String
    let lowestPrice: Int
    let heartcount: Int
}
