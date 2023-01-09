//
//  Endpoint.swift
//  Canow
//
//  Created by PhuNT14 on 06/10/2021.
//

import Foundation

// MARK: - Authentication
public struct Endpoint {
    static let signin = "/authentication/signin",
               customerSetPassword = "/authentication/customer/set-password",
               userChangePassword = "/authentication/user/change-password",
               customerForgetPassword = "/authentication/customer/forget-password",
               userForgetPassword = "/authentication/customer/set-password",
               customerConfirmForgotPassword = "/authentication/customer/confirm-forgot-password",
               userChangePasswordWithoutAccessToken = "/authentication/user/change-password-without-access-token",
               userResetPassword = "/authentication/user/reset-password",
               signinHealthcheck = "/authentication/signin-healthcheck",
               refreshToken = "/authentication/refresh-token"
}

// MARK: - news
extension Endpoint {
    static let newList = "/news/list"
    static let newDetail = "/news/"
}

// MARK: - themes
extension Endpoint {
    static let getTheme = "/theme/"
}

// MARK: - partner
extension Endpoint {
    static let partnerList = "/partner/list-partner-with-fantoken-wallet-without-login"
    static let partnerListWallet = "/partner/list-partner-with-fantoken-wallet"
    static let teamList = "/partner/list/get-by-type/Team"
    static let partner = "/partner/"
    static let teamInfo = "/partner/"
    static let partnerSport = "/partner/get-by-sport-id"
}

// MARK: - Occupation
extension Endpoint {
    static let occupation = "/occupation"
}

// MARK: - Sport
extension Endpoint {
    static let sport = "/sport"
}

// MARK: - Customer
extension Endpoint {
    static let customer = "/account/customer"
    static let customerInfo = "/account/customer/"
    static let editProfile = "/account/customer/update/info"
    static let customerVerifyOTP = "/account/customer/verify-otp"
    static let customerResendOTP = "/account/customer/resend-otp/"
    static let updateProfile = "/account/customer/update-profile"
    static let updateAvatar = "/account/customer/update/avatar"
    static let myQRCode = "/account/customer/generate-qr-code"
    static let checkExist = "/account/customer/check-exist"
    static let saveProfileWhenSignUp = "/account/customer/signup/update-profile"
    static let checkNotExist = "/account/customer/check-not-exist"
    static let updateSportAndTeam = "/account/customer/update/sport-and-team"
    static let updateLanguage = "/account/customer/update/language"
}

// MARK: - Address
extension Endpoint {
    static let address = "/address"
}

// MARK: - Common
extension Endpoint {
    static let common = "/common/"
    static let universalLink = "/common/deeplink/"
}

// MARK: - Coupon
extension Endpoint {
    static let listCouponAvailable = "/coupon/list-coupon-available/"
    static let listCouponPurchased = "/coupon/list-coupon-purchased"
    static let couponDetail = "/coupon/ecoupon-detail/"
    static let couponUse = "/coupon/use"
    static let couponRedeem = "/coupon/redeem"
    static let listCouponMerchant = "/coupon/list-redeemed-by-merchant-id/"
    static let deleteCouponUse = "/coupon/remove-coupon-purchased/"
    static let checkUseCoupon = "/coupon/check-when-use"
    static let checkRedeemCoupon = "/coupon/check-when-redeem"
    static let eCouponDetail = "/coupon/ecoupon-detail/"
}

// MARK: - Campaign
extension Endpoint {
    static let crowdFunding = "/campaign/crowdfunding/list-available/"
    static let remittance = "/campaign/remittance/list-available/"
    static let crowdFundingDetail = "/campaign/crowdfunding/get-by-id/"
    static let courseListById = "/course/list/"
    static let crowdFundingInprogress = "/campaign/crowdfunding/list-available/ios/"
}

// MARK: - Course
extension Endpoint {
    static let courseMobile = "/course/mobile/"
    static let redeemCourse = "/course/redeem"
    static let remittanceCampaign = "/campaign/remittance/get-by-id/"
    static let campaignItem = "/campaign-item"
    static let donateNow = "/campaign/remittance/transfer-item"
    static let checkRedeemCourse = "/course/check-when-redeem"
    static let useCourse = "/course/check-when-use"
    static let checkWhenDonate = "/campaign/remittance/check-when-transfer-item"
}

// MARK: - Fantoken
extension Endpoint {
    static let customerBalance = "/fantoken/customer-balance"
    static let transferFT = "/fantoken/transfer"
}

// MARK: - Transaction
extension Endpoint {
    static let history = "/transaction/mobile"
    static let historyDetail = "/transaction/mobile/"
    static let transactionInfo = "/transaction/transaction-info/"
}

// MARK: - Stable token
extension Endpoint {
    static let stableToken = "/stable-token"
    static let topupGiftCard = "/stable-token/top-up"
    static let transactionStatus = "/stable-token/transaction-status/"
    static let exchange = "/stable-token/exchange"
    static let stableCustomer = "/stable-token/customer/"
    static let stableTokenMobile = "/stable-token/get-stable-token-mobile"
    static let transferStableToken = "/stable-token/transfer"
    static let topupCard = "/stable-token/topup-by-card"
    static let confirmByCard = "/stable-token/confirm-topup-by-card"
    static let payByST = "/stable-token/pay-by-stable-token"
    static let receiverList = "/stable-token/transfer/receiver-list"
}

// MARK: - Gift Card
extension Endpoint {
    static let giftCard = "/gift-card/"
}

// MARK: - Topup
extension Endpoint {
    static let topupByCard = "/top-up/by-card"
}

// MARK: - Upload file
extension Endpoint {
    static let uploadFile = "/upload-file/upload-single-image"
}

// MARK: - Red Envelope
extension Endpoint {
    static let scanQREnvalope = "/red-envelope-event/customer-scan"
    static let useCouponRedEnvelope = "/coupon/red-envelope/use"
}

// MARK: - Airdrop
extension Endpoint {
    static let useCouponAirdrop = "/coupon/airdrop/use"
}
