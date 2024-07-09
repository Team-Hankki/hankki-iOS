//
//  MypageCollectionViewCellType.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

extension MypageViewController {
    enum SectionType: Int, CaseIterable {
        case zip, hankki, option
        
        var numberOfItemsInSection: Int {
            switch self {
            case .zip:
                1
            case .hankki:
                2
            case .option:
                3
            }
        }
    }
    
    func setupAction(_ section: SectionType, itemIndex: Int) {
        // TODO: - 함수 추후 변경
        switch section {
        case .zip:
            print("나의 한끼 족보로 이동")
            
        case .hankki:
            print("제보하거나 좋아요한 한끼 식당 리스트로 이동")
            
        case .option:
            switch itemIndex {
            case 0:
                print("FAQ로 이동")
            case 1:
                print("1:1 문의로 이동")
            case 2:
                self.showAlert(
                    image: "dummy",
                    titleText: "정말 로그아웃 하실 건가요?",
                    subText: "Apple 계정을 로그아웃합니다",
                    secondaryButtonText: "돌아가기",
                    primaryButtonText: "로그아웃"
                )
            default:
                return
            }
        }
    }
    
    func setupSection(_ section: SectionType) -> NSCollectionLayoutSection {
        switch section {
        case .zip:
        return setupZipSection()
        case .hankki:
            return setupHankkiSection()
        case .option:
            return setupOptionSection()
        }
    }
}

