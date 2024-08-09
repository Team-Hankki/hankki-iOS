//
//  StringLiterals.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import Foundation

enum StringLiterals {
    enum Common {
        static let withdraw = "탈퇴하기"
        static let logout = "로그아웃"
    }
    enum Home {
        static let storeCategoryFilteringButton = "종류"
        static let priceFilteringButton = "가격대"
        static let sortFilteringButton = "정렬"
        static let less6000 = "6000원 이하"
        static let more6000 = "6000~8000원"
        static let won = "원"
    }
    
    enum Alert {
        static let unknownError = "알 수 없는 오류가 발생했어요"
        static let tryAgain = "네트워크 연결 상태를 확인하고\n다시 시도해주세요"
        
        static let back = "돌아가기"
        static let check = "확인"
        
        enum Logout {
            static let title = "정말 로그아웃 하실 건가요?"
            static let secondaryButton = StringLiterals.Common.logout
        }
        enum Withdraw {
            static let title = "소중한 족보가 사라져요"
            static let secondaryButton = StringLiterals.Common.withdraw
        }
    }
    
    enum Report {
        static let mainButton = "제보하기"
        static let categoryHeader = "식당 종류를 알려주세요"
        static let menuHeader = "메뉴를 추가해주세요"
    }
    
    enum Mypage {
        static let navigation = "MY"
        
        static let myZipList = "나의 족보"
        
        enum HankkiList {
            static let reported = "내가 제보한 식당"
            static let liked = "좋아요 누른 식당"
        }
        
        enum Option {
            static let FAQ = "FAQ"
            static let OneonOne = "1:1 문의"
            static let Logout = "로그아웃"
        }
        
        enum Header {
            static let greeting = "님\n한끼 잘 챙겨드세요"
        }
    }
    
    enum HankkiList {
        
    }
    
    enum ExternalLink {
        static let OneonOne = "https://tally.so/r/mO0oJY"
        static let FAQ = "https://fast-kilometer-dbf.notion.site/FAQ-bb4d74b681d14f4f91bbbcc829f6d023?pvs=4"
    }
}
