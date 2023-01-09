//
//  ProfileViewController.swift
//  Canow
//
//  Created by TuanBM6 on 10/31/21.
//

import UIKit
import AVFoundation

class ProfileViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s07EditProfile.localized)
            self.headerView.onBack = {
                self.pop()
            }
        }
    }
    @IBOutlet weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
            self.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewAvatar)))
        }
    }
    @IBOutlet weak var cameraView: UIView! {
        didSet {
            self.cameraView.rounded()
        }
    }
    @IBOutlet weak var maleButton: UIButton! {
        didSet {
            self.maleButton.titleLabel?.font = .font(with: .bold700, size: 14)
            self.maleButton.backgroundColor = .white
            self.maleButton.tintColor = .colorB8B8B8
            self.maleButton.configBorder(borderWidth: 1, borderColor: .colorE5E5E5, cornerRadius: 6)
            self.maleButton.titleLabel?.text = StringConstants.s01BtnMale.localized
        }
    }
    @IBOutlet weak var femaleButton: UIButton! {
        didSet {
            self.femaleButton.titleLabel?.font = .font(with: .bold700, size: 14)
            self.femaleButton.backgroundColor = .white
            self.femaleButton.tintColor = .colorB8B8B8
            self.femaleButton.configBorder(borderWidth: 1, borderColor: .colorE5E5E5, cornerRadius: 6)
            self.femaleButton.titleLabel?.text = StringConstants.s01BtnFemale.localized
        }
    }
    @IBOutlet weak var otherGenderButton: UIButton! {
        didSet {
            self.otherGenderButton.titleLabel?.font = .font(with: .bold700, size: 14)
            self.otherGenderButton.backgroundColor = .white
            self.otherGenderButton.tintColor = .colorB8B8B8
            self.otherGenderButton.configBorder(borderWidth: 1, borderColor: .colorE5E5E5, cornerRadius: 6)
            self.otherGenderButton.titleLabel?.text = StringConstants.s01BtnOther.localized
        }
    }
    @IBOutlet weak var nameTextField: FloatingLabelTextField! {
        didSet {
            self.nameTextField.backgroundColor = .clear
            self.nameTextField.cornerRadius = 8
            self.nameTextField.placeholder = StringConstants.s01FullnamePlaceholder.localized
            self.nameTextField.type = .normal
            self.nameTextField.delegate = self
            self.nameTextField.textCount = 255
        }
    }
    @IBOutlet weak var usernameTextField: FloatingLabelTextField! {
        didSet {
            self.usernameTextField.backgroundColor = .clear
            self.usernameTextField.cornerRadius = 8
            self.usernameTextField.placeholder = StringConstants.s01PhonePlaceholder.localized
            self.usernameTextField.type = .normal
            self.usernameTextField.isUserInteractionEnabled = false
        }
    }
    @IBOutlet private weak var genderLabel: UILabel! {
        didSet {
            self.genderLabel.font = .font(with: .medium500, size: 14)
            self.genderLabel.text = StringConstants.s01LbGender.localized
        }
    }
    @IBOutlet weak var dateView: DateView! {
        didSet {
            self.dateView.layer.cornerRadius = 8
            self.dateView.placeholder = StringConstants.s01DobPlaceholder.localized
        }
    }
    @IBOutlet weak var occupationView: ProfileItemView! {
        didSet {
            self.occupationView.layer.cornerRadius = 8
            self.occupationView.placeholder = StringConstants.s01OccupationPlaceholder.localized
        }
    }
    @IBOutlet weak var addressView: ProfileItemView! {
        didSet {
            self.addressView.layer.cornerRadius = 8
            self.addressView.placeholder = StringConstants.s01PlaceLivePlaceholder.localized
        }
    }
    @IBOutlet weak var saveButton: CustomButton! {
        didSet {
            self.saveButton.titleLabel?.font = .font(with: .bold700, size: 16)
            self.saveButton.setTitle(StringConstants.s07BtnSave.localized, for: .normal)
            self.saveButton.setTitle(StringConstants.s07BtnSave.localized, for: .highlighted)
            self.saveButton.disable()
        }
    }
    
    // MARK: - Properties
    private let viewModel = ProfileViewModel()
    var addressArray = [AddressInfo]()
    var occupationArray = [OccupationInfo]()
    
    var avatar: String?
    var genderValue: Gender?
    private var genderArrayButton = [UIButton]()
    private var addressSelectedIndex: Int?
    private var occupationSelectedIndex: Int?
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.fetchCustomerInfoSuccess()
        self.getAddressSuccess()
        self.getOccupationSuccess()
        self.fetchDataFailure()
        self.uploadImageSuccess()
        self.uploadProfileSuccess()
        self.uploadImageFailure()
        self.uploadProfileFailure()
    }
    
}

