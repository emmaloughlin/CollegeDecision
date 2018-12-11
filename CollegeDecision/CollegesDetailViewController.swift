//
//  CollegesDetailViewController.swift
//  CollegeDecision
//
//  Created by Emma Loughlin on 12/1/18.
//  Copyright © 2018 Emma Loughlin. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit

class CollegesDetailViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!


    @IBOutlet weak var averageLocationRatingLabel: UILabel!
    @IBOutlet weak var averageNightlifeRatingLabel: UILabel!
    @IBOutlet weak var averageFoodRatingLabel: UILabel!
    @IBOutlet weak var averageProfessorRatingLabel: UILabel!
    @IBOutlet weak var averageDiversityRatingLabel: UILabel!
    @IBOutlet weak var averageSportsRatingLabel: UILabel!
    @IBOutlet weak var averageWeatherRatingLabel: UILabel!
    @IBOutlet weak var averageGreekLifeRatingLabel: UILabel!
    @IBOutlet weak var averageClassroomSizeRatingLabel: UILabel!
    @IBOutlet weak var averageWorkloadRatingLabel: UILabel!

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!

    
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    
    var college: College!
    var reviews: Reviews!
    let regionDistance: CLLocationDistance = 1000 // a little less than a mile

    override func viewDidLoad() {
        super.viewDidLoad()
        
            let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
            tap.cancelsTouchesInView = false
            self.view.addGestureRecognizer(tap)
        
            reviews = Reviews()
            // mapView.delegate = self  // whats wrong w this
            tableView.delegate = self
            tableView.dataSource = self
        
            if college == nil {
                    college = College()

                nameField.addBorder(width: 0.5, radius: 5, color: .black)
                addressField.addBorder(width: 0.5, radius: 5.0, color: .black)
            } else {
                nameField.isEnabled = false
                addressField.isEnabled = false
                nameField.backgroundColor = UIColor.clear
                addressField.backgroundColor = UIColor.white
                saveBarButton.title = ""
                cancelBarButton.title = ""
                navigationController?.setToolbarHidden(true, animated: true)
        }
        
        reviews = Reviews()
        
        let region = MKCoordinateRegion(center: college.coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(region, animated: true)
        
        updateUserInterface()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reviews.loadData(college: college) { 
            self.tableView.reloadData()
            
            
            if self.reviews.reviewArray.count > 0 {
                var locationTotal = 0
                var nightlifeTotal = 0
                var foodTotal = 0
                var professorTotal = 0
                var diversityTotal = 0
                var sportsTotal = 0
                var weatherTotal = 0
                var greekLifeTotal = 0
                var classroomSizeTotal = 0
                var workloadTotal = 0
                for review in self.reviews.reviewArray {
                    locationTotal = locationTotal + review.locationRating
                    nightlifeTotal = nightlifeTotal + review.nightlifeRating
                    foodTotal = foodTotal + review.foodRating
                    professorTotal = professorTotal + review.professorRating
                    diversityTotal = diversityTotal + review.diversityRating
                    sportsTotal = sportsTotal + review.sportsRating
                    weatherTotal = weatherTotal + review.weatherRating
                    greekLifeTotal = greekLifeTotal + review.greekLifeRating
                    classroomSizeTotal = classroomSizeTotal + review.classroomSizeRating
                    workloadTotal = workloadTotal + review.workloadRating
                    
                }
                let locationAverage = Double(locationTotal) / Double(self.reviews.reviewArray.count)
                let nightlifeAverage = Double(nightlifeTotal) / Double(self.reviews.reviewArray.count)
                let foodAverage = Double(foodTotal) / Double(self.reviews.reviewArray.count)
                let professorAverage = Double(professorTotal) / Double(self.reviews.reviewArray.count)
                let diversityAverage = Double(diversityTotal) / Double(self.reviews.reviewArray.count)
                let sportsAverage = Double(sportsTotal) / Double(self.reviews.reviewArray.count)
                let weatherAverage = Double(weatherTotal) / Double(self.reviews.reviewArray.count)
                let greekLifeAverage = Double(greekLifeTotal) / Double(self.reviews.reviewArray.count)
                let classroomSizeAverage = Double(classroomSizeTotal) / Double(self.reviews.reviewArray.count)
                let workloadAverage = Double(workloadTotal) / Double(self.reviews.reviewArray.count)
                self.averageLocationRatingLabel.text = "\(locationAverage.roundTo(places: 1))"
                self.averageNightlifeRatingLabel.text = "\(nightlifeAverage.roundTo(places: 1))"
                self.averageFoodRatingLabel.text = "\(foodAverage.roundTo(places: 1))"
                self.averageProfessorRatingLabel.text = "\(professorAverage.roundTo(places: 1))"
                self.averageDiversityRatingLabel.text = "\(diversityAverage.roundTo(places: 1))"
                self.averageSportsRatingLabel.text = "\(sportsAverage.roundTo(places: 1))"
                self.averageWeatherRatingLabel.text = "\(weatherAverage.roundTo(places: 1))"
                self.averageGreekLifeRatingLabel.text = "\(greekLifeAverage.roundTo(places: 1))"
                self.averageClassroomSizeRatingLabel.text = "\(classroomSizeAverage.roundTo(places: 1))"
                self.averageWorkloadRatingLabel.text = "\(workloadAverage.roundTo(places: 1))"
                
                
            } else {
                self.averageLocationRatingLabel.text = "-.-"
                self.averageNightlifeRatingLabel.text = "-.-"
                self.averageFoodRatingLabel.text = "-.-"
                self.averageProfessorRatingLabel.text = "-.-"
                self.averageDiversityRatingLabel.text = "-.-"
                self.averageSportsRatingLabel.text = "-.-"
                self.averageWeatherRatingLabel.text = "-.-"
                self.averageGreekLifeRatingLabel.text = "-.-"
                self.averageClassroomSizeRatingLabel.text = "-.-"
                self.averageWorkloadRatingLabel.text = "-.-"
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        college.name = nameField.text!
        college.address = addressField.text!
        switch segue.identifier ?? "" {
        case "AddReview" :
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.viewControllers.first as! ReviewTableViewController
            destination.college = college
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        case "ShowCollege" :
            let destination = segue.destination as! ReviewTableViewController
            destination.college = college
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.review = reviews.reviewArray[selectedIndexPath.row]
        default:
            print("*** ERROR")
        }
    }


    
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        saveBarButton.isEnabled = !(nameField.text == "")
    }
    

        
    @IBAction func textFieldReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
        college.name = nameField.text!
        college.address = addressField.text!
        updateUserInterface()
    }
    
    func disableTextEditing() {
        nameField.backgroundColor = UIColor.clear
        addressField.backgroundColor = UIColor.clear
        nameField.isEnabled = false
        addressField.isEnabled = false
        nameField.noBorder()
        addressField.noBorder()
    }
    
    func saveCancelAlert(title: String, message: String, segueIdentifier: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            self.college.saveData { success in
                self.saveBarButton.title = "Done"
                self.cancelBarButton.title = ""
                self.navigationController?.setToolbarHidden(true, animated: true)
                self.disableTextEditing()
                self.performSegue(withIdentifier: segueIdentifier, sender: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func updateUserInterface() {
        nameField.text = college.name
        addressField.text = college.address
        updateMap()
    }
    
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(college)
        mapView.setCenter(college.coordinate, animated: true)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func reviewButtonPressed(_ sender: UIButton) {
        if college.documentID == "" {
            saveCancelAlert(title: "This college has not been rated before!", message: "Save this college location so you can be the first to rate!", segueIdentifier: "AddReview")
        } else {
            
            performSegue(withIdentifier: "AddReview", sender: nil)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if nameField.text == nil || nameField.text == "" {
            let alertController = UIAlertController(title: "Error!", message: "Please enter a college before saving for press cancel.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            college.name = nameField.text!
            college.address = addressField.text!
            college.saveData { success in
                if success {
                    self.leaveViewController()
                } else {
                    print("*** ERROR: Please save data.")
                }
            }
        }
    }
    
    @IBAction func lookupCollegePressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        leaveViewController()
        
    }
}



extension CollegesDetailViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        college.name = place.name
        college.address = place.formattedAddress ?? ""
        college.coordinate = place.coordinate
        dismiss(animated: true, completion: nil)
        updateUserInterface()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension CollegesDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! CollegeReviewsTableViewCell
        cell.review = reviews.reviewArray[indexPath.row]
        return cell
    }
}
