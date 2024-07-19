## 🍚 한끼족보-iOS
> 함께 만드는 8000원 이하 식당지도

치솟는 물가에 밥 한끼 먹기도 부담되는 요즘, 저렴한 식당을 공유하며 함께 잘 먹고 잘 살자


## 🍎 Developers
| [@mcrkgus](https://github.com/mcrkgus) | [@EunsuSeo01](https://github.com/EunsuSeo01) | [@shimseohyun](https://github.com/shimseohyun) |
|:---:|:---:|:---:|
|<img width="250" alt="mcrkgus" src="https://github.com/user-attachments/assets/acfb09f7-5600-4861-b5c4-bb2c337e8d17">|<img width="250" alt="EunsuSeo01" src="https://github.com/user-attachments/assets/0cb6f598-2627-4173-8206-3aef7726b129">|<img width="250" alt="shimseohyun" src="https://github.com/user-attachments/assets/53244098-45eb-48a6-a734-26a5854ab5d0">|
|`홈화면`<br/> `지도`<br/> `전체 식당 족보 리스트`<br/>| `식당 제보 화면`<br/> `식당 검색 화면`<br/> `식당 제보 완료 화면`<br/> `식당 상세 화면`<br/> `나의 식당 족보 바텀 시트`<br/>|`온보딩` `로그인`<br/> `대학 선택`<br/> `마이페이지`<br/> `나의 족보 만들기`<br/> `족보 내 식당 리스트 확인`<br/>|


## 🛠 Development Environment
<img width="77" alt="iOS" src="https://img.shields.io/badge/iOS-17.0-silver"> <img width="95" alt="Xcode" src="https://img.shields.io/badge/Xcode-15.3+-blue">

## 🎨 View & Feature
[🔗 View & Feature](https://fast-kilometer-dbf.notion.site/View-Feature-4372da0d228b47c094022e4dc8b7d1f5?pvs=4)

![Untitled](https://github.com/user-attachments/assets/fe048018-852c-4d9c-8aef-658f61e73a9c)



## ✏️ Project Design
[🔗 Project Design](https://fast-kilometer-dbf.notion.site/Project-Design-ff41dbf4511547efaedef8fb546e7f4e?pvs=4)

![프로젝트 아키텍쳐](https://github.com/user-attachments/assets/f24bb0da-61f3-4105-b89d-32ed6709e24c)


## 💻 Code Convention

[🔗 Code Convention](https://fast-kilometer-dbf.notion.site/Coding-Convention-4f9de9541571486e86bfaa5a548137e3?pvs=4)
> StyleShare 의 Swift Style Guide 를 기본으로 작성되었습니다.
> SwiftLint 를 통해서 통일성있는 클린코드를 추구합니다.
```
1. 성능 최적화와 위해 더 이상 상속되지 않을 class 에는 꼭 final 키워드를 붙입니다.
2. 안전성을 위해 class 에서 사용되는 property는 모두 private로 선언합니다.
3. 명시성을 위해 약어와 생략을 지양합니다.
   VC -> ViewController
   TVC -> TableViewCell
4. 빠른 확인을 위해 Global위치에 함수를 만든다면, 퀵 헬프 주석을 답니다.
5. 런타임 크래시를 방지하기 위해 강제 언래핑을 사용하지 않습니다.
```

## 🖊️ Git Flow

[🔗 Git Convention](https://fast-kilometer-dbf.notion.site/Github-Convention-45ae288d2b0943439cb4cae9bb61ec58?pvs=4)

- `develop 브랜치` 개발 작업 브랜치
- `main 브랜치` 릴리즈 버전 관리 브랜치

```
1. 작업할 내용에 대해서 이슈를 생성한다.
2. 나의 로컬에서 develop 브랜치가 최신화 되어있는지 확인한다.
3. develop 브랜치에서 새로운 이슈 브랜치를 생성한다 [커밋타입/#이슈번호]
4. 만든 브랜치에서 작업한다.
5. 커밋은 기능마다 쪼개서 작성한다.
6. 작업 완료 후, 에러가 없는지 확인한 후 push 한다
7. 코드리뷰 후 수정사항 반영한 뒤, develop 브랜치에 merge 한다
```


## 📂 Foldering
```
📁 Project
├── 📁 Application
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── LaunchScreen.storyboard
│   └── Info.plist
├── 📁 Global
│   ├── 🗂️ Protocols
│   ├── 🗂️ Components
│   │   ├── HankkiPopup
│   │   └── HankkiButton
│   ├── 🗂️ Consts
│   │   └── ImageLiterals
│   ├── 🗂️ Extensions
│   │   ├── UIView+.swift
│   │   ├── UIViewController+.swift
│   │   ├── UIFont+.swift
│   │   └── UIColor+.swift
│   ├── 🗂️ Resources
│   │   ├── Fonts
│   │   └── Assets.xcassets
│   └── 🗂️ Supporting Files
│       ├── Config.swift
│       └── Debug.xcconfig
│       └── Release.xcconfig
├── 📁 Network
│   ├── 🗂️ Base
│   │   ├── BaseDTO.swift
│   │   ├── BaseAPIService.swift
│   │   ├── BaseTargetTypeswift
│   │   ├── NetworkResult.swift
│   │   └── NetworkService.swift
│   └── 🗂️ Home
│       ├── DTO
│       ├── HomeAPI.swift
│       └── HomeAPIService.swift
└── 📁 Present
    ├── 🗂️ Base
    │   ├── BaseCollectionViewCell.swift
    │   ├── BaseTableViewCell.swift
    │   └── BaseViewController.swift
    ├── 🗂️ Home
    │   ├── Model
    │   ├── View
    │   └── ViewModel
    └── 🗂️ HankkiPlayList
```

## 🎁 Library
| Name         | Version  |          |
| ------------ |  :-----: |  ------------ |
| [Then](https://github.com/devxoul/Then) | `3.0.0` | 객체를 생성하고 설정하는 코드를 하나의 블록으로 묶어 가독성을 향상시킨다. |
| [SnapKit](https://github.com/SnapKit/SnapKit) | `5.7.1` | Auto Layout 제약조건을 코드로 쉽게 작성할 수 있도록 한다. |
| [Moya](https://github.com/Moya/Moya) |  `15.0.3`  | 네트워크 요청을 간편화하고, 구조화된 방식으로 관리하여 코드의 가독성과 유지 보수성을 높인다.|
| [Kingfisher](https://github.com/onevcat/Kingfisher) | `7.12.0` | URL로부터 이미지 다운 중 처리 작업을 간소화할 수 있도록 한다. |
| [NMFMaps](https://navermaps.github.io/ios-map-sdk/guide-ko/1.html) | `15.0.3` | 다양한 지도 기능을 원활하게 구현할 수 있도록 한다. |
| [Lottie](https://github.com/airbnb/lottie-ios) | `4.5.0` | 벡터 그래픽 애니메이션을 추가하고 관리한다. |


## 🔥 Trouble Shooting
[🔗 Trouble Shooting](https://fast-kilometer-dbf.notion.site/trouble-shooting-d491565abcb94a72b4a6b36716a6fb05?pvs=4)

### Off The Record
![image](https://github.com/user-attachments/assets/eecbe550-5816-4d29-96b9-c654ddef5eae)

