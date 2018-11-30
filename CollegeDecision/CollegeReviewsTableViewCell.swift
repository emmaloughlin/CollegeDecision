//
//  CollegeReviewsTableViewCell.swift
//  CollegeDecision
//
//  Created by Emma Loughlin on 11/28/18.
//  Copyright © 2018 Emma Loughlin. All rights reserved.
//

import UIKit

class CollegeReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewTitleLabel: UILabel!
    
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    var review: Review! {
        didSet {
            reviewTitleLabel.text = review.title
            reviewTextLabel.text = review.text
           
        }
    }
}
