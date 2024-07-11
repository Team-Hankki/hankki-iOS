//
//  CreateZipViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/11/24.
//

import UIKit

final class CreateZipViewController: BaseViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let viewTitle = UILabel()
    
    private let titleInputTitle = UILabel()
    private let titleInputTextField = UITextField()
    
    private let tagInputTitle = UILabel()
    private let tagInputTextField = UITextField()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
    }
    
    // MARK: - Set UI
    
    override func setupStyle() {
        viewTitle.do {
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.h1, 
                                                            withText: "새로운 식당 족보", 
                                                            color: .gray900)
        }
        
        titleInputTitle.do {
            $0.attributedText = UILabel.setupAttributedText(for: SuiteStyle.body1,
                                                            withText: "족보의 제목을 지어주세요",
                                                            color: .gray900)
        }
        
        titleInputTextField.do {
            $0.tag = 0
            $0.makeRounded(radius: 10)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.addPadding(left: 12)
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body1, color: .gray900)
            $0.changePlaceholderColor(forPlaceHolder: "성대생 추천 맛집 알려주세요", forColor: .gray400)
        }
        
        tagInputTitle.do {
            $0.attributedText = UILabel.setupAttributedText(for: SuiteStyle.body1,
                                                            withText: "족보를 떠올리면?",
                                                            color: .gray900)
        }
        
        tagInputTextField.do {
            $0.tag = 1
            $0.makeRounded(radius: 10)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.addPadding(left: 12)
            $0.attributedText = UILabel.setupAttributedText(for: PretendardStyle.body1, color: .gray900)
            $0.placeholder = "#든든한 #한끼해장"
            $0.changePlaceholderColor(forPlaceHolder: "#든든한 #한끼해장", forColor: .gray400)
        }
    }
    
    override func setupHierarchy() {
        view.addSubviews(
            viewTitle,
            titleInputTitle, 
            titleInputTextField, 
            tagInputTitle,
            tagInputTextField
          )
    }
    
    override func setupLayout() {
        viewTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(75)
        }
        
        titleInputTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22)
            $0.top.equalTo(viewTitle.safeAreaLayoutGuide).inset(57)
        }
        
        titleInputTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.top.equalTo(titleInputTitle.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        
        tagInputTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22)
            $0.top.equalTo(titleInputTextField.snp.bottom).offset(30)
        }
        
        tagInputTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.top.equalTo(tagInputTitle.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        
    }
    
}

private extension CreateZipViewController {
    func setupDelegate() {
        titleInputTextField.delegate = self
        tagInputTextField.delegate = self
    }
}

// MARK: - delegate
extension CreateZipViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("진행중", textField.tag)
        
        guard let text = textField.text else { return }
            
        if text.isEmpty {
            textField.text = "#"
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("취소됨", textField.tag)
    }
}
