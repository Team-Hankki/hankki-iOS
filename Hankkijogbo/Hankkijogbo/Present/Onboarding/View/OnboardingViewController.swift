//
//  OnboardingViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/19/24.
//

import UIKit

import Lottie

final class OnboardingViewController: UIViewController {
    
    let onboarding1 = LottieAnimation.named("onboarding1")
    private lazy var animationView: LottieAnimationView = LottieAnimationView(animation: self.onboarding1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.frame = CGRect(x: 0, y: 0,
                                     width: UIScreen.getDeviceWidth(),
                                     height: UIScreen.getDeviceHeight())
        animationView.center = view.center
        view.addSubview(animationView)
          
        animationView.play()
    }
}