// MARK: - Methods
extension ProfileViewController {
    
    private func setupUI() {
        self.view.backgroundColor = .colorYellowFFCC00
        self.viewModel.fetchData()
        self.genderArrayButton = [self.maleButton, self.femaleButton, self.otherGenderButton]
        self.dateView.chooseDate = {
            let viewController = ChooseDateViewController(date: self.convertToDate())
            viewController.onSelectedDate = { date in
                self.dateView.updateChooseDate(date: date)
            }
            self.present(viewController, animated: true)
        }
        let tapSelectAddress = UITapGestureRecognizer(target: self, action: #selector(selectAddress))
        self.addressView.addGestureRecognizer(tapSelectAddress)
        
        let tapSelectOccupation = UITapGestureRecognizer(target: self, action: #selector(selectOccupation))
        self.occupationView.addGestureRecognizer(tapSelectOccupation)
        
        let viewAvatar = UITapGestureRecognizer(target: self, action: #selector(viewAvatar(_ :)))
        self.avatarImageView.addGestureRecognizer(viewAvatar)
        
    }
    
    private func fetchCustomerInfoSuccess() {
        self.viewModel.fetchCustomerInfoSuccess = {
            if let customerInfo = self.viewModel.customerInfo {
                self.nameTextField.text = customerInfo.fullname
                self.usernameTextField.text = customerInfo.userName
                self.occupationView.text = customerInfo.occupation?.lowercased().localized
                
                var genderRawValue: Int {
                    switch self.viewModel.customerInfo?.gender {
                    case Gender.male.value:
                        return 0
                    case Gender.female.value:
                        return 1
                    default:
                        return 2
                    }
                }
                
                let gender = Gender(rawValue: genderRawValue)
                if gender?.valueLocalize == StringConstants.s01BtnMale.localized {
                    self.maleButton.tintColor = .colorBlack111111
                    self.maleButton.backgroundColor = self.themeInfo.selectedColor
                    self.maleButton.layer.borderColor = self.themeInfo.secondaryColor.cgColor
                } else if gender?.valueLocalize == StringConstants.s01BtnFemale.localized {
                    self.femaleButton.tintColor = .colorBlack111111
                    self.femaleButton.backgroundColor = self.themeInfo.selectedColor
                    self.femaleButton.layer.borderColor = self.themeInfo.secondaryColor.cgColor
                } else {
                    self.otherGenderButton.tintColor = .colorBlack111111
                    self.otherGenderButton.backgroundColor = self.themeInfo.selectedColor
                    self.otherGenderButton.layer.borderColor = self.themeInfo.secondaryColor.cgColor
                }
                self.addressView.text = customerInfo.address?.localized
                
                if let dateOfbirth = self.viewModel.customerInfo?.birthday?.toDate(dateFormat: DateFormat.DATE_CURRENT) {
                    self.dateView.updateChooseDate(date: dateOfbirth)
                }
                
                if customerInfo.avatar == "" {
                    self.avatarImageView.image = UIImage(named: "ic_avatar")
                } else {
                    let avatar = customerInfo.avatar ?? ""
                    if let url = URL(string: NetworkManager.shared.baseURLImage + avatar) {
                        self.avatarImageView.kf.setImage(with: url, placeholder: UIImage(named: "ic_avatar"))
                    }
                }
                
                if !customerInfo.fullname.isEmpty {
                    self.saveButton.enable()
                }
            }
        }
    }
    
    private func getAddressSuccess() {
        self.viewModel.getAddressSuccess = {
            self.addressArray = self.viewModel.addressList
        }
    }
    
    private func getOccupationSuccess() {
        self.viewModel.getOccupationSuccess = {
            self.occupationArray = self.viewModel.occupationList
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
        }
    }
    
    private func uploadImageSuccess() {
        self.viewModel.updateAvatarSuccess = { data in
            guard let customer = self.viewModel.customerInfo else {
                CommonManager.hideLoading()
                return
            }
            let getDate = self.dateView.getDate()
            let occupation = self.occupationArray.filter({ $0.name == customer.occupation }).first?.id ?? 0
            let address = self.addressArray.filter({ $0.name == customer.address }).first?.id ?? 0
             self.viewModel.saveUpdateProfile(name: self.nameTextField.text ?? customer.fullname,
                                              gender: self.genderValue?.value ?? customer.gender,
                                              birthday: "\(getDate)",
                                              occupationId: self.occupationSelectedIndex ?? occupation,
                                              addressId: self.addressSelectedIndex ?? address,
                                              avatar: data)
            CommonManager.showToast(icon: UIImage(named: "ic_toast_success"),
                                    message: StringConstants.s07MessageUpdateAvatarSuccess.localized,
                                    bgColor: UIColor(hexString: "#339A06"))
        }
    }
    
    private func uploadProfileSuccess() {
        self.viewModel.updateProfileSuccess = {
            CommonManager.hideLoading()
            self.avatar = nil
            self.view.endEditing(false)
            
            CommonManager.showToast(icon: UIImage(named: "ic_toast_success"),
                                    message: StringConstants.s07MessageUpdateProfileSuccess.localized,
                                    bgColor: UIColor(hexString: "#339A06"))
        }
    }
    
    private func uploadImageFailure() {
        self.viewModel.updateAvatarFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
        }
    }
    
    private func uploadProfileFailure() {
        self.viewModel.updateProfileFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
        }
    }
    
    private func convertToDate() -> Date {
        let getDate = self.dateView.getDate()
        return getDate.toDate(dateFormat: DateFormat.DATE_PROFILE) ?? Date()
    }
    
    private func openLibrary() {
        self.openPhotoLibrary { assets in
            let viewController = UseYourPhotoViewController()
            viewController.assets = assets
            viewController.onSelectPhoto = { image, fileName in
                self.avatarImageView.image = image
                self.avatar = fileName
                if let imageProfile = self.avatar, let avatarImageView = self.avatarImageView.image {
                    self.viewModel.uploadProfileAvatar(image: avatarImageView, fileName: imageProfile)
                }
            }
            viewController.hidesBottomBarWhenPushed = true
            self.push(viewController: viewController)
        }
    }
    
    private func showPreviewPhoto(image: UIImage, fileName: String) {
        let previewPhotoVC = PreviewPhotoViewController(image: image, fileName: fileName)
        previewPhotoVC.delegate = self
        previewPhotoVC.mode = .camera
        previewPhotoVC.onCancel = {
            self.openCamera()
        }
        self.present(viewController: previewPhotoVC)
    }
    
}

// MARK: - Actions
extension ProfileViewController {
    
