//
//  StringLiterals.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import Foundation

// swiftlint:disable nesting
enum StringLiterals {
    enum Common {
        static let goToHome = "홈으로"
        static let withdraw = "탈퇴하기"
        static let logout = "로그아웃"
        
        static let share = "공유"
        
        static let won = "원"
        static let report = "제보하기"
    }
    
    enum Home {
        static let allUniversity = "전체"
        static let storeCategoryFilteringButton = "종류"
        static let priceFilteringButton = "가격대"
        static let sortFilteringButton = "정렬"
        static let less6000 = "6000원 이하"
        static let more6000 = "6000~8000원"
        static let emptyNotice = "조건에 맞는 식당이 없어요"
    }
    
    enum Alert {
        static let unknownError = "알 수 없는 오류가 발생했어요"
        static let tryAgain = "네트워크 연결 상태를 확인하고\n다시 시도해주세요"
        static let bigImageError = "이미지 파일이 너무 커요"
        static let smallImagePlease = "더 작은 이미지로 선택해주세요"
        static let loadImageError = "이미지를 불러올 수 없어요"
        static let checkImagePlease = "갤러리에서 이미지를 다시 선택해주세요"
        static let alreadyReportHankki = "등록된 식당이 있어요\n식당으로 이동할까요?"
        static let alreadyReportHankkiByOther = "다른 학교에 제보된 식당이에요\n우리 학교에도 추가할까요?"
        static let waitPlease = "조금만 기다려주세요!"
        static let thanksForReport = "님,\n변동사항을 알려주셔서 감사합니다 :)\n오늘도 저렴하고 든든한 식사하세요!"
        static let reallyReport = "정말 제보하시겠어요?"
        static let disappearInfoByReport = "제보시 식당 정보가 앱에서 사라져요"
        static let selectUniversityFirst = "대학교를 먼저 선택해주세요"
        static let check = "확인"
        static let back = "돌아가기"
        static let stay = "유지하기"
        static let no = "아니요"
        static let move = "이동하기"
        static let add = "추가하기"
        
        enum Logout {
            static let title = "정말 로그아웃 하실 건가요?"
            static let secondaryButton = StringLiterals.Common.logout
            static let primaryButton = StringLiterals.Alert.stay
        }
        enum Withdraw {
            static let title = "소중한 족보가 사라져요"
            static let secondaryButton = StringLiterals.Common.withdraw
            static let primaryButton = StringLiterals.Alert.stay
        }
        enum DeleteZip {
            static let title = "족보를 삭제할까요?"
            static let primaryButton = "삭제하기"
        }
        
        enum DevelopShare {
            static let title = StringLiterals.Alert.waitPlease
            static let sub = "친구에게 내 족보를 공유할 수 있도록\n준비 중이에요 :)"
            static let primaryButton = StringLiterals.Alert.check
        }
        
        enum DevelopEdit {
            static let title = StringLiterals.Alert.waitPlease
            static let sub = "메뉴를 편집할 수 있도록 준비 중이에요 :)"
            static let primaryButton = StringLiterals.Alert.check
        }
        
        enum NetworkError {
            static let title = "네트워크 오류가 발생했어요"
            static let sub = "네트워크 연결 상태를 확인하고 다시 시도해주세요"
            static let primaryButton = StringLiterals.Alert.check
        }
        
        enum CreateZipConflict {
            static let title = "동일이름 족보 생성 불가"
            static let sub = "같은 이름의 족보는 생성할 수 없어요"
            static let primaryButton = StringLiterals.Alert.check
        }
    }
    
    enum Toast {
        static let addToMyZipBlack = "나의 족보에 추가되었습니다."
        static let see = "보기"
        static let addToMyZipWhite = "나의 족보에 추가했어요"
        
        static let serverError = "오류가 발생했어요. 다시 시도해주세요."
        static let accessError = "로그인 유효기간이 만료되었어요. 재로그인 해주세요."
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
        static let emptySearchResult = "에 대한\n검색 결과가 없어요"
        static let reportThisHankki = "이 식당 제보하기"
        static let categoryHeader = "식당 종류를 알려주세요"
        static let addMenuTitle = "메뉴를 추가해주세요"
        static let addMenuSubtitle = "한끼로 적당한 메뉴를 추천해주세요"
        static let addImage = "대표 음식 이미지 첨부하기 (선택)"
        static let changeImage = "바꾸기"
        static let menuName = "메뉴 이름"
        static let price = "가격"
        static let priceError = "8천원 이하만 가능해요"
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
        static let myHankkiZip = "나의 족보"
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
        static let locationDidUpdate = "locationDidUpdate"
        static let presentMyZipBottomSheetNotificationName = "presentMyZipBottomSheetNotificationName"
    }
    
    enum Mypage {
        static let navigation = "MY"
        
        static let myZipList = "나의 족보"
        
        enum HankkiList {
            static let reported = "내가 제보한 식당"
            static let liked = "좋아요 누른 식당"
        }
        
        enum Option {
            static let Terms = "약관 및 정책"
            static let OneonOne = "1:1 문의"
            static let Logout = StringLiterals.Common.logout
        }
        
        enum Header {
            static let greeting = "님\n한끼 잘 챙겨드세요"
        }
    }
    
    enum ZipList {
        static let navigation = "나의 족보"
        static let navigationEdit = "편집"
        static let navigationDelete = "삭제"
        
        static let createZip = "새로운\n식당 족보\n추가하기"
    }
    
    enum CreateZip {
        static let viewTitle = "새로운 식당 족보"
        static let submitButton = "족보 만들기"
        
        enum TitleInput {
            static let label = "족보의 제목을 지어주세요"
            static let placeholder = "한끼대학교 든든한 식당 모음"
        }
        
        enum TagInput {
            static let label = "족보를 떠올리면?"
            static let placeholder = "#든든한 #한끼해장"
        }
    }
    
    enum HankkiList {
        enum Header {
            static let shareButton = StringLiterals.Common.share
        }
        
        static let moreButton = "식당 구경하러 가기"
        
        enum EmptyView {
            static let myZip = "나의 족보에\n식당을 추가해보세요"
            static let reported = "아직 제보한 식당이 없어요"
            static let liked = "아직 좋아요 누른 식당이 없어요"
        }
    }
    
    enum ExternalLink {
        static let OneonOne = "https://tally.so/r/mO0oJY"
        static let Terms = "https://fast-kilometer-dbf.notion.site/FAQ-bb4d74b681d14f4f91bbbcc829f6d023?pvs=4"
    }
}
