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
    
    func createGradientBlur() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
        UIColor.white.withAlphaComponent(0).cgColor,
        UIColor.white.withAlphaComponent(1).cgColor]
        let viewEffect = UIBlurEffect(style: .systemMaterialDark)
        let effectView = UIVisualEffectView(effect: viewEffect)
        effectView.frame = self.bounds
        gradientLayer.frame = effectView.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0 , y: 1)
        effectView.autoresizingMask = [.flexibleHeight]
        effectView.layer.mask = gradientLayer
        effectView.isUserInteractionEnabled = false //Use this to pass touches under this blur effect
        self.addSubview(effectView)

    }
    
    func addGrad(color1:UIColor, color2:UIColor) -> CAGradientLayer{
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        return gradient
    }
        
}
