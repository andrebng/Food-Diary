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
