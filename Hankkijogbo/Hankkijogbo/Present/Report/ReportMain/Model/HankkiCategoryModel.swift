//
//  HankkiCategoryModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 8/11/24.
//

import Foundation

/// 카테고리 체크 여부가 저장되어야 하기 때문에 따로 만든 모델입니다
struct HankkiCategoryModel {
    var categoryData: GetCategoryFilterData
    var isChecked: Bool
}
