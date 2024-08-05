//
//  UIButton+.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import UIKit

extension UIButton {
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let minimumSize: CGSize = CGSize(width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(minimumSize)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: minimumSize))
        }
        
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.clipsToBounds = true
        self.setBackgroundImage(colorImage, for: state)
    }
    
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
    
    /// - 버튼의 패딩을 설정하는 함수
    func setupPadding(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
        if self.configuration == nil {
            self.configuration = UIButton.Configuration.filled()
        }
        guard var configuration = self.configuration else { return }
        configuration.contentInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
        self.configuration = configuration
    }
    
    /// - 버튼의 배경 색을 설정하는 함수
    func setupBackgroundColor(_ color: UIColor) {
        if self.configuration == nil {
            self.configuration = UIButton.Configuration.filled()
        }
        guard var configuration = self.configuration else { return }
        configuration.baseBackgroundColor = color
        self.configuration = configuration
    }
    
    /// - 버튼의 아이콘을 설정하는 함수
    /// - icon: 버튼 아이콘,
    /// - gap: 아이콘과 타이틀과의 간격
    func setupIcon(_ icon: UIImage, gap: CGFloat, itemPlace: NSDirectionalRectEdge = .leading) {
        if self.configuration == nil {
            self.configuration = UIButton.Configuration.filled()
        }
        guard var configuration = self.configuration else { return }
        configuration.image = icon
        configuration.imagePlacement = itemPlace
        configuration.imagePadding = gap
        self.configuration = configuration
    }
}
