//
//  RoundedImageView.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 08/01/2026.
//

import UIKit

class RoundedImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 16
    }
    
}
