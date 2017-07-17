//
//  CustomStyleExtensions.swift
//  personneldb
//
//  Created by Ronaldo II Dorado on 17/7/17.
//  Copyright © 2017 Ronaldo II Dorado. All rights reserved.
//

import UIKit

extension UITextField {
    func setCustomStyle() {
        self.borderStyle = .roundedRect
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        self.layer.masksToBounds = true
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
    }
}
