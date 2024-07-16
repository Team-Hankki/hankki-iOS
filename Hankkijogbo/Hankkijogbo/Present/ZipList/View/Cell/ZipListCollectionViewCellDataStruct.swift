//
//  File.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/10/24.
//

import UIKit

extension ZipListCollectionViewCell {
    struct DataStruct {
        let title: String
        var type: CellType = .common
    }
    
    enum CellType {
        case create
        case common
        case disable
        
        var backgroundColor: UIColor {
            switch self {
            case .create:
                .hankkiRed
            case .common:
                .gray800
            case .disable:
                .hankkiRedLight
            }
        }
        
        var image: UIImage {
            switch self {
            case .create:
                return .imgZipCreateNormal
            case .common:
                return .imgZipThumbnail1
            case .disable:
                return .imgZipCreateDisable
            }
        }
        
        var opacity: CGFloat {
            switch self {
            case .create:
                1.0
            case .common:
                1.0
            case .disable:
                0.4
            }
        }
    }
}
