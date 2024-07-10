//
//  FilteringModel.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/11/24.
//

import Foundation

struct TypeModel {
    let menutype: String
}

struct PriceModel {
    let amount: String
}

struct SortModel {
    let sortType: String
}

struct FilteringModel {
    let type: TypeModel
    let price: PriceModel
    let sort: SortModel
}

let dummyType: [TypeModel] = [
    TypeModel(menutype: "양식"),
    TypeModel(menutype: "한식"),
    TypeModel(menutype: "중식"),
    TypeModel(menutype: "일식"),
    TypeModel(menutype: "분식"),
    TypeModel(menutype: "샐러드"),
    TypeModel(menutype: "빵"),
    TypeModel(menutype: "카페"),
    TypeModel(menutype: "김지혜")
]

let dummyPrice: [PriceModel] = [
    PriceModel(amount: "6000원 이하"),
    PriceModel(amount: "6000~8000")
]

let dummySort: [SortModel] = [
    SortModel(sortType: "최신순"),
    SortModel(sortType: "가격순"),
    SortModel(sortType: "추천순")
]
