//
//  FullLoadingView.swift
//  Hankkijogbo
//
//  Created by 심서현 on 8/25/24.
//

import UIKit

import Lottie

final class FullLoadingView: BaseView {
    
    // MARK: - UI Components
    private let spinner: LottieAnimationView = LottieAnimationView()
    
    override func setupHierarchy() {
        self.addSubview(spinner)
    }
    
    override func setupLayout() {
        spinner.snp.makeConstraints {
            $0.size.equalTo(68)
            $0.center.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.isHidden = true
        }
        
        spinner.do {
            $0.animation = LottieAnimation.named("loading")
            $0.contentMode = .scaleAspectFill
            $0.loopMode = .loop
            $0.stop()
        }
    }
}

extension FullLoadingView {
    func showLoadingView(_ type: LoadingViewType) {
        self.do {
            $0.isHidden = false
        }
        
        spinner.do {
            $0.isHidden = type == .submit
            $0.play()
        }
    }
    
    func dismissLoadingView(_ type: LoadingViewType) {
        self.do {
            $0.isHidden = true
        }
        
        spinner.do {
            $0.stop()
        }
    }
}
