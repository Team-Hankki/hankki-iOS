//
//  UserDefaults+.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

extension UserDefaults {
    
    /// refresh, access token 관련 함수
    func saveTokens(accessToken: String, refreshToken: String) {
        UserDefaults.standard.set(accessToken, forKey: UserDefaultsKey.accessToken.rawValue)
        UserDefaults.standard.set(refreshToken, forKey: UserDefaultsKey.refreshToken.rawValue)
    }
    
    func removeTokens() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.accessToken.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.refreshToken.rawValue)
    }
    
    func getRefreshToken() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.refreshToken.rawValue) ?? ""
    }
    
    func getAccesshToken() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.accessToken.rawValue) ?? ""
    }
}

enum UserDefaultsKey: String {
    case accessToken
    case refreshToken
}
