import AuthenticationServices
import UIKit

final class LoginViewController: BaseViewController {

    // MARK: - Properties
    
    let viewModel: LoginViewModel = LoginViewModel()
    
    // MARK: - UI Components
    
    private let guestButton: UIButton = UIButton()
    private let logoImageView: UIImageView = UIImageView()
    private let viewTitle: UILabel = UILabel()
    private let imageView: UIImageView  = UIImageView()
    private let loginButton: UIButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAction()
    }
    
    // MARK: - Set UI
    
    override func setupStyle() {
        view.do {
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .red500
        }
        
        guestButton.do {
            $0.setupPadding(top: 8, leading: 8, bottom: 8, trailing: 8)
            $0.setupBackgroundColor(.clear)
            
            let guestAttributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.body5,
                withText: StringLiterals.Onboarding.guest,
                color: .hankkiWhite
            )
            
            $0.setAttributedTitle(guestAttributedTitle, for: .normal)
        }
        
        logoImageView.do {
            $0.image = .imgLoginLogo
        }
        
        viewTitle.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.subtitle2,
                                                            withText: "밥값 고민 끝,\n다함께 한끼족보를 만들어봐요",
                                                            color: .hankkiWhite)
            $0.numberOfLines = 2
        }
        
        imageView.do {
            $0.image = .imgLoginScreen1
            $0.contentMode = .scaleAspectFit
        }
        
        loginButton.do {
            $0.backgroundColor = .hankkiWhite
            $0.makeRoundBorder(cornerRadius: 14, borderWidth: 0, borderColor: .clear)
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: "Apple로 계속하기",
                color: .gray900
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            $0.setImage(.icApple, for: .normal)
        }
        
    }
    
    override func setupHierarchy() {
        view.addSubviews(guestButton, imageView, logoImageView, viewTitle, loginButton)
    }
    
    override func setupLayout() {
        guestButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            $0.trailing.equalToSuperview().inset(14)
        }
        
        logoImageView.snp.makeConstraints {
            $0.width.equalTo(180)
            $0.height.equalTo(41)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(48)
            $0.left.equalToSuperview().inset(22)
        }
        viewTitle.snp.makeConstraints {
            $0.height.equalTo(54)
            $0.top.equalTo(logoImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
        
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(viewTitle.snp.bottom).offset(-20)
            $0.bottom.equalTo(loginButton.snp.top).offset(-10)
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
        guestButton.addTarget(self, action: #selector(guestButtonDidTap), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
    }

    @objc func guestButtonDidTap() {
        // 홈화면으로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let navigationController = HankkiNavigationController(rootViewController: TabBarController())
            self.view.window?.rootViewController = navigationController
            navigationController.popToRootViewController(animated: false)
        }
    }
        
    @objc func loginButtonDidTap() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
            appleIDCredential.email
            
            var fullNameString = "\((fullName?.familyName ?? "") + (fullName?.givenName ?? ""))"
                         
            var identityTokenString: String = ""
            
            if let identityToken = appleIDCredential.identityToken {
                identityTokenString = String(data: identityToken, encoding: .utf8) ?? ""
            } else { return }
            
            let postLoginRequest: PostLoginRequestDTO = PostLoginRequestDTO(name: fullNameString)
            
            let userId = appleIDCredential.user
            
            print("시리얼 아이디 : \(appleIDCredential.user)")
            
            UserDefaults.standard.saveUserId(userId)
            
            viewModel.postLogin(accessToken: identityTokenString, postLoginRequest: postLoginRequest)
            
        default:
            break
        }
        
    }
    
    // 실패 후 동작
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 실패: \(error.localizedDescription)")
    }
}
