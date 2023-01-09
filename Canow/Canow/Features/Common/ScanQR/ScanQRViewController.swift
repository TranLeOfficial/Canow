//
//  ScanQRViewController.swift
//  Canow
//
//  Created by hieplh2 on 10/02/21.
//

import UIKit
import AVFoundation

protocol ScanQRDelegate: AnyObject {
    func scanResult<T: Decodable>(model: T)
}

class ScanQRViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.rightButtonHidden = false
            self.headerView.rightButtonImage = UIImage(named: "ic_splash_enable")
            self.headerView.onBack = {
                switch self.transactionType {
                case .pay:
                    self.pop()
                default:
                    self.dismiss(animated: true)
                }
            }
            self.headerView.onPressRightButton = {
                self.toggleFlash()
            }
        }
    }
    @IBOutlet weak var squareImageView: UIImageView!
    @IBOutlet weak var scanEffectImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            self.descriptionLabel.text = StringConstants.qrMessageScan.localized
        }
    }
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var scanEffectTop: NSLayoutConstraint!
    
    // MARK: - Properties
    weak var delegate: ScanQRDelegate?
    var transactionType: TransactionType = .transfer
    var couponDetailInfo: CouponDetailInfo?
    
    lazy private var defaultDevice: AVCaptureDevice? = {
        if let device = AVCaptureDevice.default(for: .video) {
            return device
        }
        return nil
    }()
    
    lazy private var defaultCaptureInput: AVCaptureInput? = {
        if let captureDevice = self.defaultDevice {
            do {
                return try AVCaptureDeviceInput(device: captureDevice)
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }()
    
    lazy private var dataOutput = AVCaptureMetadataOutput()
    
    lazy private var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        return layer
    }()
    
    private var session = AVCaptureSession()
    private var stringQRData = String()
    private let viewModel =  ScanQRViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopScan()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.session.startRunning()
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        self.reloadData()
        self.fetchDataFailure()
    }
    
}

// MARK: - Methods
extension ScanQRViewController {
    
    private func setupUI() {
        self.configCameraView()
        self.configScanArea()
        self.view.bringSubviewToFront(self.squareImageView)
        self.view.bringSubviewToFront(self.scanEffectImageView)
        self.view.bringSubviewToFront(self.descriptionLabel)
        self.view.bringSubviewToFront(self.errorLabel)
        self.view.bringSubviewToFront(self.headerView)
        switch self.transactionType {
        case .pay:
            self.headerView.setTitle(title: StringConstants.qrScanPay.localized, color: .white)
        case .transfer:
            self.headerView.setTitle(title: StringConstants.qrScanReceiver.localized, color: .white)
        default:
            self.headerView.setTitle(title: StringConstants.qrScan.localized, color: .white)
        }
    }
    
