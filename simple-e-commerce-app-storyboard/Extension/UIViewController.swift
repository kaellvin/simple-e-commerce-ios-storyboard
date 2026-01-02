//
//  UIViewController.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 02/01/2026.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, actions: [UIAlertAction] = []){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.isEmpty {
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        }
        present(alert, animated: true)
    }
    
    func showToast(message: String) {
        let padding: CGFloat = 16
        let innerPadding: CGFloat = 8
        
        //container
        let toastView = UIView()
        toastView.backgroundColor = .toastBackground
        toastView.layer.shadowColor = UIColor.black.cgColor
        toastView.layer.shadowOpacity = 0.3
        toastView.layer.shadowOffset = CGSize(width: 0, height: 4)
        toastView.layer.shadowRadius = 4
        toastView.layer.cornerRadius = 8
        
        //icon
        let image = UIImage(systemName: "info.circle.fill")
        let toastImageView = UIImageView(image: image)
        
        //label
        let toastLabel = UILabel(frame: .zero)
        toastLabel.text = message
        toastLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        toastLabel.numberOfLines = 0

        
        guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows.first(where: { $0.isKeyWindow }) else { return }
        
        
        window.addSubview(toastView)
        toastView.addSubview(toastImageView)
        toastView.addSubview(toastLabel)
        
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastImageView.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            
            toastView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: padding),
            toastView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -padding),
            toastView.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: padding),
            toastView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            
            toastImageView.leadingAnchor.constraint(equalTo: toastView.leadingAnchor,constant: innerPadding),
            toastImageView.widthAnchor.constraint(equalToConstant: 24),
            toastImageView.heightAnchor.constraint(equalToConstant: 24),
            toastImageView.centerYAnchor.constraint(equalTo: toastView.centerYAnchor),
                  
            toastLabel.leadingAnchor.constraint(equalTo: toastImageView.trailingAnchor,constant: innerPadding),
            toastLabel.trailingAnchor.constraint(equalTo: toastView.trailingAnchor,constant: -innerPadding),
            toastLabel.topAnchor.constraint(equalTo: toastView.topAnchor,constant: innerPadding),
            toastLabel.bottomAnchor.constraint(equalTo: toastView.bottomAnchor,constant: -innerPadding),
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            toastView.removeFromSuperview()
        }

    }
}
