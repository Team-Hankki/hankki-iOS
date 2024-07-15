//
//  HankkiInfoDummy.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import Foundation

struct HankkiInfo {
    var hankkiName: String
    var hankkiCategory: String
    var hankkiMenu: [HankkiMenuDummy]
}

struct HankkiMenuDummy {
    var menuName: String
    var menuPrice: Int
}