    private func configScanArea() {
        let scanAreaHoleX = self.squareImageView.frame.minX + 10
        let scanAreaHoleY = self.squareImageView.frame.minY + 10
        let scanAreaHoleWidth = ScreenSize.screenWidth - 88
        let scanAreaHoleFrame = CGRect(x: scanAreaHoleX,
                                       y: scanAreaHoleY,
                                       width: scanAreaHoleWidth,
                                       height: scanAreaHoleWidth)
        let hole = [TARectangularSubtractionPath(frame: scanAreaHoleFrame)]
        let overlayView = TAOverlayView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: ScreenSize.screenWidth,
                                                      height: ScreenSize.screenHeight),
                                        subtractedPaths: hole)
        self.view.addSubview(overlayView)
    }
    
    private func configCameraView() {
        if self.session.isRunning {
            return
        }
        
        if let defaultDeviceInput = defaultCaptureInput {
            if !self.session.canAddInput(defaultDeviceInput) {
                return
            }
            self.session.addInput(defaultDeviceInput)
        }
        
        if !self.session.canAddOutput(self.dataOutput) {
            return
        }
        
        self.session.addOutput(self.dataOutput)
        self.dataOutput.metadataObjectTypes = [.qr]
        self.dataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        self.videoPreviewLayer.frame = self.view.layer.frame
        self.view.layer.addSublayer(self.videoPreviewLayer)
        
        self.session.startRunning()
        
        self.dataOutput.rectOfInterest = self.videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: self.squareImageView.frame)
    }
    
    private func stopScan() {
        if self.session.isRunning {
            self.session.stopRunning()
        }
    }
    
    private func didScanQR(qrString: String) {
        switch self.transactionType {
        case .transfer:
            self.errorLabel.text = StringConstants.qrErrorReceiver.localized
            self.errorLabel.isHidden = false
            if Int(qrString) != nil {
                if qrString.count == Constants.PHONE_COUNT {
                    self.errorLabel.isHidden = true
                    self.stopScan()
                    self.delegate?.scanResult(model: qrString)
                    self.dismiss(animated: true)
                }
            }
        case .useCoupon, .useCouponRedEnvelopeEvent, .useCouponAirdropEvent:
            self.decodeQR(qrString: qrString, type: QRCouponUse.self)
        case .pay:
            self.decodeQR(qrString: qrString, type: QRPayByST.self)
        default:
            break
        }
    }
    
    private func decodeQR<T: Decodable>(qrString: String, type: T.Type) {
        guard let model = qrString.decodeQRString(type: T.self) else {
            switch self.transactionType {
            case .pay:
                if qrString.contains(Constants.DEEP_LINK_URL) {
                    self.stopScan()
                    self.viewModel.getUniversalLinkData(deeplink: qrString)
                    return
                }
            default:
                break
            }
            self.errorLabel.text = {
                switch self.transactionType {
                case .pay:
                    return StringConstants.qrErrorMerchant.localized
                default:
                    return StringConstants.qrErrorReceiver.localized
                }
            }()
            self.errorLabel.isHidden = false
            return
        }
        switch self.transactionType {
        case .pay:
            self.setUpPay(qrString: qrString)
        case .useCoupon, .useCouponRedEnvelopeEvent, .useCouponAirdropEvent:
            self.setUpUseCoupon(qrString: qrString)
        default:
            self.errorLabel.isHidden = true
            self.stopScan()
            self.delegate?.scanResult(model: model)
            self.dismiss(animated: true)
        }
    }
    
    private func setUpPay(qrString: String) {
        guard let model = qrString.decodeQRString(type: QRPayByST.self) else { return }
        let partnerId = model.partnerId
        self.stopScan()
        self.viewModel.getPartnerInfomationSelected(partnerId: partnerId)
        self.viewModel.fetchDataSuccess = {
            if self.viewModel.partnerInfo?.status != .active || self.viewModel.partnerInfo?.type != .merchant {
                self.errorLabel.text = StringConstants.qrErrorMerchant.localized
                self.errorLabel.isHidden = false
                self.session.startRunning()
            } else {
                self.stopScan()
                if model.amount ?? 0 == 0 {
                    self.push(viewController: PayViewController(model: model))
                } else {
                    let inputAmount = InputAmountTransactionViewController(transactionType: .pay)
                    inputAmount.merchantInfo = model
                    inputAmount.payType = .payPremoney
                    self.push(viewController: inputAmount)
                }
            }
        }
        self.viewModel.fetchDataFailure = { error in
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
            self.errorLabel.text = StringConstants.qrErrorMerchant.localized
            self.errorLabel.isHidden = false
            self.session.startRunning()
        }
    }
    
    private func setUpUseCoupon(qrString: String) {
        guard let model = qrString.decodeQRString(type: QRCouponUse.self) else { return }
        self.stopScan()
        if model.partnerId != self.couponDetailInfo?.merchantId {
            self.errorLabel.text = StringConstants.qrErrorMerchant.localized
            self.errorLabel.isHidden = false
            self.session.startRunning()
        } else {
            self.stopScan()
            self.viewModel.getPartnerInfomationSelected(partnerId: model.partnerId)
            self.viewModel.fetchDataSuccess = {
                switch self.transactionType {
                case .useCoupon, .useCouponRedEnvelopeEvent, .useCouponAirdropEvent:
                    if self.viewModel.partnerInfo?.status != .active || self.viewModel.partnerInfo?.type != .merchant {
                        self.errorLabel.text = StringConstants.qrErrorMerchant.localized
                        self.errorLabel.isHidden = false
                        self.session.startRunning()
                    } else {
                        self.errorLabel.isHidden = true
                        self.delegate?.scanResult(model: model)
                        self.dismiss(animated: true)
                    }
                default:
                    break
                }
            }
        }
    }
    
    private func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                self.headerView.rightButtonImage = UIImage(named: "ic_splash_enable")
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                    self.headerView.rightButtonImage = UIImage(named: "ic_splash_disable")
                } catch {
                    print("Toggle flash error \(error.localizedDescription)")
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Toggle flash error \(error.localizedDescription)")
        }
    }
    
}

// MARK: - Actions
extension ScanQRViewController {
    private func reloadData() {
        self.viewModel.fetchUniversalLinkSuccess = {
            if let idEvent = self.viewModel.universalLinkData?.eventId {
                let rewardViewController = RewardViewController()
                rewardViewController.idEvent = idEvent
                self.push(viewController: rewardViewController)
                return
            }
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { _ in
            self.session.startRunning()
            self.errorLabel.isHidden = false
            self.errorLabel.text = StringConstants.qrErrorMerchant.localized
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScanQRViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            
            self.stringQRData = readableObject.stringValue ?? ""
            self.didScanQR(qrString: self.stringQRData)
        }
    }
    
}
