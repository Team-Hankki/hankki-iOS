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
    
    // MARK: - Request 보낼 시 호출
    
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            print("--> ❌🍚❌유효하지 않은 요청❌🍚❌")
            return
        }
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        var log = "=======================================================\n🍚1️⃣🍚[\(method)] \(url)\n=======================================================\n"
        log.append("🍚2️⃣🍚API: \(target)\n")
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("header: \(headers)\n")
        }
        if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            log.append("\(bodyString)\n")
        }
        log.append("========================= 🍚END \(method) =========================")
        print(log)
    }

    // MARK: - Response 받을 시 호출
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
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
        var log = "=============== 🍚 네트워크 통신 성공했을까요? 🍚 ==============="
        log.append("\n🍚3️⃣🍚[\(statusCode)] \(url)\n==========================================================\n")
        log.append("response: \n")
        if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
            log.append("🍚4️⃣🍚\(reString)\n")
        }
        log.append("===================== 🍚 CONTENT 🍚 =====================")
        if let responseString = String(bytes: response.data, encoding: .utf8) {
            log.append("\n\(responseString)\n")
        }
        log.append("===================== 🍚 END HTTP 🍚 =====================")
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
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate,
           let rootViewController = delegate.window?.rootViewController {
            rootViewController.showAlert(
                titleText: "네트워크 연결 오류",
                subText: "네트워크 오류로 \n서비스 접속이 불가능해요",
                primaryButtonText: "확인")
        }
    }
}
