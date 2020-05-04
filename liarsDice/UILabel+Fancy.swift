//
//  UILabel+Fancy.swift
//  liarsDice
//
//  Created by M. Gao on 03/04/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func glow(){
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.9
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
    }
    func removeGlow(){
        self.layer.shadowOpacity = 0
    }
}

