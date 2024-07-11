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
                .hankkiYellow
            case .common:
                .gray800
            case .disable:
                .hankkiYellowLight
            }
        }
        
        var fontColor: UIColor {
            switch self {
            case .create:
                .gray800
            case .common:
                .white
            case .disable:
                .gray400
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
