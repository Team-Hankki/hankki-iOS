//
//  URL+.swift
//  Hankkijogbo
//
//  Created by 심서현 on 12/20/24.
//

import Foundation

extension URL {
    // URL 의 쿼리 파라미터를 딕셔너리 객체로 변환한다.
    func getQueryParameters() -> [String:String] {
        var parameters: [String:String] = [:]
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.queryItems?.forEach { parameters[$0.name] = $0.value }
        return parameters
    }
}
