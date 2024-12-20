//
//  MypageViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import AuthenticationServices
import UIKit

final class MypageViewController: BaseViewController {
    
    // MARK: - Properties
    
    let viewModel: MypageViewModel = MypageViewModel()
    
    private let hankkiList: [MypageHankkiCollectionViewCell.Model] = [
        MypageHankkiCollectionViewCell.Model(title: StringLiterals.Mypage.HankkiList.myZip,
                                             image: .icMypageMyzip),
        MypageHankkiCollectionViewCell.Model(title: StringLiterals.Mypage.HankkiList.reported,
                                             image: .icMypageReported),
        MypageHankkiCollectionViewCell.Model(title: StringLiterals.Mypage.HankkiList.liked,
                                             image: .icMypageLiked)
    ]
    
    private let optionList: [MypageOptionCollectionViewCell.Model] = [
        MypageOptionCollectionViewCell.Model(title: StringLiterals.Mypage.Option.OneonOne),
        MypageOptionCollectionViewCell.Model(title: StringLiterals.Mypage.Option.Terms),
        MypageOptionCollectionViewCell.Model(title: StringLiterals.Mypage.Option.Logout)
    ]
    
    // MARK: - UI Properties
    
    private lazy var layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
        return self.setupCollectionViewSection(for: SectionType(rawValue: sectionIndex)!)
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        
         setupNavigationBar()
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func setupHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MypageViewController {
    func navigateToHankkiListViewController(_ type: HankkiListViewController.HankkiListViewControllerType) {
        let hankkiListViewController = HankkiListViewController(type)
        navigationController?.pushViewController(hankkiListViewController, animated: true)
    }
}

private extension MypageViewController {
    func setupRegister() {
        collectionView.register(MypageHeaderView.self, 
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MypageHeaderView.className)
        
        collectionView.register(MypageHankkiCollectionViewCell.self,
                                forCellWithReuseIdentifier: MypageHankkiCollectionViewCell.className)
        
        collectionView.register(MypageSeparatorView.self,
                                forSupplementaryViewOfKind: MypageSeparatorView.className,
                                withReuseIdentifier: MypageSeparatorView.className)
        
        collectionView.register(MypageOptionCollectionViewCell.self, 
                                forCellWithReuseIdentifier: MypageOptionCollectionViewCell.className)
    
        collectionView.register(MypageQuitFooterView.self, 
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: MypageQuitFooterView.className)
    }
    
    func setupDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupCollectionViewSection(for section: SectionType) -> NSCollectionLayoutSection {
        setupSection(section)
    }
    
    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
     }
    
    func showQuitAlert() {
        self.showAlert(
            titleText: StringLiterals.Alert.Withdraw.title,
            secondaryButtonText: StringLiterals.Alert.Withdraw.secondaryButton,
            primaryButtonText: StringLiterals.Alert.Withdraw.primaryButton,
            secondaryButtonHandler: handdleWithdraw
        )
    }
}

// MARK: - Delegate

extension MypageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SectionType(rawValue: section)?.numberOfItemsInSection ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                 ofKind: kind,
                 withReuseIdentifier: MypageHeaderView.className,
                 for: indexPath
             ) as? MypageHeaderView else {
                 return UICollectionReusableView()
             }
            
            let nickname = UserDefaults.standard.getNickname()
            headerView.dataBind(MypageHeaderView.Model(name: nickname))
            
            return headerView
            
        case MypageSeparatorView.className:
            let separatorView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MypageSeparatorView.className,
                for: indexPath
            )as! MypageSeparatorView
            
            return separatorView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MypageQuitFooterView.className,
                for: indexPath
            )as! MypageQuitFooterView
            
            footerView.quitButtonHandler = {
                self.showQuitAlert()
            }
            
            return footerView
        
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SectionType(rawValue: indexPath.section) {
        case .hankki:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageHankkiCollectionViewCell.className, for: indexPath) as? MypageHankkiCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.dataBind(hankkiList[indexPath.item])
            return cell
            
        case .option:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageOptionCollectionViewCell.className, for: indexPath) as? MypageOptionCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.dataBind(optionList[indexPath.item])
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

private extension MypageViewController {
    func handdleWithdraw() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension MypageViewController: UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setupAction(SectionType(rawValue: indexPath.section)!, itemIndex: indexPath.item)
    }
}
extension MypageViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let authorizationCodeData = appleIDCredential.authorizationCode {
                if let authorizationCodeString = String(data: authorizationCodeData, encoding: .utf8) {
                    dismiss(animated: false)
                    viewModel.deleteWithdraw(authorizationCode: authorizationCodeString)
                }
            }
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

extension MypageViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}
