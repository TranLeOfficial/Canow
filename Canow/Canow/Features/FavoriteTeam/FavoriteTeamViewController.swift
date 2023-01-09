//
//  FavoriteTeamViewController.swift
//  Canow
//
//  Created by hieplh2 on 10/12/2021.
//

import UIKit

enum FavoriteTeamType {
    case signUp
    case myPage
    case fanToken
}

protocol FavoriteTeamProtocol: AnyObject {
    func favoriteTeamSelected(team: PartnerSportInfo, sportInfo: SportInfo)
}

class FavoriteTeamViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.backButtonHidden = true
            self.headerView.rightButtonHidden = false
            self.headerView.rightButtonImage = UIImage(named: "ic_close")
            self.headerView.onPressRightButton = {
                self.dismiss(animated: true)
            }
        }
    }
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var selectTeamButton: CustomButton! {
        didSet {
            self.selectTeamButton.setTitle(StringConstants.s01BtnSelectTeam.localized, for: .normal)
            self.selectTeamButton.setTitle(StringConstants.s01BtnSelectTeam.localized, for: .highlighted)
            self.selectTeamButton.titleLabel?.font = .font(with: .bold700, size: 16)
            self.selectTeamButton.layer.cornerRadius = 6
            if checkSignUpOrMyPage == .signUp {
                self.selectTeamButton.disable()
            }
        }
    }
    @IBOutlet weak var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var fantokenEmptyView: UIView!
    @IBOutlet weak var fantokenEmptyLabel: UILabel! {
        didSet {
            self.fantokenEmptyLabel.font = .font(with: .medium500, size: 14)
            self.fantokenEmptyLabel.textColor = .color646464
            self.fantokenEmptyLabel.text = StringConstants.s01MessageEmptySport.localized
        }
    }
    @IBOutlet weak var favoriteTeamCollectionView: UICollectionView! {
        didSet {
            self.favoriteTeamCollectionView.delegate = self
            self.favoriteTeamCollectionView.dataSource = self
            self.favoriteTeamCollectionView.registerReusedCell(cellNib: FavoriteTeamCell.self)
            self.favoriteTeamCollectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        }
    }
    
    @IBOutlet weak var teamCollectionView: UICollectionView! {
        didSet {
            self.teamCollectionView.delegate = self
            self.teamCollectionView.dataSource = self
            self.teamCollectionView.registerReusedCell(cellNib: TeamSelectedCell.self)
            self.teamCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    // MARK: - Properties
    private let viewModel = FavoriteTeamViewModel()
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    private var teamSelectedIndex: Int?
    private var favoriteSelectedIndex: Int?
    weak var delegate: FavoriteTeamProtocol?
    private let collectionViewLayout = CustomCollectionViewFlowLayout(itemSize: CGSize(width: 200, height: 200),minimumLineSpacing: 20)
    private var sportId = 1
    private var teamId: Int?
    
    var isFromSignup = true
    var checkSignUpOrMyPage: FavoriteTeamType?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
    }
    
    // MARK: - Override methods
    override func bindViewAndViewModel() {
        self.reloadData()
        self.getTeamInfo()
        self.fetchDataFailure()
    }
    
    override func updateTheme() {
        switch self.checkSignUpOrMyPage {
        case .fanToken:
            self.view.backgroundColor = self.themeInfo.primaryColor
            self.headerView.setTitle(title: StringConstants.fanToken.localized)
            self.teamCollectionView.reloadData()
        default:
            break
        }
    }
    
}

// MARK: - Methods
extension FavoriteTeamViewController {
    
    private func getSportListSuccess() {
        self.viewModel.getSportListSuccess = {
            if !self.viewModel.sports.isEmpty {
                switch self.checkSignUpOrMyPage {
                case .signUp, .fanToken:
                    self.teamCollectionView.reloadData()
                    self.teamSelectedIndex = 0
                    self.viewModel.getPartnerBySportId(sportId: self.viewModel.sports[0].id)
                case .myPage:
                    let dataCustomerInfo = DataManager.shared.getCustomerInfo()
                    for (index, sport) in self.viewModel.sports.enumerated()
                    where dataCustomerInfo?.sport == sport.name.rawValue {
                        self.teamSelectedIndex = index
                        self.viewModel.getPartnerBySportId(sportId: self.viewModel.sports[index].id)
                        self.sportId = self.viewModel.sports[index].id
                    }
                    self.teamCollectionView.reloadData()
                    if let teamSelectedIndex = self.teamSelectedIndex {
                        self.teamCollectionView.scrollToItem(at: IndexPath(row: teamSelectedIndex, section: 0),
                                                             at: .centeredHorizontally,
                                                             animated: false)
                    }
                case .none:
                    break
                }
            } else {
                CommonManager.hideLoading()
            }
        }
    }
    
    private func getPartnerListSuccess() {
        self.viewModel.getPartnerListSuccess = {
            self.fantokenEmptyView.isHidden = !self.viewModel.partners.isEmpty
            switch self.checkSignUpOrMyPage {
            case .signUp, .fanToken:
                self.favoriteTeamCollectionView.reloadData()
                CommonManager.hideLoading()
            case .myPage:
                let dataCustomerInfo = DataManager.shared.getCustomerInfo()
                for (index, partner) in self.viewModel.partners.enumerated() where dataCustomerInfo?.team == partner.partnerName {
                    self.favoriteSelectedIndex = index
                }
                self.favoriteTeamCollectionView.reloadData()
                if let index = self.favoriteSelectedIndex {
                    self.selectTeamButton.enable()
                    self.favoriteTeamCollectionView.scrollToItem(at: IndexPath(row: index, section: 0),
                                                                 at: .centeredVertically,
                                                                 animated: false)
                    self.favoriteTeamCollectionView.selectItem(at: IndexPath(item: index, section: 0),
                                                               animated: true,
                                                               scrollPosition: .centeredVertically)
                }
                CommonManager.hideLoading()
            case .none:
                break
            }
        }
    }
    
