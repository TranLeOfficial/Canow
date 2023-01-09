//
//  HistoryInfo.swift
//  Canow
//
//  Created by TuanBM6 on 11/5/21.
//

import Foundation
import KeychainAccess

struct HistoryInfo: Decodable {
    let transactionId: String?
    let transactionType: TransactionType?
    let createdAt: String?
    let amount: String?
    let tokenType: String?
    let tokenLogo: String?
    let status: TransactionStatus?
    let merchantName: String?
    let transferFrom: String?
    let transferTo: String?
}

enum TransactionType: String, Decodable {
    case exchange  = "EXCHANGE"
    case remittance = "REMITTANCE"
    case redeemCoupon = "REDEEM_COUPON"
    case topUp = "TOP_UP"
    case transfer = "TRANSFER"
    case pay = "PAY"
    case useCoupon = "USE_COUPON"
    case useCouponWithoutPayment = "USE_COUPON_WITHOUT_PAYMENT"
    case redeemCourse = "REDEEM_COURSE"
    case useCourse = "USE_COURSE"
    case transferSTfromOperatorToCustomer = "TRANSFER_STABLE_TOKEN_FROM_OPERATOR_TO_CUSTOMER"
    case transferSTfromCustomerToOperator = "TRANSFER_STABLE_TOKEN_FROM_CUSTOMER_TO_OPERATOR"
    case useCouponRedEnvelopeEvent = "USE_COUPON_RED_ENVELOPE_EVENT"
    case transferSTRedEnvelopeEvent = "TRANSFER_ST_RED_ENVELOPE_EVENT"
    case useCouponAirdropEvent = "USE_COUPON_AIRDROP_EVENT"
    case transferSTAirdropEvent = "TRANSFER_ST_AIRDROP_EVENT"
    
    var message: String {
        switch self {
        case .exchange:
            return StringConstants.s07ExchangeType.localized
        case .remittance:
            return StringConstants.s07Remittance.localized
        case .redeemCoupon:
            return StringConstants.s07RedeemCoupon.localized
        case .topUp:
            return StringConstants.s07TopUpType.localized
        case .transfer:
            return StringConstants.s07TransferType.localized
        case .pay:
            return StringConstants.s07Pay.localized
        case .useCoupon:
            return StringConstants.s07UseCoupon.localized
        case .useCouponWithoutPayment:
            return StringConstants.s07UseCouponWithoutPayment.localized
        case .redeemCourse:
            return StringConstants.s07RedeemCoupon.localized
        case .useCourse:
            return StringConstants.s07UseCoupon.localized
        case .transferSTfromOperatorToCustomer:
            return StringConstants.s07TransferStFromOperatorToCustomer.localized
        case .transferSTfromCustomerToOperator:
            return StringConstants.s07TransferStFromCustomerToOperator.localized
        case .useCouponRedEnvelopeEvent:
            return StringConstants.useCouponRedEnvelop.localized
        case .transferSTRedEnvelopeEvent:
            return StringConstants.transferRedEnvelop.localized
        case .useCouponAirdropEvent:
            return StringConstants.useCouponAirdrop.localized
        case .transferSTAirdropEvent:
            return StringConstants.transferAirdrop.localized
        }
    }
}
