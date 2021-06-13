//
//  Extensions.swift
//  TwistGroup
//
//  Created by Aritro Paul on 6/12/21.
//

import Foundation
import UIKit

extension UIView {
    func makeCard(){
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor.black.cgColor
    }
}
