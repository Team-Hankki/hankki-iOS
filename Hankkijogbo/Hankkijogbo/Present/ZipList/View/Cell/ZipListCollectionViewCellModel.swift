//
//  File.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/10/24.
//

import UIKit

extension ZipListCollectionViewCell {
    struct Model {
        let id: Int
        let title: String
        let imageUrl: String
        var type: CellType = .common
    }
    
    enum CellType {
        case create
        case common
        case disable
        
        var fontColor: UIColor {
            switch self {
            case .create:
                    .hankkiWhite
            case .common:
                .gray800
            case .disable:
                    .hankkiWhite
            }
        }
        var backgroundColor: UIColor {
            switch self {
            case .create:
                .red500
            case .common:
                .gray100
            case .disable:
                .red100
            }
        }
        
        func image(for imageType: ImageType?) -> UIImage {
            switch self {
            case .create:
                return .imgZipListCreateNormal
            case .common:
                return imageType?.imageForType() ?? .imgZipListThumbnail1
            case .disable:
                return .imgZipListCreateDisable
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
    
    enum ImageType {
        case TYPE_ONE
        case TYPE_TWO
        case TYPE_THREE
        case TYPE_FOUR
        
        init?(from string: String) {
            switch string {
            case "TYPE_ONE":
                self = .TYPE_ONE
            case "TYPE_TWO":
                self = .TYPE_TWO
            case "TYPE_THREE":
                self = .TYPE_THREE
            case "TYPE_FOUR":
                self = .TYPE_FOUR
            default:
                return nil
            }
        }
        
        func imageForType() -> UIImage {
            switch self {
            case .TYPE_ONE:
                return .imgZipListThumbnail1
            case .TYPE_TWO:
                return .imgZipListThumbnail2
            case .TYPE_THREE:
                return .imgZipListThumbnail3
            case .TYPE_FOUR:
                return .imgZipListThumbnail4
            }
        }
    }
}
