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


//  AddToLibraryViewController.swift
//  Food Snap
//
//  Created by Andre Nguyen on 7/30/17.
//  Copyright © 2017 Idiots. All rights reserved.
//

import Foundation
import UIKit
import CoreML

//UNSUED: XOR
precedencegroup BooleanPrecedence { associativity: left }
infix operator ^^ : BooleanPrecedence

func ^^(lhs: Bool, rhs: Bool) -> Bool {
    return lhs != rhs
}

//MARK: AddToLibraryDelegate Protocol
protocol AddToLibraryDelegate {
    func setNutritionData(foodName: String, calories: Float, fat: String)
}

@available(iOS 11.0, *)
class AddToLibraryViewController : UIViewController, UINavigationControllerDelegate {
    
    //MARK: Outlets
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
    
    //MARK: Vars
    var diaryDelegate : DiaryDelegate?
    var delegate : AddToLibraryDelegate?
    
    // CoreML
    var model: Inceptionv3!
    
    // Vars
    var foodList : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.caloriesTextField.delegate = self
        self.fatTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        model = Inceptionv3()
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NutritionSelectionSegue" {
            let vc = segue.destination as! FoodDetailViewController
            vc.delegate = self
            vc.foodList = self.foodList
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
    
    //MARK: UI Setup
    func setupUI() {
        
        // Rounden corners on top
        let screenSize: CGRect = UIScreen.main.bounds
        let HeightFloat :CGFloat = screenSize.height
        let WidthFloat :CGFloat = screenSize.width
        
        let NewRect :CGRect = CGRect(x: 0, y: 20, width: WidthFloat, height: HeightFloat)
        let maskPath = UIBezierPath(roundedRect: NewRect,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 10, height: 10))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        shape.strokeColor = UIColor.clear.cgColor
        shape.lineJoin = kCALineJoinRound
        
        self.topView.layer.mask = shape
        
        // Top Gradient
        let topGradientStartColor = UIColor(red:0.06, green:0.52, blue:0.84, alpha:1.0)
        let topGradientEndColor = UIColor(red:0.35, green:0.60, blue:0.97, alpha:1.0)
        
        self.topView.setGradientBackground(colorOne: topGradientStartColor, colorTwo: topGradientEndColor)
        
        // Bottom Gradient
        let bottomGradientStartColor = UIColor.white
        let bottomGradientEndColor = UIColor(red:0.80, green:0.78, blue:0.78, alpha:1.0)
        
        self.bottomView.setGradientBackground(colorOne: bottomGradientStartColor, colorTwo: bottomGradientEndColor)
        
        self.ctaButton.layer.cornerRadius = 5
        self.ctaButton.clipsToBounds = true
        
    }
    
    //MARK: Actions
    @IBAction func clickedCamera(_ sender: Any) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        
        present(cameraPicker, animated: true)
        
    }
    
    @IBAction func clickedLibrary(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
        
    }
    
    @IBAction func clickedCTA(_ sender: Any) {
        
        puts("NAME: \(self.nameOfDishTextView.text)")
        puts("CAL: \(self.caloriesTextField.text ?? "0")")
        puts("FAT: \(self.fatTextField.text ?? "0")")
        
        let hasNameValue = (self.nameOfDishTextView.text.characters.count > 0 && self.nameOfDishTextView.text != "Name of Food / Dish") ? true : false
        let hasCaloriesValue = ((self.caloriesTextField.text ?? "").characters.count > 0) ? true : false
        let hasFatValue = ((self.fatTextField.text ?? "").characters.count > 0) ? true : false
        
        if (!hasNameValue && !hasCaloriesValue && !hasFatValue) {
            self.dismiss(animated: true, completion: nil)
        }
        else if (hasNameValue && hasCaloriesValue && hasFatValue) {
            
            let entry = NSMutableDictionary()
            entry.setValue(self.nameOfDishTextView.text, forKey: "foodName")
            entry.setValue(self.caloriesTextField.text ?? "0", forKey: "calories")
            entry.setValue(self.fatTextField.text ?? "0", forKey: "fat")
            
            self.diaryDelegate?.addToDiary(entry: entry)
            self.dismiss(animated: true, completion: nil)
        }
        else {
            // not all values provided
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

//MARK: AddToLibraryDelegate
@available(iOS 11.0, *)
extension AddToLibraryViewController : AddToLibraryDelegate {
    
    func setNutritionData(foodName: String, calories: Float, fat: String) {
        
        self.nameOfDishTextView.text = foodName
        self.caloriesTextField.text = "\(calories) kcal"
        self.fatTextField.text = "\(fat)"
        
    }
    
}

//MARK: UIImagePickerControllerDelegate
@available(iOS 11.0, *)
extension AddToLibraryViewController : UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
//        classifier.text = "Analyzing Image..."
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
//        imageView.image = newImage
        
        // perform object recognition
        guard let prediction = try? model.prediction(image: pixelBuffer!) else {
            return
        }
        
        let firstItem = prediction.classLabel.components(separatedBy: ",")[0]
        
        NutritionixAPI.nutritionInfo(foodName: firstItem) { (success, result) in
            if success {
                puts("Results: \(result)")
                puts("Results retrieved")
                
                self.foodList = result
                
                self.performSegue(withIdentifier: "NutritionSelectionSegue", sender: self)
            }
            else {
                puts("No results")
            }
        }
    }
}

//MARK: UITextFieldDelegate
@available(iOS 11.0, *)
extension AddToLibraryViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return false
    }
    
}
