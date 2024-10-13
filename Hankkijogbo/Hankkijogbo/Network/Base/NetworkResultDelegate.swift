//
//  NetworkResultDelegate.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 10/13/24.
//

import Foundation
import UIKit

protocol NetworkResultDelegate: AnyObject {
    func moveToLoginScreen()
}

extension NetworkResultDelegate {
    func moveToLoginScreen() {
        UIApplication.browseApp()
    }
}
