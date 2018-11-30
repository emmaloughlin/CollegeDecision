//
//  Double+roundTo.swift
//  CollegeDecision
//
//  Created by Emma Loughlin on 11/30/18.
//  Copyright © 2018 Emma Loughlin. All rights reserved.
//

import Foundation


extension Double {
    
    func roundTo(places: Int) -> Double {
        let tenToPower = pow(10.0, Double((places >= 0 ? places : 0 )))
        let roundedValue = (self * tenToPower).rounded() / tenToPower
        return roundedValue
    }
}



