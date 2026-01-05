//
//  HomeCell.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 03/01/2026.
//

import UIKit

class HomeCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        
        clipsToBounds = false //NOTE: override storyboard cell default
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5

        
        contentView.layer.cornerRadius = 16
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 16
        ).cgPath
    }
    
    func configure(with product: Product) {
        guard let url = URL(string: product.imageUrl) else { return }
        //TODO: refactor
        Task {
            if let (data,_) = try? await URLSession.shared.data(from: url), let image = UIImage(data: data) {
                await MainActor.run {
                    productImageView.image = image
                }
                
            }
        }
        productName.text = product.name
        productPrice.text = Int(product.price)?.formatted(.currency(code: "MYR"))
    }
}
