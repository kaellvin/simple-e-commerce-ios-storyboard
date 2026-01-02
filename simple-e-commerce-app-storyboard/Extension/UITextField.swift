//
//  UITextField.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 31/12/2025.
//

import UIKit

extension UITextField {
    
    func setLeadingIcon (systemName: String) {
        let width = 24
        let height = 24
        let leftPadding = 12
        
        let iconImage = UIImage(systemName: systemName)
        let overlayImageView = UIImageView(image: iconImage)
        overlayImageView.frame = CGRect(x: leftPadding, y: 0, width: width, height: height)
        overlayImageView.contentMode = .scaleAspectFit
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: width + leftPadding, height: height))
        containerView.addSubview(overlayImageView)
        self.leftView = containerView
        self.leftViewMode = .always
    }
    
    func setTrailingPasswordIcon() {
        let width = 24
        let height = 24
        let rightPadding = 12

        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.frame =  CGRect(x: 0, y: 0, width: width, height: height)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: width + rightPadding, height: height))
        containerView.addSubview(button)
        self.rightView = containerView
        self.rightViewMode = .always
        self.isSecureTextEntry = true
        
    }
    
    @objc func togglePasswordVisibility() {
        self.isSecureTextEntry.toggle()
        let imageName = isSecureTextEntry ? "eye" : "eye.slash"
        if let button = rightView?.subviews.first as? UIButton {
            button.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
}
