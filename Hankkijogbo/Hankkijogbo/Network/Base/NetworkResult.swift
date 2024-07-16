//
//  NetworkResult.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import Foundation

enum NetworkResult<T> {
    
    case success(T?)
    
    case networkFail        // 네트워크 연결 실패했을 때
    case decodeError          // 데이터는 받아왔으나 DTO 형식으로 decode가 되지 않을 때
    
    case badRequest         // BAD REQUEST EXCEPTION (400)
    case unAuthorized       // UNAUTHORIZED EXCEPTION (401)
    case notFound           // NOT FOUND (404)
    case unProcessable      // UNPROCESSABLE_ENTITY (422)
    case serverError          // INTERNAL_SERVER_ERROR (500번대)
    case pathError
    
    var stateDescription: String {
        switch self {
        case .success: return "🍚🔥 SUCCESS 🔥🍚"

        case .networkFail: return "🍚🔥 NETWORK FAIL 🔥🍚"
        case .decodeError: return "🍚🔥 DECODED_ERROR 🔥🍚"
            
        case .badRequest: return "🍚🔥 BAD REQUEST EXCEPTION 🔥🍚"
        case .unAuthorized: return "🍚🔥 UNAUTHORIZED EXCEPTION 🔥🍚"
        case .notFound: return "🍚🔥 NOT FOUND 🔥🍚"
        case .unProcessable: return "🍚🔥 UNPROCESSABLE ENTITY 🔥🍚"
        case .serverError: return "🍚🔥 INTERNAL SERVER_ERROR 🔥🍚"
        case .pathError: return "🍚🔥 PATH ERROR 🔥🍚"
        }
    }
}
