//
//  MypageViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import UIKit

import AuthenticationServices

final class MypageViewController: BaseViewController {
    
    // MARK: - Properties
    
    let viewModel: MypageViewModel = MypageViewModel()
    
    private let hankkiList: [MypageHankkiCollectionViewCell.DataStruct] = [
        MypageHankkiCollectionViewCell.DataStruct(image: .icFood31, title: "내가 제보한 식당"),
        MypageHankkiCollectionViewCell.DataStruct(image: .icLike, title: "좋아요 누른 식당")
    ]
    
    private let optionList: [MypageOptionCollectionViewCell.DataStruct] = [
        MypageOptionCollectionViewCell.DataStruct(title: "FAQ"),
        MypageOptionCollectionViewCell.DataStruct(title: "1:1 문의"),
        MypageOptionCollectionViewCell.DataStruct(title: "로그아웃")
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
        
        setupViewModel()
        
        viewModel.getMe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        
         setupNavigationBar()
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
    private func setupViewModel() {
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                guard let headerView = self?.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? MypageHeaderView else { return }
                headerView.dataBind(self?.viewModel.userInfo ?? nil)
            }
        }
    }
    
    func setupRegister() {
        collectionView.register(MypageZipCollectionViewCell.self, forCellWithReuseIdentifier: MypageZipCollectionViewCell.className)
        collectionView.register(MypageHankkiCollectionViewCell.self, forCellWithReuseIdentifier: MypageHankkiCollectionViewCell.className)
        collectionView.register(MypageOptionCollectionViewCell.self, forCellWithReuseIdentifier: MypageOptionCollectionViewCell.className)
        
        collectionView.register(MypageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MypageHeaderView.className)
        collectionView.register(MypageQuitFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MypageQuitFooterView.className)
    }
    
    func setupDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupCollectionViewSection(for section: SectionType) -> NSCollectionLayoutSection {
        setupSection(section)
    }
    
    func setupNavigationBar() {
         let type: HankkiNavigationType = HankkiNavigationType(hasBackButton: false,
                                                               hasRightButton: false,
                                                               mainTitle: .string("MY"),
                                                               rightButton: .string(""),
                                                               rightButtonAction: {})
                                                                 
        if let navigationController = navigationController as? HankkiNavigationController {
              navigationController.setupNavigationBar(forType: type)
        }
     }
    
    func showQuitAlert() {
        self.showAlert(
            titleText: "소중한 족보가 사라져요",
            secondaryButtonText: "돌아가기",
            primaryButtonText: "탈퇴하기",
            primaryButtonHandler: handdleWithdraw
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
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MypageHeaderView.className,
                for: indexPath
            )
            return headerView
            
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
        case .zip:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageZipCollectionViewCell.className, for: indexPath) as? MypageZipCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
            
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
            cell.dataBind(data: optionList[indexPath.item])
            return cell
            
        case .none:
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
