//
//  Applitude.swift
//  Hankkijogbo
//
//  Created by 심서현 on 8/27/24.
//

import Amplitude

class SetupAmplitude {
    static let shared = SetupAmplitude()
        
    private init() {}
    
    func logEvent(_ buttonName: String, eventProperties: [String: String]? = nil) {
        
        Amplitude.instance().logEvent(buttonName, withEventProperties: eventProperties)
    }
}