    @IBAction func chooseImageAction(_ sender: UIButton) {
        self.nameTextField.customTextField.resignFirstResponder()
        
        self.showActionSheet(actions: (StringConstants.s01UseYourPhoto.localized, { self.openLibrary() }),
                             (StringConstants.s01TakePhoto.localized, { self.openCamera() }))
    }
    
    @IBAction func chooseGenderActionButton(_ sender: UIButton) {
        self.nameTextField.customTextField.resignFirstResponder()
        self.genderArrayButton.forEach({
            if $0 == sender {
                $0.tintColor = .colorBlack111111
                $0.backgroundColor = self.themeInfo.selectedColor
                $0.layer.borderColor = self.themeInfo.secondaryColor.cgColor
            } else {
                $0.tintColor = .colorB8B8B8
                $0.backgroundColor = .white
                $0.layer.borderColor = UIColor.colorE5E5E5.cgColor
            }
        })
        self.genderValue = Gender(rawValue: sender.tag)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        self.nameTextField.customTextField.resignFirstResponder()
        
        guard let customer = self.viewModel.customerInfo else {
            return
        }
        let getDate = self.dateView.getDate()
        let occupation = self.occupationArray.filter({ $0.name == customer.occupation }).first?.id ?? 0
        let address = self.addressArray.filter({ $0.name == customer.address }).first?.id ?? 0
        let avatar = self.viewModel.customerInfo?.avatar ?? ""
        self.viewModel.saveUpdateProfile(name: self.nameTextField.text ?? customer.fullname,
                                         gender: self.genderValue?.value ?? customer.gender,
                                         birthday: "\(getDate)",
                                         occupationId: self.occupationSelectedIndex ?? occupation,
                                         addressId: self.addressSelectedIndex ?? address,
                                         avatar: avatar)
    }
    
