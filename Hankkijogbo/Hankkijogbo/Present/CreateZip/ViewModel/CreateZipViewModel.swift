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

    func postZip(_ data: PostZipRequestDTO) {
        NetworkService.shared.zipService.postZip(requestBody: data) { result in
            switch result {
            case .conflict:
                // TODO: - 서현) 기디쌤들한테 알럿 내용 받아오기
                UIApplication.showAlert(titleText: "이미 존재하는 족보의 이름입니다.", primaryButtonText: "확인")
            default:
                result.handleNetworkResult { _ in
                    DispatchQueue.main.async {
                        // 족보 만들기를 완료해서, 서버에서 생성이되면 이전 페이지로 이동한다
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                            let rootViewController = windowScene.windows.first?.rootViewController as? UINavigationController { rootViewController.popViewController(animated: true) }
                    }
                }
            }
        }
    }
}
