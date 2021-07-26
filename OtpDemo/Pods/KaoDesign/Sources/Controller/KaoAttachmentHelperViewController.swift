//
//  KaoAttachmentHelperViewController.swift
//  KaoDesign
//
//  Created by Augustius on 16/10/2019.
//

import Foundation
import MobileCoreServices

open class KaoAttachmentHelperViewController: KaoTableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate {

    // MARK: - Image and Document Picker
    open func attachNewFile(_ attachment: AnyObject, fileName: String) { }

    open func openSettingScreen() { }

    open func uploadOptionTap(_ type: KaoAttachmentType) {
        self.view.endEditing(true)
        DispatchQueue.main.async {
            switch type {
            case .camera:
                self.checkCameraPermission(self) {
                    self.openSettingScreen()
                }
            case .library:
                self.checkPhotoLibraryPermission(self) {
                    self.openSettingScreen()
                }
            case .document:
                self.openFileImporter(self)
            }
        }
    }

    // MARK: - UINavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.navigationBar.kaodimStyle()
    }

    // MARK: - UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        picker.dismiss(animated: true, completion: {
            let currentTimeStamp = String(format: "%.0f", Double(Date().timeIntervalSince1970))
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let fileName = "IMG_\(currentTimeStamp)_.PNG"
                self.attachNewFile(originalImage, fileName: fileName)
            } else if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
                let assetPath = info[UIImagePickerController.InfoKey.referenceURL] as? NSURL
                let fileExt = assetPath?.absoluteString?.components(separatedBy: "ext=").last ?? ""
                let fileName = "VID_\(currentTimeStamp)_.\(fileExt)"
                self.attachNewFile(videoURL, fileName: fileName)
            }
        })

    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    // MARK: - UIDocumentMenuDelegate
    public func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }

    // MARK: - UIDocumentPickerDelegate
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if controller.documentPickerMode == .import {
            // Attach as NSURL
            attachNewFile(url as AnyObject, fileName: url.lastPathComponent)
        }
    }
}

open class KaoTableAttachmentHelperViewController: KaoTableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate {

    // MARK: - Image and Document Picker
    open func attachNewFile(_ attachment: AnyObject, fileName: String) { }

    open func openSettingScreen() { }

    open func uploadOptionTap(_ type: KaoAttachmentType) {
        self.view.endEditing(true)
        DispatchQueue.main.async {
            switch type {
            case .camera:
                self.checkCameraPermission(self) {
                    self.openSettingScreen()
                }
            case .library:
                self.checkPhotoLibraryPermission(self) {
                    self.openSettingScreen()
                }
            case .document:
                self.openFileImporter(self)
            }
        }
    }

    // MARK: - UINavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.navigationBar.kaodimStyle()
    }

    // MARK: - UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        picker.dismiss(animated: true, completion: {
            let currentTimeStamp = String(format: "%.0f", Double(Date().timeIntervalSince1970))
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let fileName = "IMG_\(currentTimeStamp)_.PNG"
                self.attachNewFile(originalImage, fileName: fileName)
            } else if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
                let assetPath = info[UIImagePickerController.InfoKey.referenceURL] as? NSURL
                let fileExt = assetPath?.absoluteString?.components(separatedBy: "ext=").last ?? ""
                let fileName = "VID_\(currentTimeStamp)_.\(fileExt)"
                self.attachNewFile(videoURL, fileName: fileName)
            }
        })

    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    // MARK: - UIDocumentMenuDelegate
    public func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }

    // MARK: - UIDocumentPickerDelegate
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if controller.documentPickerMode == .import {
            // Attach as NSURL
            attachNewFile(url as AnyObject, fileName: url.lastPathComponent)
        }
    }
}
