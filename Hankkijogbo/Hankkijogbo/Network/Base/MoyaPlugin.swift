//
//  MoyaPlugin.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation
import UIKit

import Moya

final class MoyaPlugin: PluginType {
    
    // MARK: - Properties
    
    weak var delegate: BaseViewControllerDelegate?
    
    private var requestList: [String: BaseViewControllerDelegate] = [:]
    
    // MARK: - Life Cycle
    
    static let shared = MoyaPlugin()
    
    private init() {}
    
    // MARK: - Request 보낼 시 호출
    
    func willSend(_ request: RequestType, target: TargetType) {
        addRequest(target)
        setupLoading(true, target: target)
        
        guard let httpRequest = request.request else {
            print("--> ❌🍚❌유효하지 않은 요청❌🍚❌")
            setupLoading(false, target: target)
            return
        }
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        var log = "🍚 [\(method)] =================================================\n"
        log.append("1️⃣ [\(method)] \(url)\n")
        log.append("\n")
        log.append("2️⃣ API: \(target)\n")
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("✏️ header:\n\(headers)\n")
        }
        if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            log.append("✏️ body:\n\(bodyString)\n")
        }
        log.append("=======================================================\n")
        print(log)
    }
    
    // MARK: - Response 받을 시 호출
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        let key = String(describing: target)
        
        if requestList[key] != nil {
            delegate = requestList[key]
        }
        
        setupLoading(false, target: target)
        removeRequest(target)

        switch result {
        case let .success(response):
            self.onSucceed(response)
        case let .failure(error):
            self.onFail(error)
        }
    }
    
    func onSucceed(_ response: Response) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        
        var log = "🍚 [RESULT] =============================================\n"
        log.append("3️⃣ [\(statusCode)] \(url)\n")
        
        if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
            log.append("\n4️⃣ \(reString)\n")
        }
        log.append("=======================================================\n")
        print(log)
    }
    
    func onFail(_ error: MoyaError) {
        if let response = error.response {
            onSucceed(response)
            return
        }
        var log = "❌🍚❌네트워크 오류❌🍚❌"
        
        log.append("<-- \(error.errorCode)\n")
        log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
        log.append("<-- END HTTP 🍚🍚🍚")
        print(log)
        
        // 네트워크 연결 오류 Alert창 표출
        UIApplication.showAlert(titleText: StringLiterals.Alert.NetworkError.title,
                                subText: StringLiterals.Alert.NetworkError.sub,
                                primaryButtonText: StringLiterals.Alert.NetworkError.primaryButton,
                                primaryButtonHandler: presentSetting)
    }
}

private extension MoyaPlugin {
    func presentSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func setupLoading(_ isLoading: Bool, target: TargetType) {
        let loadingViewType: LoadingViewType
        if let targetWithLoading = target as? BaseTargetType {
            loadingViewType = targetWithLoading.loadingViewType
        } else {
            loadingViewType = .none
        }
        delegate?.setupLoading(isLoading, type: loadingViewType)
    }
}

private extension MoyaPlugin {
    func addRequest(_ target: TargetType) {
        let key = String(describing: target)
        requestList[key] = delegate
    }
    
    func removeRequest(_ target: TargetType) {
        let key = String(describing: target)
        requestList.removeValue(forKey: key)
    }
}
