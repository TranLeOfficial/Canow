//
//  UpdateProfileViewController.swift
//  Canow
//
//  Created by PhuNT14 on 20/10/2021.
//
//  Screen ID: S01005

import UIKit
import Localize

enum UpdateProfileType: CaseIterable {
    case occupation, placeToLive, favoriteSport
}

class UpdateProfileViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet private weak var genderLabel: UILabel! {
        didSet {
            self.genderLabel.font = .font(with: .medium500, size: 14)
            self.genderLabel.text = StringConstants.s01LbGender.localized
            self.genderLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s01TitleUpdateInfomation.localized, color: .colorBlack111111)
            self.headerView.bgColor = .colorYellowFFCC00
            self.headerView.backButtonHidden = true
            self.headerView.rightButtonHidden = true
        }
    }
    @IBOutlet private weak var avatarImageView: UIImageView! {
        didSet {
            self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.height / 2
        }
    }
    @IBOutlet private weak var chooseImage: UIImageView!
    @IBOutlet private weak var usernameTextField: FloatingLabelTextField! {
        didSet {
            self.usernameTextField.backgroundColor = .clear
            self.usernameTextField.cornerRadius = 8
            self.usernameTextField.placeholder = StringConstants.s01FullnamePlaceholder.localized
            self.usernameTextField.type = .normal
            self.usernameTextField.delegate = self
        }
    }
    @IBOutlet private weak var occupationDropDownView: ProfileItemView! {
        didSet {
            occupationDropDownView.placeholder = StringConstants.s01OccupationPlaceholder.localized
            self.occupationDropDownView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet private weak var submitButton: UIButton! {
        didSet {
            self.submitButton.titleLabel?.font = .font(with: .bold700, size: 16)
            self.submitButton.layer.cornerRadius = 6
            self.submitButton.tintColor = .color646464
            self.submitButton.backgroundColor = .colorE5E5E5
            self.submitButton.setTitle(StringConstants.s01BtnSubmit.localized, for: .normal)
            self.submitButton.setTitle(StringConstants.s01BtnSubmit.localized, for: .highlighted)
            self.submitButton.isUserInteractionEnabled = false
        }
    }
    @IBOutlet private weak var genderMaleButton: UIButton! {
        didSet {
            self.genderMaleButton.setTitle(StringConstants.s01BtnMale.localized, for: .normal)
            self.genderMaleButton.setTitle(StringConstants.s01BtnMale.localized, for: .highlighted)
            self.genderMaleButton.titleLabel?.font = .font(with: .bold700, size: 14)
            self.genderMaleButton.backgroundColor = .white
            self.genderMaleButton.tintColor = .colorB8B8B8
            self.genderMaleButton.layer.cornerRadius = 6
            self.genderMaleButton.layer.borderColor = UIColor.colorE5E5E5.cgColor
            self.genderMaleButton.layer.borderWidth = 1
        }
    }
    @IBOutlet private weak var genderFemaleButton: UIButton! {
        didSet {
            self.genderFemaleButton.setTitle(StringConstants.s01BtnFemale.localized, for: .normal)
            self.genderFemaleButton.setTitle(StringConstants.s01BtnFemale.localized, for: .highlighted)
            self.genderFemaleButton.titleLabel?.font = .font(with: .bold700, size: 14)
            self.genderFemaleButton.backgroundColor = .white
            self.genderFemaleButton.tintColor = .colorB8B8B8
            self.genderFemaleButton.layer.cornerRadius = 6
            self.genderFemaleButton.layer.borderColor = UIColor.colorE5E5E5.cgColor
            self.genderFemaleButton.layer.borderWidth = 1
        }
    }
    @IBOutlet private weak var genderOtherButton: UIButton! {
        didSet {
            self.genderOtherButton.setTitle(StringConstants.s01BtnOther.localized, for: .normal)
            self.genderOtherButton.setTitle(StringConstants.s01BtnOther.localized, for: .highlighted)
            self.genderOtherButton.titleLabel?.font = .font(with: .bold700, size: 14)
            self.genderOtherButton.backgroundColor = .white
            self.genderOtherButton.tintColor = .colorB8B8B8
            self.genderOtherButton.layer.cornerRadius = 6
            self.genderOtherButton.layer.borderColor = UIColor.colorE5E5E5.cgColor
            self.genderOtherButton.layer.borderWidth = 1
        }
    }
    @IBOutlet private weak var addressDropDownView: ProfileItemView! {
        didSet {
            addressDropDownView.placeholder = StringConstants.s01PlaceLivePlaceholder.localized
            addressDropDownView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet private weak var teamDropDownView: ProfileItemView! {
        didSet {
            teamDropDownView.placeholder = StringConstants.s01FavouriteTeam.localized
        }
    }
    @IBOutlet private weak var dateDropTextField: DateView! {
        didSet {
            self.dateDropTextField.backgroundColor = .clear
            self.dateDropTextField.cornerRadius = 8
            self.dateDropTextField.placeholder = StringConstants.s01DobPlaceholder.localized
        }
    }
    
    // MARK: - Properties
    private let viewModel = UpdateProfileViewModel()
    var userDataInfo: AuthenticationInfo?
    var phone: String?
    private var genderValue: Gender = .male
    private var addressSelectedIndex: Int?
    private var occupationSelectedIndex: Int?
    private var partnerId: Int?
    private var sportId: Int?
    private var avatar: String = ""
    private var genderArrayButton = [UIButton]()
    private var addressArray = [AddressInfo]()
    private var teamArray = [TeamInfo]()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    override func bindViewAndViewModel() {
        self.reloadData()
        self.fetchDataFailure()
    }
    
}

// MARK: - Methods
extension UpdateProfileViewController {
    
    private func setupUI() {
        self.view.backgroundColor = .colorYellowFFCC00
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
        self.genderArrayButton = [self.genderMaleButton, self.genderFemaleButton, self.genderOtherButton]
        self.dateDropTextField.chooseDate = {
            let viewController = ChooseDateViewController(date: self.convertToDate())
            viewController.onSelectedDate = { date in
                self.dateDropTextField.updateChooseDate(date: date)
                self.enableSubmit()
            }
            self.present(viewController, animated: true)
        }
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(chooseImageAction))
        self.chooseImage.addGestureRecognizer(tapImage)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectTeam))
        self.teamDropDownView.addGestureRecognizer(tap)
        
        let tapAddress = UITapGestureRecognizer(target: self, action: #selector(selectAddress(_:)))
        self.addressDropDownView.addGestureRecognizer(tapAddress)
        
        let tapOccupation = UITapGestureRecognizer(target: self, action: #selector(selectOccupation(_:)))
        self.occupationDropDownView.addGestureRecognizer(tapOccupation)
        
        let viewAvatar = UITapGestureRecognizer(target: self, action: #selector(viewAvatar(_ :)))
        self.avatarImageView.addGestureRecognizer(viewAvatar)
    }
    
    private func setupData() {
        self.viewModel.getAddress()
        self.viewModel.getTeam()
        self.viewModel.getOccupation()
    }
    
    private func reloadData() {
        self.viewModel.getTeamListSuccess = {
            self.teamArray = self.viewModel.teamList
        }
        
        self.viewModel.getAddressSuccess = {
            self.addressDropDownView.isUserInteractionEnabled = true
        }
        
        self.viewModel.getOccupationSuccess = {
            self.occupationDropDownView.isUserInteractionEnabled = true
        }
        
        self.viewModel.uploadAvatarSuccess = { fileName in
            if let name = self.usernameTextField.text, let idToken = self.userDataInfo?.idToken?.token {
                var gender = ""
                if self.genderMaleButton.backgroundColor == .colorFDD10033 {
                    gender = "Male"
                }
                if self.genderFemaleButton.backgroundColor == .colorFDD10033 {
                    gender = "Female"
                }
                if self.genderOtherButton.backgroundColor == .colorFDD10033 {
                    gender = "Other"
                }
                self.viewModel.saveUpdateProfile(idToken: idToken,
                                                 name: name,
                                                 gender: gender,
                                                 birthday: self.dateDropTextField.getDate(),
                                                 occupationId: self.occupationSelectedIndex ?? 0,
                                                 addressId: self.addressSelectedIndex ?? 0,
                                                 teamId: self.partnerId ?? 0,
                                                 sportId: self.sportId ?? 0,
                                                 avatar: fileName)
            }
        }
        
        self.viewModel.updateProfileSuccess = {
            CommonManager.hideLoading()
            self.push(viewController: WelcomeOnboardViewController())
        }
        
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
        }
    }
    
    private func gotoUseYourPhoto() {
        self.openPhotoLibrary { assets in
            let viewController = UseYourPhotoViewController()
            viewController.assets = assets
            viewController.onSelectPhoto = { image, fileName in
                self.avatarImageView.image = image
                self.avatar = fileName
            }
            self.push(viewController: viewController)
        }
    }
    
    private func convertToDate() -> Date {
        let getDate = self.dateDropTextField.getDate()
        return getDate.toDate(dateFormat: DateFormat.DATE_PROFILE) ?? Date()
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
    
    private func enableSubmit() {
        if !(self.usernameTextField.customTextField.text?.isEmpty ?? true) &&
            !(self.dateDropTextField.customTextField.text?.isEmpty ?? true) &&
            !(self.teamDropDownView.dropDownTextField.text?.isEmpty ?? true) {
            self.genderArrayButton.forEach({
                if $0.backgroundColor == .colorFDD10033 {
                    self.submitButton.tintColor = .colorBlack111111
                    self.submitButton.backgroundColor = .colorYellowFFCC00
                    self.submitButton.isUserInteractionEnabled = true
                    return
                }
            })
        } else {
            self.submitButton.tintColor = .color646464
            self.submitButton.backgroundColor = .colorE5E5E5
            self.submitButton.isUserInteractionEnabled = false
        }
    }
    
}

// MARK: - Actions
extension UpdateProfileViewController {
    
    @IBAction func register(_ sender: Any) {
        if let name = usernameTextField.text,
            let idToken = self.userDataInfo?.idToken?.token {
            if self.avatar.isEmpty {
                self.viewModel.saveUpdateProfile(idToken: idToken,
                                                 name: name,
                                                 gender: self.genderValue.value,
                                                 birthday: self.dateDropTextField.getDate(),
                                                 occupationId: self.occupationSelectedIndex ?? 0,
                                                 addressId: self.addressSelectedIndex ?? 0,
                                                 teamId: self.partnerId ?? 0,
                                                 sportId: self.sportId ?? 0,
                                                 avatar: "")
            } else {
                self.viewModel.uploadAvatar(idToken: idToken,
                                            image: self.avatarImageView.image ?? UIImage(),
                                            fileName: self.avatar)
            }
        }
    }
    
    @objc func chooseImageAction(_ sender: UITapGestureRecognizer) {
        self.showActionSheet(actions: (StringConstants.s01UseYourPhoto.localized, { self.gotoUseYourPhoto() }),
                             (StringConstants.s01TakePhoto.localized, { self.openCamera() }))
    }
    
    @IBAction func chooseGenderAction(_ sender: UIButton) {
        sender.backgroundColor = .colorFDD10033
        sender.tintColor = .colorBlack111111
        sender.layer.borderColor = UIColor.colorYellowFFCC00.cgColor
        self.genderArrayButton.forEach({
            if $0 != sender {
                $0.tintColor = .colorB8B8B8
                $0.backgroundColor = .white
                $0.layer.borderColor = UIColor.colorE5E5E5.cgColor
            }
        })
        
        self.genderValue = Gender(rawValue: sender.tag) ?? Gender.male
        self.enableSubmit()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func selectTeam(_ sender: UITapGestureRecognizer) {
        let viewController = FavoriteTeamViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        viewController.delegate = self
        viewController.checkSignUpOrMyPage = .signUp
        self.present(viewController, animated: true)
    }
    
    @objc func selectAddress(_ sender: UITapGestureRecognizer) {
        let addressList = self.viewModel.addressList
        let viewController = ProfileItemViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        viewController.dataList = addressList.map { $0.name.localized.uppercased() }
        viewController.titleText = StringConstants.s01TitlePlaceLive.localized
        viewController.itemSeletectIndex = addressList.firstIndex { $0.name.localized == self.addressDropDownView.dropDownTextField.text }
        viewController.onSelectedItem = { index in
            self.addressDropDownView.text = addressList[index].name.localized
            self.addressSelectedIndex = addressList[index].id
        }
        self.present(viewController, animated: true)
        
    }
    
    @objc func selectOccupation(_ sender: UITapGestureRecognizer) {
        let occupationList = self.viewModel.occupationList
        let viewController = ProfileItemViewController()
        viewController.titleText = StringConstants.s01TitleOccupation.localized
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        viewController.dataList = occupationList.map { $0.name.lowercased().localized.capitalizingFirstLetter().uppercased()
        }
        viewController.itemSeletectIndex = occupationList.firstIndex { $0.name.lowercased().localized
            == self.occupationDropDownView.dropDownTextField.text
            
        }
        viewController.onSelectedItem = { index in
            self.occupationDropDownView.text = occupationList[index].name.lowercased().localized
            self.occupationSelectedIndex = occupationList[index].id
        }
        self.present(viewController, animated: true)
    }
    
    @objc func viewAvatar(_ sender: UITapGestureRecognizer) {
        if avatar != "" {
            self.present(viewController: ViewPhotoViewController(image: self.avatarImageView.image))
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate
extension UpdateProfileViewController {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            self.dismiss(animated: true)
            return
        }
        
        self.avatarImageView.image = image
        self.avatar = CommonManager.getImageName()
        self.dismiss(animated: false)
        self.showPreviewPhoto(image: image, fileName: self.avatar)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
}

// MARK: - FavoriteTeamProtocol
extension UpdateProfileViewController: FavoriteTeamProtocol {
    
    func favoriteTeamSelected(team: PartnerSportInfo, sportInfo: SportInfo) {
        self.teamDropDownView.text = team.partnerName
        self.partnerId = team.partnerId ?? 0
        self.sportId = sportInfo.id
        self.enableSubmit()
    }
    
}

extension UpdateProfileViewController: FloatingTextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.enableSubmit()
    }
    
}

// MARK: - PreviewPhotoDelegate
extension UpdateProfileViewController: PreviewPhotoDelegate {
    
    func onSave(image: UIImage, fileName: String) {
        self.viewModel.uploadAvatar(idToken: self.userDataInfo?.idToken?.token ?? "", image: image, fileName: fileName)
    }
    
}
