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


//  NutritionCard.swift
//  Food Snap
//
//  Created by Andre Nguyen on 7/30/17.
//  Copyright © 2017 Andre Nguyen. All rights reserved.
//

import Foundation
import UIKit

class NutritionCard : UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "NutritionCardCell"
    
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
        if #available(iOS 11.0, *) {
            self.cardSetup()
        }
    }
    
    // MARK: - Public Interface
    
    func configure(viewModel: MealViewViewModel) {
        
        if let firstLetter = viewModel.name.characters.first {
            self.foodLetterLabel.text = "\(firstLetter)"
        }
        else {
            self.foodLetterLabel.text = "F"
        }
        
        self.foodNameLabel.text = viewModel.name
        self.caloriesValueLabel.text = viewModel.caloriesAsString
        self.fatValueLabel.text = viewModel.fatAsString
    }
    
    // MARK: - Helper Methods
    
    @available(iOS 11.0, *)
    private func cardSetup() {
        
        self.foodNameLabel.adjustsFontSizeToFitWidth = true
        
        // Set Round corners for Card
        self.cardView.setSlightlyRoundedCorners()
        
        // Set rounded image
        foodImage.setCircledCorners()
        caloriesCircle.setCircledCorners()
        fatCircle.setCircledCorners()
    }
    
}
