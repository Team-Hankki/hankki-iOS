//
//  CreateZipViewControllerType.swift
//  Hankkijogbo
//
//  Created by 심서현 on 12/20/24.
//

import UIKit

extension CreateZipViewController {
    enum CreateZipViewControllerType {
        case sharedZip
        case myZip
        
        var viewTitle: String {
            switch self {
            case .sharedZip: return StringLiterals.SharedZip.viewTitle
            case .myZip: return StringLiterals.CreateZip.viewTitle
            }
        }
        
        var viewDescription: String {
            switch self {
            case .sharedZip: return StringLiterals.SharedZip.viewDescription
            case .myZip: return StringLiterals.CreateZip.viewDescription
            }
        }
        
        var submitButtonText: String {
            switch self {
            case .sharedZip: return StringLiterals.SharedZip.submitButton
            case .myZip: return StringLiterals.CreateZip.submitButton
            }
        }
    }
}
