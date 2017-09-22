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


//  FoodDetailViewController.swift
//  Food Snap
//
//  Created by Andre Nguyen on 7/27/17.
//  Copyright © 2017 Andre Nguyen. All rights reserved.
//
import UIKit

//MARK: CardCellDelegate Protocol
protocol MealPredictionsDelegate {
    func chooseMeal(viewModel: MealViewViewModel)
}

class MealPredictionsViewController : UIViewController {
    
    static let segueIdentifier = "NutritionSelectionSegue"
    
    // MARK: - Properties
    
    var delegate : NewMealDelegate?
    
    // MARK: -
    
    var mealPredictions: [Meal]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor.clear
    }
    
}

// MARK: - UITableView Delegate, UITableView Datasource

extension MealPredictionsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = mealPredictions?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardCell.reuseIdentifier, for: indexPath) as? CardCell else {
            fatalError("Unexpected Table View Cell")
        }
        
        cell.delegate = self
        
        guard let meals = mealPredictions else { fatalError("Uninitialized meal predictions array") }
        
        let meal = meals[indexPath.row]
        cell.configure(viewModel: MealViewViewModel(meal: meal))
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

// MARK: - Meal Prediction Delegate

extension MealPredictionsViewController : MealPredictionsDelegate {
    func chooseMeal(viewModel: MealViewViewModel) {
        self.delegate?.setMealData(viewModel: viewModel)
        self.navigationController?.popViewController(animated: true)
    }
}
