//
//  Config.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/9/24.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let NMFClientId = "NMFClientId"
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
    static let NMFClientId: String = {
        guard let key = Config.infoDictionary[Keys.Plist.NMFClientId] as? String else {
            fatalError("ClientID is not set in plist for this configuration.")
        }
        return key
    }()
}
