//
//  String+.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/12/24.
//

import Foundation

extension String {
    
    /// 한글, 영문, 숫자, 특수문자 포함 정규식 (이모티콘 제외)
    func hasCharacters() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[0-9a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ`~!@#$%^&*()\\-_=+\\[{\\]}\\\\|;:'\",<.>/?\\s]$", options: .caseInsensitive)
            if regex.firstMatch(
                in: self,
                options: NSRegularExpression.MatchingOptions.reportCompletion,
                range: NSMakeRange(0, self.count)
            ) != nil {
                return true
            }
        } catch {
            return false
        }
        return false
    }
    
    /// limit까지 자르고 "..." 추가해줌
    func getTruncatedTailString(limit: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: limit)
        return String(self[..<index]) + "..."
    }
}
