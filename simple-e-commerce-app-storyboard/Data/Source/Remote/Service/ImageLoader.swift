//
//  ImageLoader.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 06/01/2026.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    
    private init() {}
    
    func loadImage(from imageURL: String) async -> UIImage?  {
        guard let url = URL(string: imageURL) else { return nil }
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            let image = UIImage(data: data)
            return image
        } catch  {
            return nil
        }
    }
}
