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
            switch result {
            case .success(_):
                return
            case .unAuthorized, .pathError:
                self.showAlert?("Failed")
            default:
                return
            }
        }
    }

    func postZip(_ data: PostZipRequestDTO) {
        NetworkService.shared.zipService.postZip(requestBody: data) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    // 족보 만들기를 완료해서, 서버에서 생성이되면 이전 페이지로 이동한다
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let rootViewController = windowScene.windows.first?.rootViewController as? UINavigationController { rootViewController.popViewController(animated: true) }
                  }
                return
            case .unAuthorized, .pathError:
                self.showAlert?("Failed")
            default:
                return
            }
        }
    }
}
