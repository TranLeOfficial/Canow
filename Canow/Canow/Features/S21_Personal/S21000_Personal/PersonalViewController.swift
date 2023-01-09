//
//  PersonalViewController.swift
//  Canow
//
//  Created by NhanTT13 on 11/9/21.
//

import UIKit
import SafariServices

class PersonalViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var personalTableView: UITableView! {
        didSet {
            self.personalTableView.dataSource = self
            self.personalTableView.delegate = self
            self.personalTableView.registerReusedCell(cellNib: PersonalInfoCell.self)
            self.personalTableView.registerReusedCell(cellNib: PersonalCell.self)
            self.personalTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
            // Remove top gap when using a section header.
            if #available(iOS 15.0, *) {
                 // self.personalTableView.sectionHeaderTopPadding = 0
            }
        }
    }
    @IBOutlet weak var bgImageView: UIImageView! {
        didSet {
            self.bgImageView.backgroundColor = .colorF8F8F8
        }
    }
    
    // MARK: - Properties
    let viewModel = PersonalViewModel()
    private var image: UIImage?
    private var avatar: String?
    private var imageForView: UIImage?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.image = nil
        self.avatar = nil
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.fetchCustomerInfoSuccess()
        self.uploadAvatarSuccess()
        self.updateAvatarSuccess()
        self.fetchDataFailure()
    }
    
    override func updateTheme() {
        let bgPattern2 = DataManager.shared.getTheme().bgPattern2
        self.personalTableView.reloadData()
        self.bgImageView.image = bgPattern2
        self.statusView.isHidden = bgPattern2 != nil
    }
    
}

// MARK: - Methods
extension PersonalViewController {
    
    private func setupUI() {
    }
    
    private func updateUI() {
        self.viewModel.fetchData()
    }
    
    private func fetchCustomerInfoSuccess() {
        self.viewModel.fetchCustomerInfoSuccess = { _ in
            self.personalTableView.reloadData()
        }
    }
    
    private func uploadAvatarSuccess() {
        self.viewModel.uploadAvatarSuccess = { data in
            self.viewModel.updateAvatar(avatar: data)
        }
    }
    
