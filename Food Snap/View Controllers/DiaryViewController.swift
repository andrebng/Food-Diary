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
//  Copyright © 2017 Andre Nguyen. All rights reserved.
//

import Foundation
import UIKit

protocol DiaryDelegate {
    
    func addToDiary(entry: NSMutableDictionary)
    func addFoodToDiary(food: Meal)
    
}

@available(iOS 11.0, *)
class DiaryViewController : UIViewController {
    
    // MARK: - Properties
    
    //MARK: Outlets
    @IBOutlet weak var addToDiary: UIButton!
    
    // MARK: - ViewController Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addToDiary.setCircledCorners()
    }
    
    // MARK: - Actions
    
    @IBAction func changeGoalClicked(_ sender: Any) { }
    
    @IBAction func clickedAddToDiary(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddToDiarySegue", sender: self)
    }
    
}
