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
        overlayImageView.tintColor = .black
        overlayImageView.frame = CGRect(x: leftPadding, y: 0, width: width, height: height)
        overlayImageView.contentMode = .scaleAspectFit
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: width + leftPadding, height: height))
        containerView.addSubview(overlayImageView)
        self.leftView = containerView
        self.leftViewMode = .always
    }
}
