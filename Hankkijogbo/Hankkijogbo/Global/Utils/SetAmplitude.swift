//
//  Applitude.swift
//  Hankkijogbo
//
//  Created by 심서현 on 8/27/24.
//

import Amplitude

class SetAmplitude {
    static let shared = SetAmplitude()
        
    private init() {} // Private 초기화로 외부에서 인스턴스화 방지
    
    func buttonClicked(_ buttonName: String, additionalProperties: [String: String]? = nil) {
        var eventProperties: [String: String] = ["button_name": buttonName]
        
        if let additionalProperties = additionalProperties {
            eventProperties.merge(additionalProperties) { current, _ in current }
        }
        
        Amplitude.instance().logEvent("ButtonClicked", withEventProperties: eventProperties)
    }
}
