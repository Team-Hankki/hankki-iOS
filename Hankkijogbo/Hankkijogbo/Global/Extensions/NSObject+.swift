//
//  NSObject+.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
