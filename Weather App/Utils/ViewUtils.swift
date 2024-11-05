//
//  ViewUtils.swift
//  Weather App
//
//  Created by Yoji on 02.11.2024.
//

import UIKit

extension UIView {
    func visibility(gone: Bool, dimension: CGFloat = 0, attribute: NSLayoutConstraint.Attribute = .height) {
        if let constraint = self.constraints.filter({ $0.firstAttribute == attribute }).first {
            constraint.constant = gone ? 0 : dimension
            self.layoutIfNeeded()
            self.isHidden = gone
        }
    }
}
