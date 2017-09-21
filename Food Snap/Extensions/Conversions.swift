//
//  String.swift
//  Food Snap
//
//  Created by Andre Nguyen on 9/21/17.
//  Copyright © 2017 Idiots. All rights reserved.
//
extension String {
    
    func toFloat() -> Float {
        guard let floatValue = Float(self) else { return 0 }
        return floatValue
    }
    
}
