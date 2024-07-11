//
//  TotalListModel.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/10/24.
//

import Foundation

struct TotalListModel {
    let menu: String
    let hankkiTitle: String
    let price: Int
    let liked: Int
}

let dummyData: [TotalListModel] = [
    TotalListModel(menu: "양식", hankkiTitle: "파스타 냐미", price: 2000, liked: 100),
    TotalListModel(menu: "일식", hankkiTitle: "초밥이다 ㅋㅋ", price: 8000, liked: 200),
    TotalListModel(menu: "양식", hankkiTitle: "피자스쿨", price: 5000, liked: 150),
    TotalListModel(menu: "양식", hankkiTitle: "레전드 버거킹", price: 3000, liked: 180),
    TotalListModel(menu: "중식", hankkiTitle: "짬뽕냐미", price: 7000, liked: 90),
    TotalListModel(menu: "한식", hankkiTitle: "엽기떡볶이", price: 7900, liked: 200),
    TotalListModel(menu: "한식", hankkiTitle: "한끼족보 김치찜", price: 8000, liked: 600),
    TotalListModel(menu: "한식", hankkiTitle: "고등어 구이다", price: 5000, liked: 350),
    TotalListModel(menu: "일식", hankkiTitle: "우동마싯어요", price: 6300, liked: 264),
    TotalListModel(menu: "중식", hankkiTitle: "마랑탕후루", price: 7000, liked: 291)
]
