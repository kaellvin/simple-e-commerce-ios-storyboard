//
//  ProductDetailCell.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 05/01/2026.
//

import UIKit

class ProductDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with imageURL: String) {
        Task {
            let image = await ImageLoader.shared.loadImage(from: imageURL)
            await MainActor.run {
                imageView.image = image
            }
        }
    }
}
