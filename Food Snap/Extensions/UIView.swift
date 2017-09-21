//
//  UIView.swift
//  Food Snap
//
//  Created by Andre Nguyen on 9/19/17.
//  Copyright © 2017 Idiots. All rights reserved.
//

import UIKit

//MARK: UIView Extension
@available(iOS 11.0, *)
extension UIView {
    
    func setRoundedTopCorners() {
        // Rounden corners on top
        let screenSize: CGRect = UIScreen.main.bounds
        let HeightFloat :CGFloat = screenSize.height
        let WidthFloat :CGFloat = screenSize.width
        
        let NewRect :CGRect = CGRect(x: 0, y: 20, width: WidthFloat, height: HeightFloat)
        let maskPath = UIBezierPath(roundedRect: NewRect,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 10, height: 10))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        shape.strokeColor = UIColor.clear.cgColor
        shape.lineJoin = kCALineJoinRound
        
        self.layer.mask = shape
    }
    
    func setSlightlyRoundedCorners() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 10
        let path = UIBezierPath(rect: self.bounds)
        self.layer.shadowPath = path.cgPath
        self.layer.shadowOpacity = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
    
    func setCircledCorners() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func setGradientBackground(startColor: UIColor, endColor: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
