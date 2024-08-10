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
        static let won = "원"
        static let report = "제보하기"
    }
    
    enum Home {
        static let storeCategoryFilteringButton = "종류"
        static let priceFilteringButton = "가격대"
        static let sortFilteringButton = "정렬"
        static let less6000 = "6000원 이하"
        static let more6000 = "6000~8000원"
    }
    
    enum Alert {
        static let unknownError = "알 수 없는 오류가 발생했어요"
        static let tryAgain = "네트워크 연결 상태를 확인하고\n다시 시도해주세요"
        static let alreadyReportHankki = "이미 등록된 식당이에요\n다른 식당을 제보해주세요 :)"
        static let waitPlease = "조금만 기다려주세요!"
        static let prepareForEditMenu = "메뉴를 편집할 수 있도록 준비하고 있어요 :)"
        static let thanksForReport = "님,\n변동사항을 알려주셔서 감사합니다 :)\n오늘도 저렴하고 든든한 식사하세요!"
        static let reallyReport = "정말 제보하시겠어요?"
        static let makeAccurateHannki = "여러분의 제보가 더 정확한 한끼족보를 만들어줘요 :)"
        static let check = "확인"
        static let goBack = "돌아가기"
    }
    
    enum Toast {
        static let addToMyZipBlack = "나의 족보에 추가되었습니다."
        static let see = "보기"
        static let addToMyZipWhite = "나의 족보에 추가했어요"
        static let move = "이동"
    }
    
    enum Toolbar {
        static let done = "Done"
    }
    
    enum Placeholder {
        static let menuName = "예) 된장찌개"
        static let price = "8000"
    }
    
    enum HankkiDetail {
        static let editMenu = "메뉴 추가/수정하기"
        static let reportWrongInformation = "내가 알고 있는 정보와 다른가요?"
        static let optionDisappear = "식당이 사라졌어요"
        static let optionIncreasePrice = "더이상 8,000원 이하인 메뉴가 없어요"
        static let optionImproperReport = "부적절한 제보예요"
        
    }
    
    enum Report {
        static let numberOfReport = "번째 제보예요"
        static let reportThisLocation = "을 제보할래요"
        static let searchFirstPlaceHolder = "이름으로 식당 검색"
        static let searchSecondPlaceHolder = "식당 이름으로 검색"
        static let categoryHeader = "식당 종류를 알려주세요"
        static let addMenuTitle = "메뉴를 추가해주세요"
        static let addMenuSubtitle = "한끼로 적당한 메뉴를 추천해주세요"
        static let addImage = "대표 음식 이미지 첨부하기 (선택)"
        static let changeImage = "바꾸기"
        static let menuName = "메뉴 이름"
        static let price = "가격"
        static let priceError = "8000원 이하만 가능해요"
        static let addMenu = "메뉴 추가하기"
        static let goToReportedHankki = "제보한 식당 보러가기"
        static let hankkiReportComplete = "번째 식당을 등록했어요"
        static let randomThanksMessageVer1 = "님이 모두의 지갑을 지켰어요!"
        static let randomThanksMessageVer2 = "님 덕분에 모두가 저렴하고\n맛있는 식사를 할 수 있어요!"
        static let randomThanksMessageVer3 = "님, 오늘도 저렴하고 든든한 식사하세요!"
        static let hankkiReportedByMe = "내가 등록한 식당"
        static let reportHankki = "식당을 선택해주세요"
        static let searchHankkiByName = "식당 이름으로 검색하면\n주소를 찾아 드릴게요"
    }
    
    enum MyZip {
        static let myHankkiZip = "나의 식당 족보"
        static let addNewZip = "새로운 족보 추가하기"
        static let zipList = "족보 목록"
        static let addToMyZip = "나의 족보에 추가"
        static let addToOtherZip = "다른 족보에도 추가"
        static let zipThumbnailImageType1 = "TYPE_ONE"
        static let zipThumbnailImageType2 = "TYPE_TWO"
        static let zipThumbnailImageType3 = "TYPE_THREE"
        static let zipThumbnailImageType4 = "TYPE_FOUR"
    }
    
    enum NotificationName {
        static let updateAddToMyZipList = "UpdateAddToMyZipList"
        static let setupToast = "SetupToast"
    }
    
    enum ExternalLink {
        static let OneonOne = "https://tally.so/r/mO0oJY"
        static let FAQ = "https://fast-kilometer-dbf.notion.site/FAQ-bb4d74b681d14f4f91bbbcc829f6d023?pvs=4"
    }
}
