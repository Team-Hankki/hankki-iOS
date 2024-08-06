//
//  NetworkResult.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation
import UIKit

enum NetworkResult<T> {
    
    case success(T?)
    
    case networkFail        // 네트워크 연결 실패했을 때
    case decodeError        // 데이터는 받아왔으나 DTO 형식으로 decode가 되지 않을 때
    
    case badRequest         // 400 유효하지 않은 헤더
    case unAuthorized       // 401 유효하지 않은 토큰
    case notFound           // 404 ~ 에 대한 정보가 없음
    case methodNotAllowed   // 405 지원하지 않는 HTTP 메소드
    case serverError        // 500 서버 내부 오류
    
    case pathError
    
    var stateDescription: String {
        switch self {
        case .success: return "🍚🔥 SUCCESS 🔥🍚"

        case .networkFail: return "🍚🔥 NETWORK FAIL 🔥🍚"
        case .decodeError: return "🍚🔥 DECODED_ERROR 🔥🍚"
            
        case .badRequest: return "🍚🔥 400 : BAD REQUEST EXCEPTION 🔥🍚"
        case .unAuthorized: return "🍚🔥 401 : UNAUTHORIZED EXCEPTION 🔥🍚"
        case .notFound: return "🍚🔥 404 : NOT FOUND 🔥🍚"
        case .methodNotAllowed: return "🍚🔥 405 : METHOD NOT ALLOWED 🔥🍚"
        case .serverError: return "🍚🔥 500 : INTERNAL SERVER_ERROR 🔥🍚"
        case .pathError: return "🍚🔥 PATH ERROR 🔥🍚"
        }
    }
}

extension NetworkResult {
    func handleNetworkResult(_ result: NetworkResult, onSuccess: (T) -> Void) -> Void {
        print(result.stateDescription)
        switch result {
        case .success(let response):
            if let res = response {
                onSuccess(res)
            } else {
                print(result)
            }
            
        case .unAuthorized:
            //TODO: - 리프레쉬 토큰 재발급 하기
            print("Get Refresh Token")
            
        default:
            // TODO: - 상세한 분기처리 필요 (기디 논의 필요)
            // 프로그램 로직 내부에 오류가 발생했을 경우, 모달창을 띄웁니다.
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let delegate = windowScene.delegate as? SceneDelegate,
                let rootViewController = delegate.window?.rootViewController {
                rootViewController.showAlert(titleText: "오류 발생",
                                             subText: result.stateDescription,
                                             primaryButtonText: "확인")
            }
        }
    }
}
