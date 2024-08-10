//
//  HankkiDebouncer.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/17/24.
//

import Foundation

class HankkiDebouncer {
    private var workItem: DispatchWorkItem?
    private let seconds: Double
    
    init(seconds: Double) {
        self.seconds = seconds
    }
    
    func run(_ closure: @escaping () -> Void) {
        self.workItem?.cancel()
        let newWork = DispatchWorkItem(block: closure)
        workItem = newWork
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(seconds), execute: newWork)
    }
}
