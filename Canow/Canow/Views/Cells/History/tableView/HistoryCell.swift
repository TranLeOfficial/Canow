//
//  HistoryCell.swift
//  Canow
//
//  Created by TuanBM6 on 11/5/21.
//

import UIKit
import Kingfisher
import RealmSwift

class HistoryCell: BaseTableViewCell {
    
    @IBOutlet private weak var transactionLogoImageView: UIImageView! {
        didSet {
            self.transactionLogoImageView.layer.cornerRadius = self.transactionLogoImageView.frame.width / 2
        }
    }
    @IBOutlet private weak var amountLabel: UILabel! {
        didSet {
            self.amountLabel.font = .font(with: .bold700, size: 18)
        }
    }
    @IBOutlet private weak var transactionTimeLabel: UILabel! {
        didSet {
            self.transactionTimeLabel.font = .font(with: .medium500, size: 12)
            self.transactionTimeLabel.textColor = .colorB8B8B8
        }
    }
    @IBOutlet private weak var transactionNameLabel: UILabel! {
        didSet {
            self.transactionNameLabel.font = .font(with: .medium500, size: 12)
            self.transactionNameLabel.textColor = .colorB8B8B8
        }
    }
    @IBOutlet private weak var transactionStatusLabel: UILabel! {
        didSet {
            self.transactionStatusLabel.font = .font(with: .bold700, size: 12)
        }
    }
    @IBOutlet private weak var subTransactionNameLabel: UILabel! {
        didSet {
            self.subTransactionNameLabel.font = .font(with: .medium500, size: 12)
            self.subTransactionNameLabel.textColor = .colorB8B8B8
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func configure<T>(data: T) {
        guard let historyInfo = data as? HistoryInfo else {
            return
        }
        self.transactionNameLabel.text = ""
        self.subTransactionNameLabel.text = ""
        self.transactionLogoImageView.kf.setImage(with: CommonManager.getImageURL(historyInfo.tokenLogo))
        self.transactionTimeLabel.text = historyInfo.createdAt?.toDate(dateFormat: DateFormat.DATE_CURRENT)?.toString(dateFormat: DateFormat.DATE_FORMAT_DEFAULT) ?? ""
        self.transactionNameLabel.text = historyInfo.transactionType?.message
        let firstCharacter = historyInfo.amount?.first
        if historyInfo.amount ?? "" == "0" {
            self.amountLabel.textColor = .colorRedEB2727
            self.amountLabel.text = "-0"
        } else {
            self.amountLabel.textColor = firstCharacter == "-" ? .colorRedEB2727 : .colorGreen339A06
            let amount = String(historyInfo.amount?.dropFirst() ?? "").formatPrice()
            self.amountLabel.text = "\(firstCharacter?.description ?? "")\(amount)"
        }
        switch historyInfo.status {
        case .completed:
            self.transactionStatusLabel.text = StringConstants.s07LbSuccess.localized
            self.transactionStatusLabel.textColor = .colorGreen339A06
        case .pending:
            self.transactionStatusLabel.text = StringConstants.s07LbProcessing.localized
            self.transactionStatusLabel.textColor = .color646464
        case .failed:
            self.transactionStatusLabel.text = StringConstants.s04TransactionFail.localized
            self.transactionStatusLabel.textColor = .colorRedEB2727
        default:
            break
        }
        self.setupTransactionType(historyInfo: historyInfo)
    }
    
}

extension HistoryCell {
    private func setupTransactionType(historyInfo: HistoryInfo) {
        let transactionType = historyInfo.transactionType?.message ?? ""
        switch historyInfo.transactionType {
        case .redeemCourse, .redeemCoupon, .remittance:
            self.transactionNameLabel.text = transactionType
        case .transfer:
            if historyInfo.transferTo == "" {
                if CommonManager.checkLanguageJP {
                    self.handleTextDisplay(mainString: "\(historyInfo.transferFrom ?? "")", subString: StringConstants.s07TransferStFromOperatorToCustomer.localized)
                } else {
                self.transactionNameLabel.text = StringConstants.s07TransferStFromOperatorToCustomer.localized + " \(historyInfo.transferFrom ?? "")"
                }
            } else {
                if CommonManager.checkLanguageJP {
                    self.handleTextDisplay(mainString: "\(historyInfo.transferTo ?? "")", subString: transactionType)
                } else {
                    self.transactionNameLabel.text = "\(transactionType) \(historyInfo.transferTo ?? "")"
                }
            }
        case .transferSTfromCustomerToOperator, .transferSTfromOperatorToCustomer:
            self.transactionNameLabel.text = StringConstants.s07TransferStFromCustomerToOperator.localized
        case .useCoupon, .pay, .useCouponWithoutPayment, .useCouponRedEnvelopeEvent:
            if CommonManager.checkLanguageJP {
                self.handleTextDisplay(mainString: "\(historyInfo.merchantName ?? "")", subString: transactionType)
            } else {
                self.transactionNameLabel.text = "\(transactionType) \(historyInfo.merchantName ?? "")"
            }
        case .topUp:
            self.transactionNameLabel.text = "\(StringConstants.s07LbTopup.localized) \(historyInfo.tokenType ?? "")"
        case .useCouponAirdropEvent:
            if CommonManager.checkLanguageJP {
                self.handleTextDisplay(mainString: "\(historyInfo.merchantName ?? "")", subString: StringConstants.s07Pay.localized)
            } else {
                self.transactionNameLabel.text = "\(StringConstants.s07Pay.localized) \(historyInfo.merchantName ?? "")"
            }
        case .transferSTAirdropEvent:
            self.transactionNameLabel.text = "\(StringConstants.transferAirdrop.localized)"
        case .transferSTRedEnvelopeEvent:
            self.transactionNameLabel.text = StringConstants.s07LbTransferSTRedEnvelope.localized
        default:
            if CommonManager.checkLanguageJP {
                self.handleTextDisplay(mainString: "\(historyInfo.tokenType ?? "") ", subString: transactionType)
            } else {
                self.transactionNameLabel.text = "\(transactionType) \(historyInfo.tokenType ?? "")"
            }
        }
    }
}

extension HistoryCell {
    private func handleTextDisplay(mainString: String, subString: String) {
        self.transactionNameLabel.text = mainString + subString
        if self.transactionNameLabel.calculateMaxLines(.font(with: .medium500, size: 12)) > 1 {
            self.transactionNameLabel.text = mainString
            self.subTransactionNameLabel.text = subString
            self.subTransactionNameLabel.isHidden = false
        }
    }
}
