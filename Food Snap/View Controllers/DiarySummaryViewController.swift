//
//  DiarySummaryViewController.swift
//  Food Snap
//
//  Created by Andre Nguyen on 9/19/17.
//  Copyright © 2017 Idiots. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class DiarySummaryViewController: UIViewController {
    
    static let segueIdentifier = "EmbeddedDiarySummaryViewControllerSegue"
    
    // MARK: - Properties
    
    @IBOutlet var diaryTitleLabel: UILabel!
    @IBOutlet var diaryImageView: UIImageView!
    
    // MARK: -
    
    @IBOutlet var weightGoalLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    
    // MARK: -
    
    @IBOutlet var caloriesADayTitleLabel: UILabel!
    @IBOutlet var caloriesADayLabel: UILabel!
    
    // MARK: -
    
    @IBOutlet var fatTitleLabel: UILabel!
    @IBOutlet var fatLabel: UILabel!
    
    // MARK: -
    
    @IBOutlet var weightTitleLabel: UILabel!
    @IBOutlet var currentWeightLabel: UILabel!
    
    // MARK: -
    
    @IBOutlet var changeGoalButton: UIButton!
    
    // MARK: - View Controller Life-Cycle
    
    override func viewDidLoad() {
        
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateSummary()
    }
    
    // MARK: - Helper Methods
    
    func updateSummary() {
        var caloriesADay : Float = 0.0
        var fatADay : Float = 0.0
        
        for object in DiaryTableViewViewModel.sharedInstance.meals {
            guard let meal = object as? Meal else { return }
            caloriesADay += meal.calories
            fatADay += meal.fat
        }
        
        self.caloriesADayLabel.text = String(format: "%d/2500", Int(caloriesADay))
        self.fatLabel.text = String(format: "%d g", Int(fatADay))
    }
    
    private func setupUI() {
        
        // Rounden corners on top
        self.view.setRoundedTopCorners()
        
        // Top Gradient
        self.view.setGradientBackground(startColor: UIColor(red:0.06, green:0.52, blue:0.84, alpha:1.0), endColor: UIColor(red:0.35, green:0.60, blue:0.97, alpha:1.0))
        
        // Rounded corners for food image
        self.diaryImageView.setCircledCorners()
        
        // Slightly rounded corners fro change weight goal button
        self.changeGoalButton.layer.cornerRadius = 5
        self.changeGoalButton.clipsToBounds = true
    }
    
    // MARK: - Actions
    
    @IBAction func changeGoalButtonClicked(_ sender: Any) {
    }
}
