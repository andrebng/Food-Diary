//
//  NewMealViewViewModel.swift
//  Food Snap
//
//  Created by Andre Nguyen on 9/21/17.
//  Copyright © 2017 Idiots. All rights reserved.
//

import UIKit

enum ViewModelState {
    case isEmpty
    case isMissingValue
    case notEmpty
}

@available(iOS 11.0, *)
class NewMealViewViewModel {
    
    // MARK: - Properties
    
    var name: String = "" {
        didSet {
            didUpdateName?(name)
        }
    }
    
    var calories: Float = 0 {
        didSet {
            caloriesAsString = String(format: "%.0f kcal", calories)
        }
    }
    
    var caloriesAsString: String = "" {
        didSet {
            didUpdateCaloriesString?(caloriesAsString)
        }
    }
    
    var fat: Float = 0 {
        didSet {
            fatAsString = String(format: "%.0f g", fat)
        }
    }
    
    var fatAsString: String = "" {
        didSet {
            didUpdateFatString?(fatAsString)
        }
    }
    
    // MARK: -
    
    var image: UIImage = UIImage() {
        didSet {
            performImageRecognition(image: image)
        }
    }
    
    // MARK: - Public Interface
    
    var didUpdateName: ((String) -> ())?
    var didUpdateCaloriesString: ((String) -> ())?
    var didUpdateFatString: ((String) -> ())?
    
    // MARK: -
    
    var queryingDidChange: ((Bool) -> ())?
    var didRecognizeImages: (([Meal]) -> ())?
    
    // MARK: - Private
    
    private lazy var mlManager = MLManager()
    private lazy var nutritionixAPI = NutritionixAPI()
    
    private var querying: Bool = false {
        didSet {
            queryingDidChange?(querying)
        }
    }
    
    // MARK - Public Methods
    
    func toMeal() -> Meal? {
        if (self.state() == .isEmpty || self.state() == .isMissingValue) {
            return nil
        }
        return Meal(name: name, calories: calories, fat: fat)
    }
    
    func state() -> ViewModelState {
        let hasNameValue = (name.isEmpty && name != "Name of Food / Dish") ? false : true
        let hasCaloriesValue = caloriesAsString.isEmpty ? false : true
        let hasFatValue = fatAsString.isEmpty ? false : true
        
        if (!hasNameValue && !hasCaloriesValue && !hasFatValue) {
            return .isEmpty
        }
        else if (hasNameValue && hasCaloriesValue && hasFatValue) {
            return .notEmpty
        }
        return .isMissingValue
    }
    
    // MARK - Helper Methods
    
    func performImageRecognition(image: UIImage?) {
        guard let image = image else { return }
        
        querying = true
        
        let prediction = mlManager.predictionForImage(image: image)
        
        if let meal = prediction {
            nutritionixAPI.nutritionInfo(foodName: meal) { [weak self] (meals, error) in
                if let error = error {
                    print("Error forwarding meals (\(error)")
                }
                else {
                    self?.querying = false
                    if let meals = meals {
                        self?.didRecognizeImages?(meals)
                    }
                }
            }
        }
    }
    
}
