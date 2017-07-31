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
