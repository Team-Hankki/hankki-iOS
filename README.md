## 🍚 한끼족보-iOS
> 함께 만드는 8000원 이하 식당지도

치솟는 물가에 밥 한끼 먹기도 부담되는 요즘, 저렴한 식당을 공유하며 함께 잘 먹고 잘 살자


## 🍎 Developers
| [@mcrkgus](https://github.com/mcrkgus) | [@EunsuSeo01](https://github.com/EunsuSeo01) | [@shimseohyun](https://github.com/shimseohyun) |
|:---:|:---:|:---:|
|<img width="250" alt="mcrkgus" src="https://github.com/user-attachments/assets/acfb09f7-5600-4861-b5c4-bb2c337e8d17">|<img width="250" alt="EunsuSeo01" src="https://github.com/user-attachments/assets/0cb6f598-2627-4173-8206-3aef7726b129">|<img width="250" alt="shimseohyun" src="https://github.com/user-attachments/assets/53244098-45eb-48a6-a734-26a5854ab5d0">|
|어떤|일을|할까|


## 🛠 Development Environment
<img width="77" alt="iOS" src="https://img.shields.io/badge/iOS-17.0-silver"> <img width="95" alt="Xcode" src="https://img.shields.io/badge/Xcode-15.3+-blue">



## 💻 Git Convention
### Git Flow
- `develop 브랜치` 개발 작업 브랜치
- `main 브랜치` 릴리즈 버전 관리 브랜치

<사진>

```
1. 작업할 내용에 대해서 이슈를 생성한다.
2. 나의 로컬에서 develop 브랜치가 최신화 되어있는지 확인한다.
3. develop 브랜치에서 새로운 이슈 브랜치를 생성한다 [커밋타입/#이슈번호]
4. 만든 브랜치에서 작업한다.
5. 커밋은 기능마다 쪼개서 작성한다.
6. 작업 완료 후, 에러가 없는지 확인한 후 push 한다
7. 코드리뷰 후 수정사항 반영한 뒤, develop 브랜치에 merge 한다
```

- *Tag*

| 태그      | 설명                                      |
|-----------|-------------------------------------------|
| Feat      | 새로운 기능 구현                           |
| Fix       | 버그, 오류 해결                            |
| Chore     | 코드 수정, 내부 파일 수정                   |
| Add       | 라이브러리 추가, 에셋 추가                 |
| Del       | 쓸모없는 코드 삭제                         |
| Docs      | README나 WIKI 등의 문서 개정                |
| Refactor  | 전면 수정                                  |
| Setting   | 프로젝트 설정                              |
| Merge     | 다른 브랜치와 병합함                       |

### Issue
```Swift
[종류] 작업 명
ex) [Feat] Main View UI 구현
```
`담당자`, `라벨` 추가 하기

### Commit
```Swift
[종류] #이슈 - 작업 이름
ex) [Feat] #13 - Main UI 구현

✅ Merge
/// feature branch -> develop
기본 머지 메세지

/// develop branch -> feature branch (브랜치 최신화)
[Merge] #이슈 - Pull Develop
ex) [Merge] #13 - Pull Develop
```

### Pull Request
```Swift
[종류] #이슈번호 작업명
ex) [Feat] #13 Main View UI 구현
```
`담당자`, `리뷰어`, `라벨` 추가 하기

- *Code Review*
```Swift
✅ Pn Rule

P1 : 꼭 반영해주세요. 

P2 : 반영하면 좋을 것 같습니다. 

P3 : 단순 의견 제시 (무시해도 됩니다)
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
│   └── 🗂️ Home
│       ├── DTO
│       ├── HomeAPI.swift
│       └── HomeAPIService.swift
└── 📁 Present
    ├── 🗂️ Base
    │   ├── BaseCollectionViewCell.swift
    │   ├── BaseModel.swift
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
| [MapKit](https://github.com/Moya/Moya) | `15.0.3` | 다양한 지도 기능을 원활하게 구현할 수 있도록 한다. |
| [Lottie](https://github.com/airbnb/lottie-ios) | `4.5.0` | 벡터 그래픽 애니메이션을 추가하고 관리한다. |
