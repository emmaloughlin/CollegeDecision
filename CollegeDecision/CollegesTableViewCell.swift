//
//  CollegesTableViewCell.swift
//  CollegeDecision
//
//  Created by Emma Loughlin on 11/28/18.
//  Copyright © 2018 Emma Loughlin. All rights reserved.
//

import UIKit

class CollegesTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    
    
    var college: College! {
        didSet {
            nameLabel.text = college.name
            
            
        }
    }
}