    private func updateTeamSuccess() {
        self.viewModel.updateTeamSuccess = {
            CommonManager.hideLoading()
            self.dismiss(animated: true)
            NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
        }
    }
    
    private func reloadData() {
        getSportListSuccess()
        getPartnerListSuccess()
        updateTeamSuccess()
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
        }
    }
    
    private func setupData() {
        switch self.checkSignUpOrMyPage {
        case .fanToken:
            self.selectTeamButton.isHidden = true
            self.headerView.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            }
            self.stackView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            }
            self.teamCollectionView.snp.updateConstraints { make in
                make.top.equalTo(self.favoriteView.snp.top).offset(32)
            }
            self.headerView.setTitle(title: StringConstants.fanToken.localized)
            self.headerView.rightButtonHidden = true
            self.contentView.clipsToBounds = false
            self.contentView.backgroundColor = .clear
            self.favoriteView.clipsToBounds = true
            self.favoriteView.layer.cornerRadius = 20
            self.favoriteView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        default:
            self.headerView.setTitle(title: StringConstants.s01FavouriteTeam.localized,
                                     color: .black,
                                     font: .font(with: .bold700, size: 16))
        }
        self.viewModel.getSport()
    }
    
    private func getTeamInfo() {
        self.viewModel.fetchTeamSelected = {
            CommonManager.hideLoading()
            if KeychainManager.apiIdToken() != nil {
                let homePageVC = HomePageViewController()
                DataManager.shared.saveCheck(check: .fanToken)
                homePageVC.checkFantokenPush = .fanToken
                self.push(viewController: homePageVC)
            } else {
                self.push(viewController: TeamLandingPageViewController())
            }
        }
    }
    
}

// MARK: - Actions
extension FavoriteTeamViewController {
    
    @IBAction func selectTeamAction(_ sender: UIButton) {
        if let favoriteIndex = favoriteSelectedIndex, let sportIndex = teamSelectedIndex {
            if self.isFromSignup {
                let partnerInfo = self.viewModel.partners[favoriteIndex]
                let sportInfo = self.viewModel.sports[sportIndex]
                self.delegate?.favoriteTeamSelected(team: partnerInfo, sportInfo: sportInfo)
                self.dismiss(animated: true)
            } else {
                guard let teamId = self.teamId else {
                    if self.checkSignUpOrMyPage == .myPage {
                        self.dismiss(animated: true)
                        return
                    }
                    return
                }
                self.viewModel.updateTeam(sportId: self.sportId, teamId: teamId)
            }
        }
    }
    
}

// MARK: - Collection view
extension FavoriteTeamViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.favoriteTeamCollectionView:
            return self.viewModel.partners.count
        default:
            return self.viewModel.sports.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.favoriteTeamCollectionView:
            let cell = collectionView.dequeueReusable(cellNib: FavoriteTeamCell.self, indexPath: indexPath)
            let data = (self.viewModel.partners[indexPath.row], self.checkSignUpOrMyPage)
            cell?.configure(data: data)
            return cell ?? BaseCollectionViewCell()
        default:
            let cell = collectionView.dequeueReusable(cellNib: TeamSelectedCell.self, indexPath: indexPath)
            cell?.isCellSelected = self.teamSelectedIndex == indexPath.row
            cell?.configure(data: self.viewModel.sports[indexPath.row])
            return cell ?? BaseCollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.favoriteTeamCollectionView:
            switch self.checkSignUpOrMyPage {
            case .fanToken:
                let partnerId = self.viewModel.partners[indexPath.row].partnerId ?? 0
                DataManager.shared.saveCheck(check: .fanToken)
                CommonManager.showLoading()
                self.viewModel.getTeamInfoSelected(partnerId: partnerId)
            default:
                self.favoriteSelectedIndex = indexPath.row
                self.selectTeamButton.enable()
                self.teamId = self.viewModel.partners[indexPath.row].partnerId
            }
        default:
            if self.teamSelectedIndex != indexPath.row {
                self.teamSelectedIndex = indexPath.row
                self.favoriteSelectedIndex = nil
                self.teamCollectionView.reloadData()
                self.viewModel.getPartnerBySportId(sportId: self.viewModel.sports[indexPath.row].id)
                self.selectTeamButton.disable()
                self.teamId = nil
                self.sportId = self.viewModel.sports[indexPath.row].id
                self.teamCollectionView.scrollToItem(at: indexPath,
                                                     at: .centeredHorizontally,
                                                     animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.favoriteTeamCollectionView:
            let width = collectionView.frame.width / 2 - 8
            let height = width * 116 / 163
            return CGSize(width: width, height: height)
        default:
            let name = self.viewModel.sports[indexPath.row].name.message
            let font = UIFont.font(with: .medium500, size: 14)
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = (name as NSString).size(withAttributes: fontAttributes)
            let width = size.width + 28
            return CGSize(width: width, height: 36)
        }
    }
    
}
