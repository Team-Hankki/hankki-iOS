//
//  CreateZipViewModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/18/24.
//

import Foundation
import UIKit

final class CreateZipViewModel {
    var showAlert: ((String) -> Void)?
}

extension CreateZipViewModel {
    func postZipBatchDelete(_ zipList: PostZipBatchDeleteRequestDTO) {
        NetworkService.shared.zipService.postZipBatchDelete(requesBody: zipList) { result in
            result.handleNetworkResult()
        }
    }

    func postZip(_ data: PostZipRequestDTO,
                 onConflict: @escaping(() -> Void),
                 completion: @escaping (() -> Void)) {
        NetworkService.shared.zipService.postZip(requestBody: data) { result in
            switch result {
            case .conflict:
                UIApplication.showAlert(titleText: StringLiterals.Alert.CreateZipConflict.title,
                                        subText: StringLiterals.Alert.CreateZipConflict.sub,
                                        primaryButtonText: StringLiterals.Alert.CreateZipConflict.primaryButton,
                                        primaryButtonHandler: onConflict
                )
                             
            default:
                result.handleNetworkResult { _ in
                    completion()
                }
            }
        }
    }
}
