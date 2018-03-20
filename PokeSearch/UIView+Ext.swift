//
//  UIView+Ext.swift
//  PokeSearch
//
//  Created by Shruti Sharma on 2/23/18.
//  Copyright © 2018 Shruti Sharma. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
}

