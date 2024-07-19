//
//  OnboardingModel.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/19/24.
//

import UIKit

struct OnboardingModel {
    let titleText: String
    let titleColor: UIColor
    let skipButtonColor: UIColor
    let nextButtonText: String
    let nextButtonColor: UIColor
    let backgroundColor: UIColor
    let lottieFileName: String
}

func getOnboardingModelData() -> [OnboardingModel] {
    return [
    OnboardingModel(titleText: "밥값으로\n부담된 적 없으신가요?",
                    titleColor: .hankkiWhite,
                    skipButtonColor: .gray100,
                    nextButtonText: "다음으로",
                    nextButtonColor: .hankkiRed,
                    backgroundColor: .hankkiRed,
                    lottieFileName: "onboarding1"),
    OnboardingModel(titleText: "이제 우리학교 주변\n8000원 이하 식당을 찾아봐요",
                    titleColor: .gray900,
                    skipButtonColor: .gray400,
                    nextButtonText: "다음으로",
                    nextButtonColor: .hankkiRed,
                    backgroundColor: .hankkiWhite,
                    lottieFileName: "onboarding2"),
    OnboardingModel(titleText: "식당을 제보하고 다함께\n한끼족보를 만들어가요",
                    titleColor: .gray900,
                    skipButtonColor: .gray400,
                    nextButtonText: "다음으로",
                    nextButtonColor: .hankkiRed,
                    backgroundColor: .hankkiWhite,
                    lottieFileName: "onboarding3"),
    OnboardingModel(titleText: " ",
                    titleColor: .hankkiWhite,
                    skipButtonColor: .hankkiWhite,
                    nextButtonText: "다음으로",
                    nextButtonColor: .hankkiWhite,
                    backgroundColor: .hankkiWhite,
                    lottieFileName: "onboarding4")
    ]
}
