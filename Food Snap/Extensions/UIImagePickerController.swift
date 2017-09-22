//
//  UIImagePickerController.swift
//  Food Snap
//
//  Created by Andre Nguyen on 9/22/17.
//  Copyright © 2017 Idiots. All rights reserved.
//

import UIKit

extension UIImagePickerController {
    
    func presentCamera(viewController: UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        self.delegate = viewController
        self.sourceType = .camera
        self.allowsEditing = false
        viewController.present(self, animated: true)
    }
    
    func presentPhotoLibrary(viewController: UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        self.allowsEditing = false
        self.delegate = viewController
        self.sourceType = .photoLibrary
        viewController.present(self, animated: true)
    }
    
}
