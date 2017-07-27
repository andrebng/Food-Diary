//
//  NutritionixAPI.swift
//  Food Snap
//
//  Created by Andre Nguyen on 7/26/17.
//  Copyright © 2017 Idiots. All rights reserved.
//

import Foundation
import Alamofire

class NutritionixAPI : NSObject {
    
    static func nutritionInfo(foodName: String) {
        
        let url = "https://api.nutritionix.com/v1_1/search/\(foodName)?fields=item_name%2Citem_id%2Cbrand_name%2Cnf_calories%2Cnf_total_fat&appId=\(Constants.APPLICATION_ID)&appKey=\(Constants.APPLICATION_KEY)"
//        let headers = ["sth": "sth else"]
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            
//            puts("Response: \(response)")
            
            switch response.result {
            case .success:
                
                if response.response?.statusCode == 200 {
                    puts("\(type(of: response.result.value))")
                    
                    let result_dict = response.result.value as! NSDictionary
                    let result_array = result_dict["hits"] as! NSArray

                    for res in result_array {
                        puts("Res: \(res)")
                    }
                }
                else {
                    puts("Status code: \(response.response?.statusCode ?? -1)")
                }
                
                break
            case .failure:
                break
            }
            
        }
        
    }
    
}
