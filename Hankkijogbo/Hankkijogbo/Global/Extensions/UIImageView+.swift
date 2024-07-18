//
//  UIImageView+.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/17/24.
//

import UIKit
import Kingfisher

extension UIImageView{
    func setKFImage(url : String?){
        
        guard let url = url else { return }
        
        if let url = URL(string: url) {
            kf.indicatorType = .activity
            kf.setImage(with: url,
                        placeholder: nil,
                        options: [.transition(.fade(1.0))], progressBlock: nil)
        }
    }
}
