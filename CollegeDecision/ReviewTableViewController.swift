//
//  ReviewTableViewController.swift
//  CollegeDecision
//
//  Created by Emma Loughlin on 11/29/18.
//  Copyright © 2018 Emma Loughlin. All rights reserved.
//

import UIKit
import Firebase

class ReviewTableViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var deleteButton: UILabel!
    @IBOutlet weak var reviewTitleField: UITextField!
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    
    
    @IBOutlet weak var locationBackgroundView: UIView!
    @IBOutlet weak var nightLifeBackgroundView: UIView!
    @IBOutlet weak var foodBackgroundView: UIView!
    @IBOutlet weak var professorBackgroundView: UIView!
    @IBOutlet weak var diversityBackgroundView: UIView!
    @IBOutlet weak var sportsBackgroundView: UIView!
    @IBOutlet weak var weatherBackgroundView: UIView!
    @IBOutlet weak var greekLifeBackgroundView: UIView!
    @IBOutlet weak var classroomSizeBackgroundView: UIView!
    @IBOutlet weak var workloadBackgroundView: UIView!
    
    
    
    @IBOutlet var locationStar: [UIButton]!
    @IBOutlet var nightlifeStar: [UIButton]!
    @IBOutlet var foodStar: [UIButton]!
    @IBOutlet var professorStar: [UIButton]!
    @IBOutlet var diversityStar: [UIButton]!
    @IBOutlet var sportsStar: [UIButton]!
    @IBOutlet var weatherStar: [UIButton]!
    @IBOutlet var greekLifeStar: [UIButton]!
    @IBOutlet var classroomSizeStar: [UIButton]!
    @IBOutlet var workloadStar: [UIButton]!
    
    var college: College!
    var review: Review!
    var locationRating = 0{
        didSet {
            for starButton in locationStar {
                let image = UIImage(named: (starButton.tag < locationRating ? "star-filled": "star-empty"))
                starButton.setImage(image, for: .normal)
            }
            review.locationRating = locationRating
        }
    } 
    
    var nightlifeRating = 0{
        didSet {
            for starButton in nightlifeStar {
                let image = UIImage(named: (starButton.tag < nightlifeRating ? "star-filled": "star-empty"))
                starButton.setImage(image, for: .normal)
            }
            review.nightlifeRating = nightlifeRating
        }
    }
    
    var foodRating = 0{
        didSet {
            for starButton in foodStar {
                let image = UIImage(named: (starButton.tag < foodRating ? "star-filled": "star-empty"))
                starButton.setImage(image, for: .normal)
            }
            review.foodRating = foodRating
        }
    }
    
    var professorRating = 0{
        didSet {
            for starButton in professorStar {
                let image = UIImage(named: (starButton.tag < professorRating ? "star-filled": "star-empty"))
                starButton.setImage(image, for: .normal)
            }
            review.professorRating = professorRating
        }
    }
    
    var diversityRating = 0{
        didSet {
            for starButton in diversityStar {
                let image = UIImage(named: (starButton.tag < diversityRating ? "star-filled": "star-empty"))
                starButton.setImage(image, for: .normal)
            }
            review.diversityRating = diversityRating
        }
    }
    
    var sportsRating = 0{
        didSet {
            for starButton in sportsStar {
                let image = UIImage(named: (starButton.tag < sportsRating ? "star-filled": "star-empty"))
                starButton.setImage(image, for: .normal)
            }
            review.sportsRating = sportsRating
        }
    }
    
    var weatherRating = 0{
        didSet {
            for starButton in weatherStar {
                let image = UIImage(named: (starButton.tag < weatherRating ? "star-filled": "star-empty"))
                starButton.setImage(image, for: .normal)
            }
            review.weatherRating = weatherRating
        }
    }
    
    var greekLifeRating = 0{
        didSet {
            for starButton in greekLifeStar {
                let image = UIImage(named: (starButton.tag < greekLifeRating ? "star-filled": "star-empty"))
                starButton.setImage(image, for: .normal)
            }
            review.greekLifeRating = greekLifeRating
        }
    }
    
    var classroomSizeRating = 0{
        didSet {
            for starButton in classroomSizeStar {
                let image = UIImage(named: (starButton.tag < classroomSizeRating ? "star-filled": "star-empty"))
                starButton.setImage(image, for: .normal)
            }
            review.classroomSizeRating = classroomSizeRating
        }
    }
    
    var workloadRating = 0{
        didSet {
            for starButton in workloadStar {
                let image = UIImage(named: (starButton.tag < workloadRating ? "star-filled": "star-empty"))
                starButton.setImage(image, for: .normal)
            }
            review.workloadRating = workloadRating
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        guard (college) != nil else {
            print("*** ERROR: did not have a valid college.")
            return
        }
        if review == nil {
            review = Review()
        }
        updateUserInterface()
    }
    

    
    func updateUserInterface() {
        nameLabel.text = college.name
        
        locationRating = review.locationRating
        nightlifeRating = review.nightlifeRating
        foodRating = review.foodRating
        professorRating = review.professorRating
        diversityRating = review.diversityRating
        sportsRating = review.sportsRating
        weatherRating = review.weatherRating
        greekLifeRating = review.greekLifeRating
        classroomSizeRating = review.classroomSizeRating
        workloadRating = review.workloadRating
        reviewTitleField.text = review.title
        reviewTextView.text = review.text
//        enableDisableSaveButton()
        
        
        
        if review.documentID == "" { // This is a new review
            addBordersToEditableObjects()
        } else {
            if review.reviewerUserID == Auth.auth().currentUser?.email {
                self.navigationItem.leftItemsSupplementBackButton = false
                saveBarButton.title = "Update"
                addBordersToEditableObjects()
                deleteButton.isHidden = false
            } else {
                cancelBarButton.title = ""
                saveBarButton.title = ""

                for starButton in locationStar {
                    starButton.backgroundColor = UIColor.white
                    starButton.adjustsImageWhenDisabled = false
                    starButton.isEnabled = false
                    reviewTitleField.isEnabled = false
                    reviewTextView.isEditable = false
                    reviewTitleField.backgroundColor = UIColor.white
                    reviewTextView.backgroundColor = UIColor.white
                }
                for starButton in nightlifeStar {
                    starButton.backgroundColor = UIColor.white
                    starButton.adjustsImageWhenDisabled = false
                    starButton.isEnabled = false
                    reviewTitleField.isEnabled = false
                    reviewTextView.isEditable = false
                    reviewTitleField.backgroundColor = UIColor.white
                    reviewTextView.backgroundColor = UIColor.white
                }
                for starButton in foodStar {
                    starButton.backgroundColor = UIColor.white
                    starButton.adjustsImageWhenDisabled = false
                    starButton.isEnabled = false
                    reviewTitleField.isEnabled = false
                    reviewTextView.isEditable = false
                    reviewTitleField.backgroundColor = UIColor.white
                    reviewTextView.backgroundColor = UIColor.white
                }
                for starButton in professorStar {
                    starButton.backgroundColor = UIColor.white
                    starButton.adjustsImageWhenDisabled = false
                    starButton.isEnabled = false
                    reviewTitleField.isEnabled = false
                    reviewTextView.isEditable = false
                    reviewTitleField.backgroundColor = UIColor.white
                    reviewTextView.backgroundColor = UIColor.white
                }
                for starButton in diversityStar {
                    starButton.backgroundColor = UIColor.white
                    starButton.adjustsImageWhenDisabled = false
                    starButton.isEnabled = false
                    reviewTitleField.isEnabled = false
                    reviewTextView.isEditable = false
                    reviewTitleField.backgroundColor = UIColor.white
                    reviewTextView.backgroundColor = UIColor.white
                }
                for starButton in sportsStar {
                    starButton.backgroundColor = UIColor.white
                    starButton.adjustsImageWhenDisabled = false
                    starButton.isEnabled = false
                    reviewTitleField.isEnabled = false
                    reviewTextView.isEditable = false
                    reviewTitleField.backgroundColor = UIColor.white
                    reviewTextView.backgroundColor = UIColor.white
                }
                for starButton in weatherStar {
                    starButton.backgroundColor = UIColor.white
                    starButton.adjustsImageWhenDisabled = false
                    starButton.isEnabled = false
                    reviewTitleField.isEnabled = false
                    reviewTextView.isEditable = false
                    reviewTitleField.backgroundColor = UIColor.white
                    reviewTextView.backgroundColor = UIColor.white
                }
                for starButton in greekLifeStar {
                    starButton.backgroundColor = UIColor.white
                    starButton.adjustsImageWhenDisabled = false
                    starButton.isEnabled = false
                    reviewTitleField.isEnabled = false
                    reviewTextView.isEditable = false
                    reviewTitleField.backgroundColor = UIColor.white
                    reviewTextView.backgroundColor = UIColor.white
                }
                for starButton in classroomSizeStar {
                    starButton.backgroundColor = UIColor.white
                    starButton.adjustsImageWhenDisabled = false
                    starButton.isEnabled = false
                    reviewTitleField.isEnabled = false
                    reviewTextView.isEditable = false
                    reviewTitleField.backgroundColor = UIColor.white
                    reviewTextView.backgroundColor = UIColor.white
                }
                for starButton in workloadStar {
                    starButton.backgroundColor = UIColor.white
                    starButton.adjustsImageWhenDisabled = false
                    starButton.isEnabled = false
                    reviewTitleField.isEnabled = false
                    reviewTextView.isEditable = false
                    reviewTitleField.backgroundColor = UIColor.white
                    reviewTextView.backgroundColor = UIColor.white
                }
            }
        }
    }

    
    func addBordersToEditableObjects() {
        reviewTitleField.addBorder(width: 0.5, radius: 5.0, color: .black)
        reviewTextView.addBorder(width: 0.5, radius: 5.0, color: .black)
        locationBackgroundView.addBorder(width: 0.5, radius: 5.0, color: .black)
        nightLifeBackgroundView.addBorder(width: 0.5, radius: 5.0, color: .black)
        foodBackgroundView.addBorder(width: 0.5, radius: 5.0, color: .black)
        diversityBackgroundView.addBorder(width: 0.5, radius: 5.0, color: .black)
        sportsBackgroundView.addBorder(width: 0.5, radius: 5.0, color: .black)
        weatherBackgroundView.addBorder(width: 0.5, radius: 5.0, color: .black)
        greekLifeBackgroundView.addBorder(width: 0.5, radius: 5.0, color: .black)
        classroomSizeBackgroundView.addBorder(width: 0.5, radius: 5.0, color: .black)
        workloadBackgroundView.addBorder(width: 0.5, radius: 5.0, color: .black)
        foodBackgroundView.addBorder(width: 0.5, radius: 5.0, color: .black)
    }
    
//    func enableDisableSaveButton() {
//        if reviewTitleField.text != "" {
//            saveBarButton.isEnabled = true
//        } else {
//            saveBarButton.isEnabled = false
//        }
//    }
    
    func saveAndSegue() {
        review.title = reviewTitleField.text!
        review.text = reviewTextView.text!
        college.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Please save data.")
            }
        }
        review.saveData(college: college) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("error -")
            }
        }
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func locationStarPressed(_ sender: UIButton) {
        locationRating = sender.tag + 1
    }
    
    @IBAction func nightlifeStarPressed(_ sender: UIButton) {
        nightlifeRating = sender.tag + 1
    }
    
    @IBAction func foodStarPressed(_ sender: UIButton) {
        foodRating = sender.tag + 1
    }
    
    @IBAction func professorStarPressed(_ sender: UIButton) {
        professorRating = sender.tag + 1
    }
    
    @IBAction func diversityStarPressed(_ sender: UIButton) {
        diversityRating = sender.tag + 1
    }
    
    @IBAction func sportsStarPressed(_ sender: UIButton) {
        sportsRating = sender.tag + 1
    }
    
    @IBAction func weatherStarPressed(_ sender: UIButton) {
        weatherRating = sender.tag + 1
    }
    
    @IBAction func greekLifeStarPressed(_ sender: UIButton) {
        greekLifeRating = sender.tag + 1
    }
    
    @IBAction func classroomSizeStarPressed(_ sender: UIButton) {
        classroomSizeRating = sender.tag + 1
    }
    
    @IBAction func workloadStarPressed(_ sender: UIButton) {
        workloadRating = sender.tag + 1
    }
    
    
    @IBAction func reviewTitleChanged(_ sender: UITextField) {
//        enableDisableSaveButton()
    }
    
    @IBAction func returnTitleDonePressed(_ sender: UITextField) {
        saveAndSegue()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        review.deleteData(college: college) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        saveAndSegue()
    }
    
    }
    
    
    

