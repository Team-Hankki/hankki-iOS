//
//  CreateZipTextFieldType.swift
//  Hankkijogbo
//
//  Created by 심서현 on 12/6/24.
//

import UIKit

extension CreateZipTextField {
    enum CreateZipTextFieldType {
        case title
        case tag

        var titleText: String {
            switch self {
            case .title:
                StringLiterals.CreateZip.TitleInput.label
            case . tag:
                StringLiterals.CreateZip.TagInput.label
            }
        }
        
        var placeholderText: String {
            switch self {
            case .title:
                StringLiterals.CreateZip.TitleInput.placeholder
            case . tag:
                StringLiterals.CreateZip.TagInput.placeholder
            }
        }
        
        var maxLength: Int {
            switch self {
            case .title:
                CreateZipLiterals.titleMaxCount
            case .tag:
                CreateZipLiterals.tagMaxCount * 2 + 1
            }
        }
        
        var regex: String {
            switch self {
            case .title:
                CreateZipLiterals.titleRegex
            case .tag:
                CreateZipLiterals.tagRegex
            }
        }
        
        func textFieldDidBeginEditing(for instance: CreateZipTextField) -> (UITextField) -> Void {
            switch self {
            case .tag:
                return { textField in instance.tagTextFieldDidBeginEditing(textField) }
            default:
                return { _ in }
            }
        }
        
        func textFieldDidEndEditing(for instance: CreateZipTextField) -> (UITextField) -> Void {
            switch self {
            case .tag:
                return { textField in instance.tagTextFieldDidEndEditing(textField) }
            default:
                return { _ in }
            }
        }
        
        func replaceTextField(for instance: CreateZipTextField) -> (UITextField, String, String) -> Bool {
            switch self {
            case .tag:
                return { textField, string, currentText in
                    instance.replaceTagTextField(textField, string: string, currentText: currentText)
                }
            default: return { _, _, _ in true }
            }
        }
    }
}

private extension CreateZipTextField {
    
    func tagTextFieldDidBeginEditing(_ textField: UITextField) {
        let currentText = textField.text ?? ""
        if currentText.isEmpty { textField.text = "#" }
    }
    
    func tagTextFieldDidEndEditing(_ textField: UITextField) {
        let currentText = textField.text ?? ""
        
        // 현재 textField에 아무것도 입력하지 않고, 입력을 종료한 경우
        // #
        // textField를 초기화 한다.
        if currentText.count <= 1 {
            textField.text = ""
            return
        }
        
        // 첫번째 태그를 tagMaxCount를 초과해서 입력하는 경우
        if !currentText.contains(" ") {
            textField.text = String(currentText.prefix(CreateZipLiterals.tagMaxCount))
            return
        }
        
        // 현재 textField에 첫번째 태그가 입력되어있는 경우
        let firstTag = getFirstTag(textField.text ?? "")
        
        if currentText.contains(" ") {
            if currentText.hasSuffix("#") {
                textField.text = firstTag
                return
            }
            
            textField.text = String(currentText.prefix(firstTag.count + 1 + CreateZipLiterals.tagMaxCount))
        }
    }
    
    func replaceTagTextField(_ textField: UITextField, string: String, currentText: String) -> Bool {
        let updatedText: String = currentText + string
        
        // 현재 입력된 TextField의 마지막글자를 반환합니다.
        var lastChar = ""
        if let text = currentText.last {
            lastChar = String(text)
        }
        
        // 현재 입력된 TextField의 마지막 글자가 #인 경우
        if lastChar == "#" {
            // 텍스트 필드의 상태 : #태그1 #
            // 첫번째 태그가 입력이 완료 되었고, 두번째 태그를 작성해야하는데 백스페이스를 입력한 경우
            // 두번째 태그의 입력이 취소 되고, 첫번째 태그를 수정할 수 있게 해야한다.
            // -> 글자를 지우면 미리 입력된 #과, 태그를 분리하는 띄워쓰기를 동시에 지운다.
            if string.isEmpty && currentText.count > 1 {
                textField.text = String(currentText.prefix(currentText.count - 2))
                return false
            }
            // 텍스트 필드의 상태 : #
            // 첫번째 태그가 입력되지 않은 상태에서, 띄어쓰기로 두번재 태그를 작성하려는 경우
            // 두번째 태그 작성이 안되게 막아야한다. (첫번째 태그값이 공백이 되면 안됨)
            // -> 첫번째 태그가 입력되지 않으면 스페이스 키 입력을 막아 2번째 텍스트가 작성되지 않도록한다.
            else if currentText.count == 1 && string == " " {
                return false
            }
        }
        
        // 텍스트 필드의 상태 : #
        // 현재 입력 : 백스페이스 (지우기)
        // 첫번째 태그를 작성하지 않고, 백페이스를 입력해 작성되어있던 #도 지우려는 경우
        // -> 지우기가 되지 않아야한다.
        if currentText.count == 1 && string.isEmpty {
            return false
        }
        
        // 첫번째 태그가 최대 글자수를 넘지 않게 막는다.
        if !currentText.contains(" ") && updatedText.count > CreateZipLiterals.tagMaxCount + 1 {
            textField.text = String(updatedText.prefix(CreateZipLiterals.tagMaxCount))
            return false
        }

        // 현재 입력 : 스페이스
        
        if string == " " {
            // 텍스트 필드의 상태 : #태그1 #태그2작성중
            // 첫번째 태그를 입력하고, 두번째 태그를 입력하고 있는 중, 한번 더 스페이스를 눌러 3번째 태그를 추가하려는 경우
            // -> 스페이스가 입력되지 않게 막아야한다.
            if currentText.contains(" ") {
                return false
            }
            // 텍스트 필드의 상태 : #태그1
            // 첫번째 태그를 입력을 마무리하고, 두번째 태그를 작성하려고하는 경우
            // -> 첫번째 태그를 완성하고, 두번째 태그 작성을 위해 #을 자동으로 입력한다.
            else {
                textField.text = "\(currentText) #"
                return false
            }
        }
        
        let firstTag = getFirstTag(textField.text ?? "")
        
        // 두번째 태그가 최대 글자수를 넘지 않게 막는다.
        if updatedText.count > firstTag.count + 1 + CreateZipLiterals.tagMaxCount + 1 {
            textField.text = String(updatedText.prefix(firstTag.count + 1 + CreateZipLiterals.tagMaxCount))
            return false
        }
        
        return true
    }
}

private extension CreateZipTextField {
    // 첫번째 입력된 태그를 반환합니다
    // 띄어쓰기 기준
    func getFirstTag(_ string: String) -> String {
        let arr = string.split(separator: " ").map { String($0) }
        return arr[0]
    }
}
