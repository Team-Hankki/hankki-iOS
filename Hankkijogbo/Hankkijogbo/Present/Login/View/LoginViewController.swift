import UIKit
import AuthenticationServices

final class LoginViewController: BaseViewController {

    // MARK: - UI Properties
    
    let viewTitle = UILabel()
    let imageView = UIImageView()
    let loginButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAction()
    }
    
    // MARK: - Set UI
    
    override func setupStyle() {
        viewTitle.do {
            $0.attributedText = UILabel.setupAttributedText(for: SuiteStyle.h1, withText: "밥값 고민 끝,\n다함께 한끼족보를 만들어봐요")
            $0.numberOfLines = 2
        }
        
        imageView.do {
            $0.backgroundColor = .gray100
        }
        
        loginButton.do {
            $0.backgroundColor = .gray900
            $0.makeRounded(radius: 14)
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: "Apple로 계속하기",
                color: .hankkiWhite
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            
            let image = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 24)).image { _ in
                UIImage.icHeart.draw(in: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))
            }

            $0.setImage(image, for: .normal)
        }
        
    }
    
    override func setupHierarchy() {
        view.addSubviews(viewTitle, imageView, loginButton)
    }
    
    override func setupLayout() {
        viewTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(63)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(viewTitle.snp.bottom).offset(31)
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.height.equalTo(UIScreen.convertByHeightRatio(411))
        }
        loginButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(31)
            $0.height.equalTo(54)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
    }
}

private extension LoginViewController {
    func setupAction() {
        loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
    }

    @objc func loginButtonDidTap() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        print("로그인 시도")
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let fullName = appleIDCredential.fullName
            let fullNameString = "\((fullName?.familyName ?? "") + (fullName?.givenName ?? ""))"
                         
            guard let identityToken = appleIDCredential.identityToken else { return }
            let identifyTokenString = String(data: identityToken, encoding: .utf8) ?? ""
        
            let postLoginRequest: PostLoginRequestDTO = PostLoginRequestDTO(identifyToken: identifyTokenString, name: fullNameString)
            postLogin(postLoginRequest)
            
        default:
            break
        }
        
    }
    
    // 실패 후 동작
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error) {
        print("애플 로그인 실패: \(error.localizedDescription)")
    }
}

private extension LoginViewController {
    func postLogin (_ postLoginRequest: PostLoginRequestDTO) {
        NetworkService.shared.authService.postLogin(requestBody: postLoginRequest) { result in
            switch result {
            case .success(let response):
                if response?.code == 200 {
                    let refreshToken = response?.data.refreshToken ?? ""
                    let accessToken = response?.data.accessToken ?? ""
                    print("요청 성공")
                    print("accessToken      : \(response?.data.accessToken ?? "")")
                    print("refreshToken     : \(response?.data.refreshToken ?? "")")
                    print("isRegistered     : \(response?.data.isRegistered ?? false)")
                    
                    UserDefaults.standard.set(accessToken, forKey: UserDefaultsKey.accessToken.rawValue)
                    UserDefaults.standard.set(refreshToken, forKey: UserDefaultsKey.refreshToken.rawValue)
                    
                    if response?.data.isRegistered ?? false {
                        // 로그인한 회원인 경우 -> 네비게이션의 홈 뷰로 이동
                        self.navigationController?.popToRootViewController(animated: true)
                        
                    } else {
                        // 회원가입인 경우 -> 대학 선택 뷰로 이동
                        self.navigationController?.popToRootViewController(animated: false)
                        self.navigationController?.pushViewController(UnivSelectViewController(), animated: true)
                    }
                }
                
            case .unAuthorized, .networkFail:
                print("POST LOGIN - TEST FAILED")
            default:
                return
            }
        }
    }
}
