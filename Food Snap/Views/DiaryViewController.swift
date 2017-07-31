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


//  DiaryViewController.swift
//  Food Snap
//
//  Created by Andre Nguyen on 7/28/17.
//  Copyright © 2017 Idiots. All rights reserved.
//

import Foundation
import UIKit

protocol DiaryDelegate {
    
    func addToDiary(entry: NSMutableDictionary)
    
}

@available(iOS 11.0, *)
class DiaryViewController : UIViewController {
    
    //MARK: Vars for gradient background
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    let topGradient : CAGradientLayer = CAGradientLayer()
    let bottomGradient : CAGradientLayer = CAGradientLayer()
    
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weightImage: UIImageView!
    @IBOutlet weak var weightGoalLabel: UILabel!
    @IBOutlet weak var weightGoalValueLabel: UILabel!
    @IBOutlet weak var changeGoalButton: UIButton!
    @IBOutlet weak var caloriesADayLabel: UILabel!
    @IBOutlet weak var caloriesADayValueLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var fatValueLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightValueLabel: UILabel!
    @IBOutlet weak var addToDiary: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Vars
    var diary : NSMutableArray = NSMutableArray()
    
    //MARK: ViewController Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBackground()
        
        self.caloriesADayValueLabel.text = "0 / 2500"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor.clear
        self.tableView.backgroundColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddToDiarySegue" {
            let vc = (segue.destination as? UINavigationController)?.viewControllers.first as? AddToLibraryViewController
            vc?.diaryDelegate = self
        }
    }
    
    //MARK: Helper Functions
    
    /// Updates calories based on table items
    func updateCaloriesADay() {
        
        var caloriesADay = 0.0
        var fatADay = 0.0
        
        for (_, item) in self.diary.enumerated() {
            
            let entry = item as? NSDictionary
            
            var calories = entry!["calories"] as? String
            var fat = entry!["fat"] as? String
            
            calories = (calories?.hasSuffix("kcal"))! ? calories?.substring(to: (calories?.index((calories?.endIndex)!, offsetBy: -5))!) : calories
            fat = (fat?.hasSuffix("g"))! ? fat?.substring(to: (fat?.index((fat?.endIndex)!, offsetBy: -2))!) : fat
            
            caloriesADay += Double(calories!)!
            fatADay += Double(fat!)!
            
            self.caloriesADayValueLabel.text = "\(Int(caloriesADay))/2500"
            self.fatValueLabel.text = "\(Int(fatADay))g"
        }
        
    }
    
    //MARK: UI Setup
    func setupBackground() {
        
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
        
        // Rounded corners for food image
        self.weightImage.layer.masksToBounds = false
        self.weightImage.layer.cornerRadius = self.weightImage.frame.height/2
        self.weightImage.clipsToBounds = true
        
        // Slightly rounded corners fro change weight goal button
        self.changeGoalButton.layer.cornerRadius = 5
        self.changeGoalButton.clipsToBounds = true
        
        // Circled button for add button
        self.addToDiary.backgroundColor = UIColor.clear
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.addToDiary.bounds, cornerRadius: self.addToDiary.frame.height/2).cgPath
        shadowLayer.fillColor = self.changeGoalButton.backgroundColor?.cgColor
        
        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowLayer.shadowOpacity = 0.8
        shadowLayer.shadowRadius = 2
        
        self.addToDiary.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    //MARK: Actions
    
    @IBAction func changeGoalClicked(_ sender: Any) {
    }
    
    @IBAction func clickedAddToDiary(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddToDiarySegue", sender: self)
        
    }
    
}

//MARK: DiaryDelegate
@available(iOS 11.0, *)
extension DiaryViewController : DiaryDelegate {
    
    func addToDiary(entry: NSMutableDictionary) {
        self.diary.add(entry)
        self.tableView.reloadData()
        
        self.updateCaloriesADay()
    }
    
}

//MARK: UITableView Delegate & Datasource
@available(iOS 11.0, *)
extension DiaryViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.diary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionCardCell") as! NutritionCard
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        let item = self.diary[indexPath.row] as? NSDictionary
        
        let name = item?["foodName"] as? String
        var calories = item?["calories"] as? String
        var fat = item?["fat"] as? String
        
        calories = (calories?.hasSuffix("kcal"))! ? calories?.substring(to: (calories?.index((calories?.endIndex)!, offsetBy: -5))!) : calories
        fat = (fat?.hasSuffix("g"))! ? fat?.substring(to: (fat?.index((fat?.endIndex)!, offsetBy: -2))!) : fat
        
        cell.foodLetterLabel.text = "\((item?["foodName"] as? String)?.characters.first ?? "F")"
        cell.foodNameLabel.text = name
        cell.caloriesValueLabel.text = calories
        cell.fatValueLabel.text = fat
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}

//MARK: UIView Extension
@available(iOS 11.0, *)
extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
