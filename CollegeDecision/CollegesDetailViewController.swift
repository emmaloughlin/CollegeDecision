//
//  CollegesDetailViewController.swift
//  CollegeDecision
//
//  Created by Emma Loughlin on 12/1/18.
//  Copyright © 2018 Emma Loughlin. All rights reserved.
//

import UIKit

class CollegesDetailViewController: UIViewController {
//
//    IBOutlet weak var nameField: UITextField!
//    IBOutlet weak var addressField: UITextField!
//
//
//    IBOutlet weak var averageLocationRatingLabel: UILabel!
//    IBOutlet weak var averageNightlifeRatingLabel: UILabel!
//    IBOutlet weak var averageFoodRatingLabel: UILabel!
//    IBOutlet weak var averageProfessorRatingLabel: UILabel!
//    IBOutlet weak var averageDiversityRatingLabel: UILabel!
//    IBOutlet weak var averageSportsRatingLabel: UILabel!
//    IBOutlet weak var averageWeatherRatingLabel: UILabel!
//    IBOutlet weak var averageGreekLifeRatingLabel: UILabel!
//    IBOutlet weak var averageClassroomSizeRatingLabel: UILabel!
//    IBOutlet weak var averageWorkloadRatingLabel: UILabel!
//
//
//    IBOutlet weak var tableView: UITableView!
//    IBOutlet weak var mapView: MKMapView!
//    IBOutlet weak var saveBarButton: UIBarButtonItem!
//
//
//
//
//    IBOutlet weak var cancelBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    
    
    
    

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
}
