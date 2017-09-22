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


//  AddToDiaryViewController.swift
//  Food Snap
//
//  Created by Andre Nguyen on 7/30/17.
//  Copyright © 2017 Andre Nguyen. All rights reserved.
//

import UIKit
import CoreML
import SwiftOverlays

// MARK: - New Meal Protocol
protocol NewMealDelegate {
    func setMealData(viewModel: MealViewViewModel)
}

@available(iOS 11.0, *)
class NewMealViewController : UIViewController, UINavigationControllerDelegate {
    
    static let segueIdentifier = "AddToDiarySegue"
    
    // MARK: - Properties
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nameOfDishLabel: UILabel!
    @IBOutlet weak var nameOfDishTextField: UITextField!
    @IBOutlet weak var nameOfDishTextView: UITextView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var ctaButton: UIButton!
    
    // MARK: -
    
    var viewModel: NewMealViewViewModel?
    
    // MARK: -
    
    var mealPredictions: [Meal]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI
        self.setupUI()
        
        // Init View Model
        viewModel = NewMealViewViewModel()
        
        viewModel?.didUpdateName = { [unowned self] (name) in
            self.nameOfDishTextView.text = self.viewModel?.name
        }
        
        viewModel?.didUpdateCaloriesString = { [unowned self] (calories) in
            self.caloriesTextField.text = self.viewModel?.caloriesAsString
        }
        
        viewModel?.didUpdateFatString = { [unowned self] (fat) in
            self.fatTextField.text = self.viewModel?.fatAsString
        }
        
        viewModel?.queryingDidChange = { [unowned self] (querying) in
            if querying {
                self.showWaitOverlayWithText("Analyzing Image...")
            }
            else {
                self.removeAllOverlays()
            }
        }
        
        viewModel?.didRecognizeImages = { [unowned self] (meals) in
            self.mealPredictions = meals
            self.performSegue(withIdentifier: MealPredictionsViewController.segueIdentifier, sender: self)
        }
        
        // Set Delegates & Tags
        self.nameOfDishTextView.delegate = self
        
        self.caloriesTextField.tag = 2
        self.fatTextField.tag = 3
        
        self.caloriesTextField.delegate = self
        self.fatTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MealPredictionsViewController.segueIdentifier {
            guard let vc = segue.destination as? MealPredictionsViewController else { return }
            vc.mealPredictions = self.mealPredictions
            vc.delegate = self
        }
    }
    
    // Hide keyboard on touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nameOfDishTextView.resignFirstResponder()
        self.caloriesTextField.resignFirstResponder()
        self.fatTextField.resignFirstResponder()
    }
    
    // MARK: - Helper Methods
    
    private func setupUI() {
        
        // Rounden corners on top
        self.topView.setRoundedTopCorners()
        
        // Top Gradient
        self.topView.setGradientBackground(startColor: UIColor(red:0.06, green:0.52, blue:0.84, alpha:1.0), endColor: UIColor(red:0.35, green:0.60, blue:0.97, alpha:1.0))
        
        // Bottom Gradient
        self.bottomView.setGradientBackground(startColor: UIColor.white, endColor: UIColor(red:0.80, green:0.78, blue:0.78, alpha:1.0))
        
        self.ctaButton.layer.cornerRadius = 5
        self.ctaButton.clipsToBounds = true
    }
    
    // MARK: - Action Methods
    
    @IBAction func clickedCamera(_ sender: Any) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.presentCamera(viewController: self)
    }
    
    @IBAction func clickedLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.presentPhotoLibrary(viewController: self)
    }
    
    @IBAction func clickedCTA(_ sender: Any) {
        
        if (viewModel?.state() == .isEmpty) {
            self.dismiss(animated: true, completion: nil)
        }
        else if (viewModel?.state() == .isMissingValue) {
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (viewModel?.state() == .notEmpty) {
            
            let mutableMeals = DiaryTableViewViewModel.sharedInstance.meals
            guard let meal = viewModel?.toMeal() else { return }
            mutableMeals.add(meal)
            
            DiaryTableViewViewModel.sharedInstance.meals = mutableMeals
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - New Meal Delegate

@available(iOS 11.0, *)
extension NewMealViewController : NewMealDelegate {
    
    func setMealData(viewModel: MealViewViewModel) {
        self.viewModel?.name = viewModel.name
        self.viewModel?.calories = viewModel.calories
        self.viewModel?.fat = viewModel.fat
    }
}

// MARK: - UIImage Picker Controller Delegate

@available(iOS 11.0, *)
extension NewMealViewController : UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
        
        viewModel?.image = image
    }
}

// MARK: - Text Field Delegate

@available(iOS 11.0, *)
extension NewMealViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if textField.tag == 2 {
            viewModel?.calories = text.toFloat()
        }
        else if textField.tag == 3 {
            viewModel?.fat = text.toFloat()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
    
}

// MARK: - Text View Delegate

@available(iOS 11.0, *)
extension NewMealViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel?.name = textView.text
    }
}
