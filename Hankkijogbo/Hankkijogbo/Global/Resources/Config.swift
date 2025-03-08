//
//  Config.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/9/24.
//

import Foundation

import Moya

enum Config {
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
            static let NMFClientId = "NMFClientId"
            static let Amplitude = "Amplitude"
            static let reverseGeocodingClientId = "ReverseGeocodingClientId"
            static let reverseGeocodingClientSecret = "ReverseGeocodingClientSecret"
            static let Kakao = "Kakao"
            static let DefaultHankkiImageURL = "DefaultHankkiImageURL"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found.")
        }
        return dict
    }()
}

extension Config {
    static let baseURL: String = {
        guard let key = Config.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("🍚⛔️BASE_URL is not set in plist for this configuration⛔️🍚")
        }
        return key
    }()
    
    static let NMFClientId: String = {
        guard let key = Config.infoDictionary[Keys.Plist.NMFClientId] as? String else {
            fatalError("ClientID is not set in plist for this configuration.")
        }
        return key
    }()
    
    static let ReverseGeocodingClientId: String = {
        guard let key = Config.infoDictionary[Keys.Plist.reverseGeocodingClientId] as? String else {
            fatalError("ReverseGeocodingClientID is not set in plist for this configuration.")
        }
        return key
    }()
    
    static let ReverseGeocodingClientSecret: String = {
        guard let key = Config.infoDictionary[Keys.Plist.reverseGeocodingClientSecret] as? String else {
            fatalError("ReverseGeocodingClientSecret is not set in plist for this configuration.")
        }
        return key
    }()
    
    static let Amplitude: String = {
        guard let key = Config.infoDictionary[Keys.Plist.Amplitude] as? String else {
            fatalError("Amplitude is not set in plist for this configuration.")
        }
        return key
    }()
    
    static let Kakao: String = {
        guard let key = Config.infoDictionary[Keys.Plist.Kakao] as? String else {
            fatalError("Kakao is not set in plist for this configuration.")
        }
        return key
    }()
    
    static let DefaultHankkiImageURL: String = {
        guard let key = Config.infoDictionary[Keys.Plist.DefaultHankkiImageURL] as? String else {
            fatalError("DefaultHankkiImageURL is not set in plist for this configuration.")
        }
        return key
    }()
}
