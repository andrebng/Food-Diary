//
//  CardCell.swift
//  Food Snap
//
//  Created by Andre Nguyen on 7/27/17.
//  Copyright © 2017 Idiots. All rights reserved.
//

import Foundation
import UIKit

protocol CardCellDelegate {
    
    func chooseNutrition(foodName: String, calories: Float, fat: String)
    
}

class CardCell : UITableViewCell {
    
    var delegate : CardCellDelegate?
    
    // Outlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    
    override func layoutSubviews() {
        self.cardSetup()
    }
    
    func cardSetup() {
        
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
    
    @IBAction func clickedButton(_ sender: Any) {
        self.delegate?.chooseNutrition(foodName: self.cardTitle.text!, calories: Float(self.caloriesLabel.text!)!, fat: self.fatLabel.text!)
    }
    
}
