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
    
    func saveUniversity(_ university: UniversityModel) {
        UserDefaults.standard.set(university, forKey: UserDefaultsKey.university.rawValue)
    }
    
    func removeUniversity() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.university.rawValue)
    }
    
    func getUniversity() -> UniversityModel? {
            if let savedUniversityData = UserDefaults.standard.object(forKey: UserDefaultsKey.university.rawValue) as? Data {
                let decoder = JSONDecoder()
                if let loadedUniversity = try? decoder.decode(UniversityModel.self, from: savedUniversityData) {
                    return loadedUniversity
                }
            }
            return nil
        }
}

enum UserDefaultsKey: String {
    case accessToken
    case refreshToken
    case university
}
