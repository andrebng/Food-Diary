//MIT License
//
//Copyright (c) 2017 Andre Nguyen
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
//
//  NutritionCard.swift
//  Food Snap
//
//  Created by Andre Nguyen on 7/30/17.
//  Copyright © 2017 Idiots. All rights reserved.
//

import Foundation
import UIKit

class NutritionCard : UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodLetterLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var caloriesCircle: UIImageView!
    @IBOutlet weak var caloriesTitleLabel: UILabel!
    @IBOutlet weak var caloriesMetricLabel: UILabel!
    @IBOutlet weak var caloriesValueLabel: UILabel!
    
    @IBOutlet weak var fatCircle: UIImageView!
    @IBOutlet weak var fatTitleLabel: UILabel!
    @IBOutlet weak var fatMetricLabel: UILabel!
    @IBOutlet weak var fatValueLabel: UILabel!
    
    override func layoutSubviews() {
        self.cardSetup()
    }
    
    func cardSetup() {
        
        self.foodNameLabel.adjustsFontSizeToFitWidth = true
        
        // Set Round corners for Card
        self.cardView.alpha = 1
        self.cardView.layer.masksToBounds = true
        self.cardView.layer.cornerRadius = 5
        self.cardView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.cardView.layer.shadowRadius = 10
        let path = UIBezierPath(rect: self.cardView.bounds)
        self.cardView.layer.shadowPath = path.cgPath
        self.cardView.layer.shadowOpacity = 0.5
        self.cardView.layer.borderColor = UIColor.lightGray.cgColor
        self.cardView.layer.borderWidth = 1
        
        // Set rounded image
        foodImage.layer.masksToBounds = false
        foodImage.layer.cornerRadius = foodImage.frame.height/2
        foodImage.clipsToBounds = true
        
        caloriesCircle.layer.masksToBounds = false
        caloriesCircle.layer.cornerRadius = caloriesCircle.frame.height/2
        caloriesCircle.clipsToBounds = true
        
        fatCircle.layer.masksToBounds = false
        fatCircle.layer.cornerRadius = fatCircle.frame.height/2
        fatCircle.clipsToBounds = true
    }
}
