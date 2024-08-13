//
//  GetMeResponseDTO.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/17/24.
//

import Foundation

struct GetMeResponseData: Codable {
    // TODO: - 서현) Server 업데이트 되면 Image 부분 지우기 디코딩 에러난다!!!!!
    let nickname: String
    let profileImageUrl: String
}
