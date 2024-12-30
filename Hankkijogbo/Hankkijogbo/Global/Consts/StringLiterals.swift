//
//  StringLiterals.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import Foundation

// swiftlint:disable nesting
enum StringLiterals {
    enum Kakao {
        static let storeUrl = "itms-apps://itunes.apple.com/app/362057947"
        static let zipShareTemplete = 115383
    }
    
    enum Common {
        static let goToHome = "홈으로"
        static let withdraw = "탈퇴하기"
        static let logout = "로그아웃"
        
        static let share = "공유"
        
        static let won = "원"
        static let report = "제보하기"
        static let complete = "완료"
        static let delete = "삭제하기"
        static let modifyComplete = "수정 완료"
        
        static let price = "가격"
    }
    
    enum Home {
        static let entire = "전체"
        static let storeCategoryFilteringButton = "뭐 먹지"
        static let priceFilteringButton = "가격대"
        static let sortFilteringButton = "정렬"
        static let less6000 = "6000원 이하"
        static let more6000 = "6000~8000원"
        static let emptyNotice = "조건에 맞는 식당이 없어요"
        static let apply = "적용"
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
        static let cancel = "취소"
        static let move = "이동하기"
        static let add = "추가하기"
        
        enum Browse {
            static let title = "로그인이 필요한 기능이에요."
            static let secondaryButton = "닫기"
            static let primaryButton = "로그인하기"
        }
        
        enum NeedLoginToSharedZip {
            static let title = "족보를 확인하려면\n로그인이 필요해요"
            static let primaryButton = "로그인"
        }
        
        enum NeedOneMoreHankkiToShare {
            static let title = "족보에 식당이 없어요\n식당 1개 이상 시에만 공유할 수 있어요"
            static let secondaryButton = back
            static let primaryButton = "둘러보기"
        }
        
        enum Logout {
            static let title = "정말 로그아웃 하실 건가요?"
            static let secondaryButton = Common.logout
            static let primaryButton = stay
        }
        enum Withdraw {
            static let title = "소중한 족보가 사라져요"
            static let secondaryButton = Common.withdraw
            static let primaryButton = stay
        }
        enum DeleteZip {
            static let title = "족보를 삭제할까요?"
            static let primaryButton = Common.delete
        }
        
        enum DevelopShare {
            static let title = Alert.waitPlease
            static let sub = "친구에게 내 족보를 공유할 수 있도록\n준비 중이에요 :)"
            static let primaryButton = check
        }
        
        enum DevelopEdit {
            static let title = Alert.waitPlease
            static let sub = "메뉴를 편집할 수 있도록 준비 중이에요 :)"
            static let primaryButton = check
        }
        
        enum DeleteMenu {
            static let title = "삭제하면 되돌릴 수 없어요\n그래도 삭제하시겠어요?"
            static let secondaryButton = cancel
            static let primaryButton = Common.delete
        }
        
        enum DeleteLastMenu {
            static let title = "메뉴가 1개 있어요\n메뉴를 삭제하면 식당이 삭제돼요"
            static let secondaryButton = back
            static let primaryButton = "식당 삭제"
        }
        
        enum ModifyCompleteMenu {
            static let title = "메뉴를 모두 수정하셨나요?"
            static let secondaryButton = back
            static let primaryButton = Common.modifyComplete
        }
        
        enum NetworkError {
            static let title = "네트워크 오류가 발생했어요"
            static let sub = "네트워크 연결 상태를 확인하고 다시 시도해주세요"
            static let primaryButton = check
        }
        
        enum CreateZipConflict {
            static let title = "동일이름 족보 생성 불가"
            static let sub = "같은 이름의 족보는 생성할 수 없어요"
            static let primaryButton = check
        }
    }
    
    enum Toast {
        static let addToMyZipBlack = "나의 족보에 추가되었습니다"
        static let see = "보기"
        static let addToMyZipWhite = "나의 족보에 추가했어요"
        static let deleteAlready = "이미 삭제된 식당입니다"
        static let serverError = "오류가 발생했어요 다시 시도해주세요"
        static let accessError = "로그인 유효기간이 만료되었어요 재로그인 해주세요"
        static let addSharedZip = "족보가 추가되었습니다"
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
    
    enum EditHankki {
        static let howToEdit = "어떻게 편집할까요?"
        static let addNewMenu = "새로운 메뉴\n추가하기"
        static let modifyMenu = "원래 메뉴\n수정/삭제하기"
    }
    
