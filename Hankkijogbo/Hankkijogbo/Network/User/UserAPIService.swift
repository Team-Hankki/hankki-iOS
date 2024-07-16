//
//  UserAPIService.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation
import Moya

protocol UserAPIServiceProtocol {
    
}

final class UserAPIService: BaseAPIService, UserAPIServiceProtocol {
    
    private let provider = MoyaProvider<UserTargetType>(plugins: [MoyaPlugin()])

}
