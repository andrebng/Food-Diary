//
//  DiaryTableViewController.swift
//  Food Snap
//
//  Created by Andre Nguyen on 9/19/17.
//  Copyright © 2017 Idiots. All rights reserved.
//

import UIKit

// MARK: Diary Table

protocol DiaryTableDelegate {
    func addMealToDiary(meal: Meal)
}

@available(iOS 11.0, *)
class DiaryTableViewController: UIViewController {
    
    static let segueIdentifier = "EmbeddedDiaryTableViewControllerSegue"
    
    // MARK: - Properties
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var emptyStateView: UIView!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        
        setupUI()
        
        DiaryTableViewViewModel.sharedInstance.didUpdateMeals = { [unowned self] (meals) in
            self.tableView.reloadData()
        }
        
        // Setup Table View
        self.tableView.separatorColor = UIColor.clear
        self.tableView.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.emptyStateView.isHidden = (DiaryTableViewViewModel.sharedInstance.hasMeals) ? true : false
    }
    
    // MARK: - Helper Methods
    
    private func setupUI() {
        
        // Bottom Gradient
        let bottomGradientStartColor = UIColor.white
        let bottomGradientEndColor = UIColor(red:0.80, green:0.78, blue:0.78, alpha:1.0)
        
        self.view.setGradientBackground(startColor: bottomGradientStartColor, endColor: bottomGradientEndColor)
    }
}

// MARK: - Diary Table Delegate

@available(iOS 11.0, *)
extension DiaryTableViewController: DiaryTableDelegate {
    
    func addMealToDiary(meal: Meal) {
//        viewModel.meals.add(meal)
    }
    
}

// MARK: - UITable View Data Source

@available(iOS 11.0, *)
extension DiaryTableViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.emptyStateView.isHidden = (DiaryTableViewViewModel.sharedInstance.hasMeals) ? true : false
        
        return DiaryTableViewViewModel.sharedInstance.numberOfMeals
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NutritionCard.reuseIdentifier, for: indexPath) as? NutritionCard else {
            fatalError("Unexpected Table View Cell")
        }
        
        if let viewModel = DiaryTableViewViewModel.sharedInstance.viewModelForMeal(at: indexPath.row) {
            cell.configure(viewModel: viewModel)
        }
        
        return cell
    }
}

// MARK:- UITable View Delegate

@available(iOS 11.0, *)
extension DiaryTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
