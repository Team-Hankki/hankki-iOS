//
//  HankkiNavigationType.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/6/24.
//

import UIKit

struct HankkiNavigationType {
    var hasBackButton: Bool     // backButton 존재 여부
    var hasRightButton: Bool    // rightButton 존재 여부

    var mainTitle: StringOrImageType        // mainTitle
    var rightButton: StringOrImageType      // rightButton
    var rightButtonAction: () -> Void   // rightButton의 액션
    var backgroundColor: UIColor = .hankkiWhite
}

enum StringOrImageType {
    case string(String)
    case image(UIImage)
    case stringAndImage(String, UIImage)
}