    enum AddMenu {
        static let addNewMenuTitle = "새로운 메뉴를\n추가할게요"
        static let addNewMenuPlease = "메뉴를 추가해주세요"
        static let addMenuComplete = "개 추가하기"
        static let addMenuCompleteByYouFirst = "님이 말씀해주신\n메뉴 "
        static let addMenuCompleteByYouSecond = "개를 새로 추가했어요!"
    }
    
    enum ModifyMenu {
        static let editMenuTitle = "어떤 메뉴를 편집할까요?"
        static let deleteMenuButton = Common.delete
        static let modifyMenuButton = "수정하기"
        static let modifyMenuTitle = " 메뉴를\n수정할게요"
        static let name = "메뉴 이름"
        static let price = "메뉴 가격"
        static let namePlaceholder = "새로운 메뉴 이름"
        static let overPrice = "가격이 올랐군요"
        static let recommendDeleteMenu = "8천원을 넘는 메뉴는 삭제를 추천해요"
        static let overPriceErrorText = "8000원 이하만 제보 가능해요"
        static let modifyCarefullyPlease = "모두에게 보여지는 정보이니 신중하게 수정부탁드려요"
        static let modifyMenuCompleteButton = Common.modifyComplete
        static let editOtherMenuButton = "다른 메뉴도 편집하기"
        static let addOtherMenuButton = "다른 메뉴도 추가하기"
        static let completeByYou = "님이 말씀해주신대로\n"
        static let modifyMenuComplete = "메뉴 정보를 수정했어요!"
        static let deleteMenuComplete = "메뉴를 삭제했어요!"
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
        static let price = Common.price
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
        static let reloadHankkiDetail = "reloadHankkiDetail"
    }
    
    enum Mypage {
        static let navigation = "MY"
        
        static let myZipList = "나의 족보"
        
        enum HankkiList {
            static let myZip = "나의 족보"
            static let reported = "제보한 식당"
            static let liked = "좋아요한 식당"
        }
        
        enum Option {
            static let terms = "약관 및 정책"
            static let oneOnOne = "1:1 문의"
            static let logout = Common.logout
        }
        
        enum Header {
            static let nicknameFinal = "님"
            static let greeting = "한끼 잘 챙겨드세요 :)"
        }
    }
    
    enum ZipList {
        static let navigation = "나의 족보"
        static let navigationEdit = "편집"
        static let navigationDelete = "삭제"
        
        static let createZip = "새로운\n식당 족보\n추가하기"
    }
    
    enum CreateZip {
        static let viewTitle = "새로운 식당 족보 만들기"
        static let viewDescription = "족보의 제목을 짓고, 해시태그를 남겨\n새로운 족보를 만들 수 있어요"
        static let submitButton = "족보 만들기"
        
        enum TitleInput {
            static let label = "족보 제목"
            static let placeholder = "한식 맛집 모음"
        }
        
        enum TagInput {
            static let label = "족보 해시태그"
            static let placeholder = "#든든한 #가성비"
        }
    }
    
    enum HankkiList {
        enum Header {
            static let shareButton = Common.share
        }
        
        static let moreButton = "식당 구경하러 가기"
        static let lowest = "최저"
        
        enum EmptyView {
            static let myZip = "나의 족보에\n식당을 추가해보세요"
            static let reported = "아직 제보한 식당이 없어요"
            static let liked = "아직 좋아요 누른 식당이 없어요"
        }
    }
    
    enum SharedZip {
        static let zipShareDefaultImageURL = Config.DefaultHankkiImageURL
        
        static let navigation = "공유받은 족보"
        static let addButton = "내 족보에 추가하기"
        
        static let viewTitle = "공유받은 족보의\n새로운 이름을 지어주세요"
        static let viewDescription = "공유받은 족보는 내 마음대로 편집할 수 있어요!"
        static let submitButton = "추가하기"
    }
    
    enum ExternalLink {
        static let oneOnOne = "https://tally.so/r/mO0oJY"
        static let terms = "https://fast-kilometer-dbf.notion.site/FAQ-bb4d74b681d14f4f91bbbcc829f6d023?pvs=4"
        static let linkTree = "https://link.inpock.co.kr/hankkilink?fbclid=PAZXh0bgNhZW0CMTEAAabp7jPfQGVtGfHXOSEA-urXPNPbog0a0Rco43_a-zsdcxQOvFqVXQoqsXQ_aem_gyGO3bZoFAlf0tMF7QTqKg"
    }
    
    enum Onboarding {
        static let guest = "둘러보기"
    }
    
    enum FilteringTag {
        static let less6000 = "K6"
        static let more6000 = "K8"
        static let latest = "LATEST"
        static let recommended = "RECOMMENDED"
        static let lowestPrice = "LOWESTPRICE"
    }
}
