//
//  NetworkService.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    let hankkiService: HankkiAPIServiceProtocol = HankkiAPIService()
    let authService: AuthAPIServiceProtocol = AuthAPIService()
    let userService: UserAPIServiceProtocol = UserAPIService()
    let universityService: UniversityAPIServiceProtocol = UniversityAPIService()
    let locationService: LocationAPIServiceProtocol = LocationAPIService()
    let zipService: ZipAPIServiceProtocol = ZipAPIService()
    let reportService: ReportAPIServiceProtocol = ReportAPIService()
}

extension NetworkService {
    func setDelegate(_ delegate: BaseViewControllerDelegate) {
        MoyaPlugin.shared.delegate = delegate
    }
}
