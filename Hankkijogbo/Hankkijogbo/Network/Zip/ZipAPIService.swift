//
//  ZipAPIService.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation
import Moya

protocol ZipAPIServiceProtocol {
    
}

final class ZipAPIService: BaseAPIService, ZipAPIServiceProtocol {
    
    private let provider = MoyaProvider<ZipTargetType>(plugins: [MoyaPlugin()])

}

