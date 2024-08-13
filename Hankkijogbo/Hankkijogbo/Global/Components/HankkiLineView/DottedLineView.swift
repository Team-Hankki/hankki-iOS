//
//  DottedLineView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 8/13/24.
//

import UIKit

/// 도트로 이루어진 line
class DottedLineView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 1, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        
        let dashPattern: [NSNumber] = [0, 5]
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.gray100.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = dashPattern
        shapeLayer.lineCap = .round
        
        layer.addSublayer(shapeLayer)
    }
}
