//
//  FoodViewViewModel.swift
//  Food Snap
//
//  Created by Andre Nguyen on 9/20/17.
//  Copyright © 2017 Idiots. All rights reserved.
//

import Foundation

struct MealViewViewModel {
    
    // MARK: - Properties
    
    var meal: Meal
    
    // MARK: -
    
    var name: String {
        return meal.name
    }
    
    var calories: Float {
        return meal.calories
    }
    
    var caloriesAsString: String {
        return String(meal.calories)
    }
    
    var fat: Float {
        return meal.fat
    }
    
    var fatAsString: String {
        return String(meal.fat)
    }
    
}
