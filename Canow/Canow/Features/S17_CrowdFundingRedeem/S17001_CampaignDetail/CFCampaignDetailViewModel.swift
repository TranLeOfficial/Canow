//
//  CFCampaignDetailViewModel.swift
//  Canow
//
//  Created by hieplh2 on 02/12/2021.
//

import Foundation

class CFCampaignDetailViewModel: NSObject {
    
    // MARK: Properties
    var crowdFundingDetail: CrowdFundingDetailInfo?
    var courseList : [CourseListDetail]?
    
    var getCrowdFundingDetailSuccess: (CrowdFundingDetailInfo) -> Void = { _ in }
    var getCourseDetailSuccess: (CourseDetailInfo) -> Void = { _ in }
    var getCourseListSuccess: () -> Void = {  }
    var checkRedeemCourseSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
    
}

// MARK: - Methods
extension CFCampaignDetailViewModel {
    
    func getCrowdFundingDetail(id: Int) {
        NetworkManager.shared.getCrowdFundingDetail(id: id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let cfDetail):
                if cfDetail.errorCode == .SUCCESSFUL {
                    self.crowdFundingDetail = cfDetail.data
                    self.getCrowdFundingDetailSuccess(cfDetail.data)
                } else {
                    self.fetchDataFailure(cfDetail.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getCourseDetail(couponId: String) {
        NetworkManager.shared.getCourse(id: couponId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let courseDetail):
                if courseDetail.errorCode == .SUCCESSFUL {
                    self.getCourseDetailSuccess(courseDetail.data)
                } else {
                    self.fetchDataFailure(courseDetail.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getCourseList(id: Int) {
        NetworkManager.shared.getCourseListById(id: id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let courseList):
                if courseList.errorCode == .SUCCESSFUL {
                    self.courseList = courseList.data
                    self.getCourseListSuccess()
                } else {
                    self.fetchDataFailure(courseList.errorCode.message)
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
    
}
