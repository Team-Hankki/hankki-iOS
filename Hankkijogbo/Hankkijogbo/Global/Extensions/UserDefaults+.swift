//
//  UserDefaults+.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

extension UserDefaults {
    func saveUserId(_ userId: String) {
        UserDefaults.standard.set(userId, forKey: UserDefaultsKey.userId.rawValue)
    }
    
    func removeUserId() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userId.rawValue)
    }
    
    func getUserId() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.userId.rawValue) ?? ""
    }
    
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
        let defaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(university) {
            defaults.set(encoded, forKey: UserDefaultsKey.university.rawValue)
        }
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
    
    func saveNickname(_ nickname: String) {
        UserDefaults.standard.set(nickname, forKey: UserDefaultsKey.nickname.rawValue)
    }
    
    func removeNickname() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.nickname.rawValue)
    }
    
    func getNickname() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.nickname.rawValue) ?? ""
    }
    
    func removeUserInformation() {
        removeUserId()
        removeTokens()
        removeUniversity()
        removeNickname()
    }
}

enum UserDefaultsKey: String {
    case accessToken
    case refreshToken
    case userId
    case university
    case nickname
}
