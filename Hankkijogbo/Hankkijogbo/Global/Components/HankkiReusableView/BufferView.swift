//
//  BufferView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/11/24.
//

import UIKit

final class BufferView: BaseCollectionReusableView {
    
    // MARK: - Set UI
    
    override func setupStyle() {
        self.do {
            $0.backgroundColor = .clear
        }
    }
}
