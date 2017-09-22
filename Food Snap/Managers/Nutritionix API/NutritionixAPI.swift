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


//  NutritionixAPI.swift
//  Food Snap
//
//  Created by Andre Nguyen on 7/26/17.
//  Copyright © 2017 Andre Nguyen. All rights reserved.
//

import Foundation
import Alamofire

enum DataManagerError: Error {
    case unknown
    case failedRequest
    case invalidResponse
}

class NutritionixAPI : NSObject {
    
    typealias NutritionCompletionHandler = ([Meal]?, DataManagerError?) -> ()
    
    // MARK: - Properties
    
    // MARK: - Public Interface
    
    /// Returns nutrition data based on food name
    ///
    /// - Parameters:
    ///   - foodName: name of food as string
    ///   - completion: completion handler once api returned data
    func nutritionInfo(foodName: String, completion: @escaping NutritionCompletionHandler) {
        
        let url = "https://api.nutritionix.com/v1_1/search/\(foodName)?fields=item_name%2Citem_id%2Cbrand_name%2Cnf_calories%2Cnf_total_fat&appId=\(API.APPLICATION_ID)&appKey=\(API.APPLICATION_KEY)"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            self.didFetchFoodData(response: response, completion: completion)
        }
        
    }
    
    // MARK: - Helper Methods
    
    private func didFetchFoodData(response: DataResponse<Any>, completion: NutritionCompletionHandler) {
        
        switch response.result {
        case .success:
            
            if response.response?.statusCode == 200 {
                
                let result_dict = response.result.value as! NSDictionary
                let result_array = result_dict["hits"] as! NSArray
                
                let meals = mapToMealArray(jsonDictionaries: result_array)
                
                completion(meals, nil)
            }
            else {
                completion(nil, .failedRequest)
            }
            
            break
        case .failure:
            completion(nil, .failedRequest)
            break
        }
    }
    
    private func mapToMealArray(jsonDictionaries: NSArray) -> [Meal] {
        
        let mutableArray = NSMutableArray()
        
        for object in jsonDictionaries {
            
            if let dict = object as? NSDictionary {
                guard let fields = dict["fields"] as? NSDictionary else { return [] }
                guard let name = fields["item_name"] as? String else { return [] }
                guard let calories = fields["nf_calories"] as? Float else { return [] }
                guard let fat = fields["nf_total_fat"] as? Float else { return [] }
                
                mutableArray.add(Meal(name: name, calories: calories, fat: fat))
            }
        }
        
        guard let mealArray = mutableArray as? [Meal] else { return [] }
        
        return mealArray
    }
    
}
