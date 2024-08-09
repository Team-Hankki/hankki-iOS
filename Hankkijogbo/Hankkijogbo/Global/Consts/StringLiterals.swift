//
//  StringLiterals.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import Foundation

enum StringLiterals {
    enum Common {
        static let goToHome = "홈으로"
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
        static let check = "확인"
        static let alreadyReportHankki = "이미 등록된 식당이에요\n다른 식당을 제보해주세요 :)"
    }
    
    enum Toast {
        static let addToMyZipBlack = "나의 족보에 추가되었습니다."
        static let see = "보기"
        static let addToMyZipWhite = "내 족보에 추가했어요"
        static let move = "이동"
    }
    
    enum Report {
        static let mainButton = "제보하기"
        static let categoryHeader = "식당 종류를 알려주세요"
        static let menuHeader = "메뉴를 추가해주세요"
        static let goToReportedHankki = "제보한 식당 보러가기"
        static let hankkiReportComplete = "번째 식당을 등록했어요"
        static let randomThanksMessageVer1 = "님이 모두의 지갑을 지켰어요!"
        static let randomThanksMessageVer2 = "님 덕분에 모두가 저렴하고\n맛있는 식사를 할 수 있어요!"
        static let randomThanksMessageVer3 = "님, 오늘도 저렴하고 든든한 식사하세요!"
        static let hankkiReportedByMe = "내가 등록한 식당"
        static let reportHankki = "식당을 제보해주세요"
        static let searchHankkiByName = "식당 이름으로 검색하면\n주소를 찾아 드릴게요"
    }
    
    enum MyZip {
        static let myHankkiZip = "나의 식당 족보"
        static let addNewZip = "새로운 족보 추가하기"
        static let zipList = "족보 목록"
        static let addToMyZip = "내 족보에 추가"
        static let addToOtherZip = "다른 족보에도 추가"
        static let zipThumbnailImageType1 = "TYPE_ONE"
        static let zipThumbnailImageType2 = "TYPE_TWO"
        static let zipThumbnailImageType3 = "TYPE_THREE"
        static let zipThumbnailImageType4 = "TYPE_FOUR"
    }
    
    enum NotificationName {
        static let updateAddToMyZipList = "UpdateAddToMyZipList"
        static let setupBlackToast = "SetupBlackToast"
    }
}
