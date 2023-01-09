//
//  UIViewController+Extensions.swift
//  Plass
//
//  Created by hieplh2 on 10/02/21.
//

import UIKit
import AVFoundation
import Photos

// MARK: Navigation
extension UIViewController {
    
    func push(viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func present(viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.present(viewController, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func popTo(viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.popToViewController(viewController, animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        self.navigationController?.popToRootViewController(animated: animated)
    }
    
}

// MARK: Alert, Action Sheet
extension UIViewController {
    
    typealias AlertButton = (title: String, action: () -> Void)
    
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   actions: AlertButton ...) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if actions.isEmpty {
            let buttonAction = UIAlertAction(title: StringConstants.cancel, style: .cancel)
            alert.addAction(buttonAction)
        } else {
            for item in actions {
                let action = UIAlertAction(title: item.title,
                                           style: .default,
                                           handler: { _ in
                    item.action()
                })
                alert.addAction(action)
            }
        }
        
        self.present(alert, animated: true)
    }
    
    func showActionSheet(title: String? = nil,
                         message: String? = nil,
                         tintColor: UIColor? = UIColor(hexString: "#000000"),
                         actions: AlertButton ...) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = tintColor
        for item in actions {
            let action = UIAlertAction(title: item.title,
                                       style: .default,
                                       handler: { _ in
                item.action()
            })
            actionSheet.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: StringConstants.s01BtnCancel.localized, style: .cancel)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
    }
    
}

// MARK: - Custom Popup
extension UIViewController {
    
    func showPopup(title: String,
                   message: String? = nil,
                   popupBg: UIImage?,
                   titleFont: UIFont = UIFont.font(with: .bold700, size: 16),
                   messageFont: UIFont = UIFont.font(with: .regular400, size: 14),
                   leftButton: AlertButton? = nil,
                   rightButton: AlertButton) {
        let popupVC = PopupViewController(title: title,
                                          message: message,
                                          popupBg: popupBg,
                                          titleFont: titleFont,
                                          messageFont: messageFont,
                                          leftButton: leftButton,
                                          rightButton: rightButton)
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.modalPresentationStyle = .overFullScreen
        
        self.present(viewController: popupVC)
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Create camera picker.
    private func cameraPicker(allowsEditing: Bool) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraFlashMode = .off
        imagePicker.allowsEditing = allowsEditing
        
        return imagePicker
    }
    
    // Create photo picker.
    private func photoLibraryPicker(allowsEditing: Bool) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = allowsEditing
        
        return imagePicker
    }
    
    // Check permission and open camera picker.
    public func openCamera(checkPermissionOnly: Bool = false,
                           allowsEditing: Bool = false,
                           animated: Bool = true,
                           completion: ((_ imagePicker: UIImagePickerController) -> Void)? = nil) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraMediaType = AVMediaType.video
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
            
            switch cameraAuthorizationStatus {
            case .authorized:
                let imagePicker = self.cameraPicker(allowsEditing: allowsEditing)
                imagePicker.modalPresentationStyle = .fullScreen
                if checkPermissionOnly {
                    completion?(imagePicker)
                } else {
                    self.present(imagePicker, animated: animated)
                }
            case .restricted, .denied:
                self.showCameraAccessDeniedAlert()
            case .notDetermined:
                // Prompting user for the permission to use the Camera.
                AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                    DispatchQueue.main.async {
                        if granted {
                            let imagePicker = self.cameraPicker(allowsEditing: allowsEditing)
                            imagePicker.modalPresentationStyle = .fullScreen
                            if checkPermissionOnly {
                                completion?(imagePicker)
                            } else {
                                self.present(imagePicker, animated: animated)
                            }
                        } else {
                            self.showCameraAccessDeniedAlert()
                        }
                    }
                }
            @unknown default:
                // Handle unknown values using "@unknown default"
                break
            }
        } else {
            print("Camera is not available")
        }
    }
    
    /// Check permission and open photo picker.
    public func openPhotoLibrary(completion: ((_ assets: PHFetchResult<PHAsset>) -> Void)? = nil) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            
            switch photoAuthorizationStatus {
            case .authorized:
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                completion?(assets)
            case .limited:
                print("openPhotoLibrary case limited")
            case .restricted, .denied:
                self.showPhotoLibraryAccessDeniedAlert()
            case .notDetermined:
                // Prompting user for the permission to use the Photos.
                PHPhotoLibrary.requestAuthorization({ (authorizationStatus) in
                    DispatchQueue.main.async {
                        if authorizationStatus == .authorized {
                            let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                            completion?(assets)
                        } else {
                            self.showPhotoLibraryAccessDeniedAlert()
                        }
                    }
                })
            @unknown default:
                // Handle unknown values using "@unknown default"
                break
            }
        } else {
            print("Photo library is not available")
        }
    }
    
    // Show Camera Access Denied Alert.
    private func showCameraAccessDeniedAlert() {
        self.showPopup(title: StringConstants.permissionAcceptCamera.localized,
                       popupBg: UIImage(named: "bg_popup_camera"),
                       leftButton: (StringConstants.btnDeny.localized, {}),
                       rightButton: (StringConstants.qrGotoSetting.localized, { CommonManager.openApplicationSettings() }))
    }
    
    // Show Photo Library Access Denied Alert.
    private func showPhotoLibraryAccessDeniedAlert() {
        self.showPopup(title: StringConstants.permissionAcceptPhoto.localized,
                       popupBg: UIImage(named: "bg_popup_photos"),
                       leftButton: (StringConstants.btnDeny.localized, {}),
                       rightButton: (StringConstants.qrGotoSetting.localized, { CommonManager.openApplicationSettings() }))
    }
    
}