    // Objc
    @objc func selectAddress(_ sender: UITapGestureRecognizer) {
        let addressList = self.viewModel.addressList
        let viewController = ProfileItemViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        viewController.dataList = addressList.map { $0.name.localized }
        viewController.titleText = StringConstants.s01TitlePlaceLive.localized
        viewController.itemSeletectIndex = addressList.firstIndex { $0.name.localized == self.addressView.dropDownTextField.text }
        viewController.onSelectedItem = { index in
            self.addressView.text = addressList[index].name.localized
            self.addressSelectedIndex = addressList[index].id
        }
        self.present(viewController, animated: true)
    }
    
    @objc func selectOccupation(_ sender: UITapGestureRecognizer) {
        let occupationList = self.viewModel.occupationList
        let viewController = ProfileItemViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        viewController.dataList = occupationList.map { $0.name.lowercased().localized }
        viewController.titleText = StringConstants.s01TitleOccupation.localized
        viewController.itemSeletectIndex = occupationList.firstIndex { $0.name.lowercased().localized == self.occupationView.dropDownTextField.text }
        viewController.onSelectedItem = { index in
            self.occupationView.text = occupationList[index].name.lowercased().localized
            self.occupationSelectedIndex = occupationList[index].id
        }
        self.present(viewController, animated: true)
    }
    
    @objc func viewAvatar(_ sender: UITapGestureRecognizer) {
        if self.avatarImageView.image != UIImage(named: "ic_avatar") {
            self.present(viewController: ViewPhotoViewController(image: self.avatarImageView.image))
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            self.dismiss(animated: true)
            return
        }
        
        self.avatarImageView.image = image
        self.avatar = CommonManager.getImageName()
        if let imageProfile = self.avatar, let avatarImageView = self.avatarImageView.image {
            self.viewModel.uploadProfileAvatar(image: avatarImageView, fileName: imageProfile)
        }
        self.dismiss(animated: false)
        self.showPreviewPhoto(image: image, fileName: self.avatar ?? "")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
}

// MARK: - TextField delegate
extension ProfileViewController: FloatingTextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = (textField.text! as NSString)
        
        if text != "" && Int(text as String) != 0 {
            self.saveButton.enable()
        } else {
            self.saveButton.disable()
        }
    }
    
}

// MARK: - PreviewPhotoDelegate
extension ProfileViewController: PreviewPhotoDelegate {
    
    func onSave(image: UIImage, fileName: String) {
        self.viewModel.uploadProfileAvatar(image: image, fileName: fileName)
    }
    
}
