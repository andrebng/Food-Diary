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
//
//  FoodDetailViewController.swift
//  Food Snap
//
//  Created by Andre Nguyen on 7/27/17.
//  Copyright © 2017 Idiots. All rights reserved.
//

import Foundation
import UIKit

class FoodDetailViewController : UIViewController {
    
    var delegate : AddToLibraryDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    // Array of food items
    var foodList: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor.clear
        
        puts("Foodlist: \(self.foodList)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension FoodDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell") as! CardCell
        
        let item = self.foodList[indexPath.row] as! NSDictionary
        let fields = item["fields"] as! NSDictionary
        puts("Item: \(fields)")
        cell.cardTitle.text = fields["item_name"] as? String
        cell.caloriesLabel.text = "\(fields["nf_calories"] as? Float ?? 0)"
        cell.fatLabel.text = "\(fields["nf_total_fat"] as? Float ?? 0) g"
        cell.delegate = self
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

extension FoodDetailViewController : CardCellDelegate {
    
    func chooseNutrition(foodName: String, calories: Float, fat: String) {
        self.delegate?.setNutritionData(foodName: foodName, calories: calories, fat: fat)
        self.navigationController?.popViewController(animated: true)
    }
    
}
