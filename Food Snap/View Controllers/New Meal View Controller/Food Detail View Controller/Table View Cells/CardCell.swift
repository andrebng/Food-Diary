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


//  CardCell.swift
//  Food Snap
//
//  Created by Andre Nguyen on 7/27/17.
//  Copyright © 2017 Andre Nguyen. All rights reserved.
//

import Foundation
import UIKit

class CardCell : UITableViewCell {
    
    static let reuseIdentifier = "CardCell"
    
    // MARK: Properties
    
    var delegate : MealPredictionsDelegate?
    
    // MARK: -
    
    var viewModel: MealViewViewModel?
    
    // MARK: -
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    
    override func layoutSubviews() {
        self.cardSetup()
    }
    
    // MARK: - Public Interface
    
    func configure(viewModel: MealViewViewModel) {
        cardTitle.text = viewModel.name
        caloriesLabel.text = viewModel.caloriesAsString
        fatLabel.text = viewModel.fatAsString
        
        self.viewModel = viewModel
    }
    
    // MARK: - Helper Methods
    
    private func cardSetup() {
        
        self.cardTitle.adjustsFontSizeToFitWidth = true
        
        self.cardView.alpha = 1
        self.cardView.layer.masksToBounds = true
        self.cardView.layer.cornerRadius = 2
        self.cardView.layer.shadowOffset = CGSize(width: -0.2, height: 0.2)
        self.cardView.layer.shadowRadius = 1
        let path = UIBezierPath(rect: self.cardView.bounds)
        self.cardView.layer.shadowPath = path.cgPath
        self.cardView.layer.shadowOpacity = 0.2
        self.cardView.layer.borderColor = UIColor.lightGray.cgColor
        self.cardView.layer.borderWidth = 1
        
        self.backgroundColor = UIColor.init(red: 9, green: 9, blue: 9, alpha: 1)
    }
    
    //MARK: Actions
    @IBAction func clickedButton(_ sender: Any) {
        guard let viewModel = viewModel else { fatalError("Error Setting View Model") }
        self.delegate?.chooseMeal(viewModel: viewModel)
    }
    
}
