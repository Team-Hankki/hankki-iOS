//
//  HankkiListTableViewCellDataStruct.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/11/24.
//

extension HankkiListTableViewCell {
    struct DataStruct {
        let id: Int64
        let name: String
        let imageURL: String
        let category: String
        let lowestPrice: Int
        let heartCount: Int
        var isDeleted: Bool = false
    }
}
