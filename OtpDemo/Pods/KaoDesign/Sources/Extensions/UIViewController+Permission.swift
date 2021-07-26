//
//  UIViewController+Permission.swift
//  KaoDesign
//
//  Created by augustius cokroe on 01/03/2019.
//

import Foundation
import Photos
import MobileCoreServices

public extension UIViewController {

    func checkCameraPermission(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, permissionDenied: @escaping (() -> Void)) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] (status) in
            if status {
                DispatchQueue.main.async {
                    self?.openCamera(delegate)
                }
            } else {
                permissionDenied()
            }
        }
    }

    func openCamera(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = delegate
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("This device doesn't support camera access")
        }
    }

    func checkPhotoLibraryPermission(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, permissionDenied: @escaping (() -> Void)) {
        let status = PHPhotoLibrary.authorizationStatus()


        #if swift(>=5.3)
        print("Running Swift 5.3 or later")
        switch status {
          case .authorized,.limited:
              self.openPhotoLibrary(delegate)
          case .denied, .restricted:
              permissionDenied()
          case .notDetermined:
              // ask for permissions
              PHPhotoLibrary.requestAuthorization { [weak self] status in
                  switch status {
                  case .authorized,.limited:
                      DispatchQueue.main.async {
                          self?.openPhotoLibrary(delegate)
                      }
                  case .denied, .restricted, .notDetermined:
                      permissionDenied()
                  }
              }
          }
        #else
        print("Running old Swift")
        switch status {
          case .authorized:
              self.openPhotoLibrary(delegate)
          case .denied, .restricted:
              permissionDenied()
          case .notDetermined:
              // ask for permissions
              PHPhotoLibrary.requestAuthorization { [weak self] status in
                  switch status {
                  case .authorized:
                      DispatchQueue.main.async {
                          self?.openPhotoLibrary(delegate)
                      }
                  case .denied, .restricted, .notDetermined:
                      permissionDenied()
                  }
              }
          }
        #endif
    }

    func openPhotoLibrary(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = delegate
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = ["public.image", "public.movie"]
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("This device doesn't support photo library access")
        }
    }

    func openFileImporter(_ delegate: UIDocumentPickerDelegate?) {

        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)

        if #available(iOS 11.0, *) {
            documentPicker.allowsMultipleSelection = true
        }

        documentPicker.delegate = delegate
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker, animated: true, completion: nil)
    }
}
