//
//  ReportViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/17/24.
//

import Foundation

import Moya

final class ReportViewModel {
    private let reportAPIService: ReportAPIServiceProtocol

    var reportedNumberGuideText: String = "" {
        didSet {
            updateReportedNumber?()
        }
    }
    var updateReportedNumber: (() -> Void)?
    
    init(reportAPIService: ReportAPIServiceProtocol = ReportAPIService()) {
        self.reportAPIService = reportAPIService
    }

    func getReportedNumber() {
        NetworkService.shared.reportService.getReportedNumber { [weak self] result in
            switch result {
            case .success(let response):
                guard let count = response?.data.count else { return }
                self?.reportedNumberGuideText = "\(count)번째 제보예요"
            case .badRequest, .unAuthorized:
                // TODO: - 에러 상황에 공통적으로 띄워줄만한 Alert나 Toast가 있어야 하지 않을까?
                print("badRequest")
            case .serverError:
                print("serverError")
            default:
                return
            }
        }
    }
}
