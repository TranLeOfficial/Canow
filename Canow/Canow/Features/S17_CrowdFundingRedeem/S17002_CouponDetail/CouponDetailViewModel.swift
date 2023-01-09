//
//  CouponDetailViewModel.swift
//  Canow
//
//  Created by hieplh2 on 06/12/2021.
//

import Foundation
import AVFoundation

class CouponDetailViewModel: NSObject {
    
    // MARK: - Properties
    var couponDetail: CouponDetailInfo?
    var courseDetailInfo: CourseDetailInfo?
    
    var fetchDataSuccess: (StableTokenCustomerInfo) -> Void = { _ in }
    var getCourseDetailSuccess: (CourseDetailInfo) -> Void = { _ in }
    var getECourseDetailSuccess: (CouponDetailInfo) -> Void = { _ in }
    var checkRedeemCourseSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
    var stableTokenCustomerFailure: (String) -> Void = { _ in }
    
    var fetchFantokenBalanceInfo: (FantokenBalanceInfo?) -> Void = { _ in }
    var fetchCustomerBalanceFailure: (String) -> Void = { _ in }
}

// MARK: - Methods
extension CouponDetailViewModel {
    
    func getCourseDetail(couponId: String) {
        NetworkManager.shared.getCourse(id: couponId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let courseDetail):
                if courseDetail.errorCode == .SUCCESSFUL {
                    self.courseDetailInfo = courseDetail.data
                    self.getCourseDetailSuccess(courseDetail.data)
                } else {
                    self.fetchDataFailure(courseDetail.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getStableTokenCustomer() {
        let phoneNumber = KeychainManager.phoneNumber() ?? ""
        NetworkManager.shared.getStableTokenCustomer(phoneNumber: phoneNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stableTokenCustomer):
                if stableTokenCustomer.errorCode == .SUCCESSFUL {
                    self.fetchDataSuccess(stableTokenCustomer.data)
                } else {
                    self.stableTokenCustomerFailure(stableTokenCustomer.errorCode.message)
                }
            case .failure(let error):
                self.stableTokenCustomerFailure(error.message)
            }
        }
    }
    
    func getECourseDetail(eCouponId: String) {
        NetworkManager.shared.getCouponDetail(eCouponId: eCouponId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let eCourseDetail):
                if eCourseDetail.errorCode == .SUCCESSFUL {
                    self.couponDetail = eCourseDetail.data
                    self.getECourseDetailSuccess(eCourseDetail.data)
                } else {
                    self.fetchDataFailure(eCourseDetail.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func checkRedeemCourse(couponId: String) {
        NetworkManager.shared.checkRedeemCourse(id: couponId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let errorRedeem):
                if errorRedeem.errorCode == .SUCCESSFUL {
                    self.checkRedeemCourseSuccess()
                } else {
                    self.fetchDataFailure(errorRedeem.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getCustomerBalance(tokenType: String) {
        let username = KeychainManager.phoneNumber() ?? ""
        NetworkManager.shared.getCustomerBalance(username: username,
                                          tokenType: tokenType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let customerBalance):
                if customerBalance.errorCode == .SUCCESSFUL {
                    self.fetchFantokenBalanceInfo(customerBalance.data.FantokenValue)
                } else {
                    self.fetchCustomerBalanceFailure(customerBalance.errorCode.message)
                }
            case .failure(let error):
                self.fetchCustomerBalanceFailure(error.message)
            }
        }
    }
}
