//
//  DiaryTableViewViewModel.swift
//  Food Snap
//
//  Created by Andre Nguyen on 9/20/17.
//  Copyright © 2017 Idiots. All rights reserved.
//

import Foundation

class DiaryTableViewViewModel {
    
    static let sharedInstance = DiaryTableViewViewModel()
    
    // MARK: - Properties
    
    var meals: NSMutableArray = NSMutableArray() {
        didSet {
            guard let meals = meals as? [Meal] else { return }
            if let handler = didUpdateMeals {
                handler(meals)
            }
        }
    }
    
    // MARK: -
    
    var hasMeals: Bool { return meals.count > 0 }
    var numberOfMeals: Int { return meals.count }
    var didUpdateMeals: (([Meal]) -> ())?
    
    // MARK: Public Interface
    
    func meal(at index: Int) -> Meal? {
        guard index < meals.count else { return nil }
        guard let meal = meals.object(at: index) as? Meal else { return nil }
        return meal
    }
    
    func viewModelForMeal(at index: Int) -> MealViewViewModel? {
        guard let meal = meal(at: index) else { return nil }
        return MealViewViewModel(meal: meal)
    }

}
