//
//  String.swift
//  simple-e-commerce-app-storyboard
//
//  Created by Kelvin Leong on 01/01/2026.
//

import Foundation

extension String {
    //TODO
    var isValidEmail : Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}