    private func updateAvatarSuccess() {
        self.viewModel.updateAvatarSuccess = {
            CommonManager.hideLoading()
            self.personalTableView.reloadData()
            
            CommonManager.showToast(icon: UIImage(named: "ic_toast_success"),
                                    message: StringConstants.s07MessageUpdateAvatarSuccess.localized,
                                    bgColor: UIColor(hexString: "#339A06"))
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                self.viewModel.logout()
            }
            self.personalTableView.reloadData()
        }
    }
    
    private func showHelpView() {
        if let url = URL(string: StringConstants.helpUrl) {
            self.present(SFSafariViewController(url: url), animated: true)
        }
    }
    
    private func showEditProfile() {
        if self.viewModel.checkApiToken() {
            let profileVC = ProfileViewController()
            profileVC.hidesBottomBarWhenPushed = true
            self.push(viewController: profileVC)
        }
    }
    
    private func openLibrary() {
        self.openPhotoLibrary { assets in
            let viewController = UseYourPhotoViewController()
            viewController.assets = assets
            viewController.onSelectPhoto = { image, fileName in
                self.image = image
                self.avatar = fileName
                self.viewModel.uploadAvatar(image: image, fileName: fileName)
            }
            viewController.hidesBottomBarWhenPushed = true
            self.push(viewController: viewController)
        }
    }
    
    private func viewAvatar() {
        self.present(viewController: ViewPhotoViewController(image: self.imageForView))
    }
    
    private func showChooseImage() {
        self.showActionSheet(actions: (StringConstants.s01UseYourPhoto.localized, { self.openLibrary() }),
                             (StringConstants.s01TakePhoto.localized, { self.openCamera() }))
    }
    
    private func logout() {
        self.showPopup(title: StringConstants.s07MessageLogout.localized,
                       popupBg: UIImage(named: "bg_popup_logout"),
                       leftButton: (StringConstants.s01BtnBack.localized, {}),
                       rightButton: (StringConstants.s07LogOut.localized, {
            self.viewModel.logout()
            NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
            self.personalTableView.reloadData()
        }))
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
extension PersonalViewController {
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PersonalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 2, 5:
            return 1
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1, 2, 5:
            if self.viewModel.checkApiToken() {
                fallthrough
            } else {
                return nil
            }
        default:
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1, 2, 5:
            return self.viewModel.checkApiToken() ? 16 : 0
        default:
            return 16
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.viewModel.checkApiToken() {
            return indexPath.section == 0 ? tableView.estimatedRowHeight : 56
        } else {
            switch indexPath.section {
            case 0:
                return tableView.estimatedRowHeight
            case 1, 2, 5:
                return 0
            default:
                return 62
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusable(cellNib: PersonalInfoCell.self)
            let customerInfo = self.viewModel.customerInfo
            let data = (self.viewModel.checkApiToken(),
                        self.image,
                        customerInfo?.avatar,
                        customerInfo?.fullname,
                        customerInfo?.userName)
            cell?.showAvatar = { image in
                if self.viewModel.checkApiToken() {
                    if let avatar = self.viewModel.customerInfo?.avatar, !avatar.isEmpty {
                        self.imageForView = image
                        self.viewAvatar()
                    }
                }
            }
            cell?.showChooseImage = {
                self.showChooseImage()
            }
            cell?.goToEditProfile = {
                if self.viewModel.checkApiToken() {
                    self.showEditProfile()
                } else {
                    let loginVC = LoginViewController()
                    loginVC.hidesBottomBarWhenPushed = true
                    self.push(viewController: loginVC)
                }
            }
            cell?.onSetImage = { image in
                self.imageForView = image
            }
            cell?.configure(data: data)
            return cell ?? BaseTableViewCell()
        default:
            let cell = tableView.dequeueReusable(cellNib: PersonalCell.self)
            cell?.configure(data: self.viewModel.personalData[indexPath.section - 1][indexPath.row], indexPath: indexPath)
            if indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 5 {
                if !self.viewModel.checkApiToken() {
                    cell?.isHidden = true
                } else {
                    cell?.isHidden = false
                }
            }
            return cell ?? BaseTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let historyVC = HistoryViewController()
            historyVC.hidesBottomBarWhenPushed = true
            self.push(viewController: historyVC)
        case 2:
            let viewController = FavoriteTeamViewController()
            viewController.isFromSignup = false
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .overFullScreen
            viewController.checkSignUpOrMyPage = .myPage
            self.present(viewController: viewController)
        case 3:
            switch indexPath.row {
            case 0:
                let termsAndConditionsVC = TermsAndConditionsViewController()
                termsAndConditionsVC.hidesBottomBarWhenPushed = true
                self.push(viewController: termsAndConditionsVC)
            default:
                let eCommerceLawVC = ECommerceLawViewController()
                eCommerceLawVC.hidesBottomBarWhenPushed = true
                self.push(viewController: eCommerceLawVC)
            }
        case 4:
            switch indexPath.row {
            case 0:
                let languageSettingVC = LanguageSettingViewController()
                languageSettingVC.modalTransitionStyle = .crossDissolve
                languageSettingVC.modalPresentationStyle = .overFullScreen
                self.present(viewController: languageSettingVC)
            default:
                self.showHelpView()
            }
        case 5:
            self.logout()
        default:
            break
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate
extension PersonalViewController {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            self.dismiss(animated: true)
            return
        }
        
        self.image = image
        self.avatar = CommonManager.getImageName()
        self.dismiss(animated: false)
        self.showPreviewPhoto(image: image, fileName: self.avatar ?? "")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
}

// MARK: - PreviewPhotoDelegate
extension PersonalViewController: PreviewPhotoDelegate {
    
    func onSave(image: UIImage, fileName: String) {
        self.viewModel.uploadAvatar(image: image, fileName: fileName)
    }
    
}
