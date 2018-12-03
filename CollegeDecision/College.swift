//
//  College.swift
//  CollegeDecision
//
//  Created by Emma Loughlin on 11/28/18.
//  Copyright © 2018 Emma Loughlin. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import MapKit

class College: NSObject, MKAnnotation {
    
    var name: String
    var address: String?
    var coordinate: CLLocationCoordinate2D
    var averageLocationRating: Double
    var averageNightlifeRating: Double
    var averageFoodRating: Double
    var averageProfessorRating: Double
    var averageDiversityRating: Double
    var averageSportsRating: Double
    var averageWeatherRating: Double
    var averageGreekLifeRating: Double
    var averageClassroomSizeRating: Double
    var averageWorkloadRating: Double
    var numberOfReviews: Int
    var postingUserID: String
    var documentID: String
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var title: String? {
        return name
    }
    
    var addressTitle: String? {
        return address
    }
    
    var dictionary: [String: Any] {
        return ["name": name, "address": address!, "longitude": longitude, "latitude": latitude, "averageLocationRating": averageLocationRating,"averageNightlifeRating": averageNightlifeRating,"averageFoodRating": averageFoodRating,"averageProfessorRating": averageProfessorRating,"averageDiversityRating": averageDiversityRating,"averageSportsRating": averageSportsRating,"averageWeatherRating": averageWeatherRating,"averageGreekLifeRating": averageGreekLifeRating,"averageClassroomSizeRating": averageClassroomSizeRating,"averageWorkloadRating": averageWorkloadRating, "numberOfReviews": numberOfReviews, "postingUserID": postingUserID]
    }
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, averageLocationRating: Double, averageNightlifeRating: Double, averageFoodRating: Double, averageProfessorRating: Double, averageDiversityRating: Double, averageSportsRating: Double, averageWeatherRating: Double, averageGreekLifeRating: Double, averageClassroomSizeRating: Double, averageWorkloadRating: Double, numberOfReviews: Int, postingUserID: String, documentID: String) {
        
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.averageLocationRating = averageLocationRating
        self.averageNightlifeRating = averageNightlifeRating
        self.averageFoodRating = averageFoodRating
        self.averageProfessorRating = averageProfessorRating
        self.averageDiversityRating = averageDiversityRating
        self.averageSportsRating = averageSportsRating
        self.averageWeatherRating = averageWeatherRating
        self.averageGreekLifeRating = averageGreekLifeRating
        self.averageClassroomSizeRating = averageClassroomSizeRating
        self.averageWorkloadRating = averageWorkloadRating
        self.numberOfReviews = numberOfReviews
        self.postingUserID = postingUserID
        self.documentID = documentID
        
    }
    
    convenience override init() {
        self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), averageLocationRating: 0.0, averageNightlifeRating: 0.0, averageFoodRating: 0.0, averageProfessorRating: 0.0, averageDiversityRating: 0.0, averageSportsRating: 0.0, averageWeatherRating: 0.0, averageGreekLifeRating: 0.0, averageClassroomSizeRating: 0.0, averageWorkloadRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let longitude = dictionary["longitude"] as! CLLocationDegrees? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let averageLocationRating = dictionary["averageLocationRating"] as! Double? ?? 0.0
        let averageNightlifeRating = dictionary["averageNightlifeRating"] as! Double? ?? 0.0
        let averageFoodRating = dictionary["averageFoodRating"] as! Double? ?? 0.0
        let averageProfessorRating = dictionary["averageProfessorRating"] as! Double? ?? 0.0
        let averageDiversityRating = dictionary["averageDiversityRating"] as! Double? ?? 0.0
        let averageSportsRating = dictionary["averageSportsRating"] as! Double? ?? 0.0
        let averageWeatherRating = dictionary["avKerageWeatherRating"] as! Double? ?? 0.0
        let averageGreekLifeRating = dictionary["averageGreekLifeRating"] as! Double? ?? 0.0
        let averageClassroomSizeRating = dictionary["averageClassroomSizeRating"] as! Double? ?? 0.0
        let averageWorkloadRating = dictionary["averageWorkloadRating"] as! Double? ?? 0.0
        let numberOfReviews = dictionary["numberOfReviews"] as! Int? ?? 0
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(name: name, address: address, coordinate: coordinate, averageLocationRating: averageLocationRating, averageNightlifeRating: averageNightlifeRating, averageFoodRating: averageFoodRating, averageProfessorRating: averageProfessorRating, averageDiversityRating: averageDiversityRating, averageSportsRating: averageSportsRating, averageWeatherRating: averageWeatherRating, averageGreekLifeRating: averageGreekLifeRating, averageClassroomSizeRating: averageClassroomSizeRating, averageWorkloadRating: averageWorkloadRating, numberOfReviews: numberOfReviews, postingUserID: postingUserID, documentID: "")
    }
    
    func saveData(completed: @escaping (Bool) -> ()) {
        print("SAVING DATA...")
        let db = Firestore.firestore()
        // Grab the userID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completed(false)
        }
        self.postingUserID = postingUserID

        let dataToSave = self.dictionary

        if self.documentID != "" {
            print("Updating existing document: ")
            print(self.documentID)
            let ref = db.collection("colleges").document(self.documentID) // PROBLEM!!! 
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            }
        } else {
            print("Creating new document")
            var ref: DocumentReference? = nil // Let firestore create the new documentID
            ref = db.collection("colleges").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("doc w  \(ref?.documentID ?? "unknown")")
                    self.documentID = ref!.documentID 
                    completed(true)
                }
            }
        }
    }
    
    
    func updatelocationRatingAverage(completed: @escaping ()->()) {
        let db = Firestore.firestore()
        let reviewsRef = db.collection("colleges").document(self.documentID).collection("reviews")
        reviewsRef.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("error ")
                return completed()
            }
            var ratingTotal = 0.0
            for document in querySnapshot!.documents {
                let reviewDictionary = document.data()
                let rating = reviewDictionary["rating"] as! Int? ?? 0
                ratingTotal = ratingTotal + Double(rating)
            }
            self.averageLocationRating = ratingTotal / Double(querySnapshot!.count)
            self.numberOfReviews = querySnapshot!.count
            let dataToSave = self.dictionary
            let collegeRef = db.collection("colleges").document(self.documentID)
            collegeRef.setData(dataToSave) { error in
                guard error == nil else {
                    return completed()
                }
                completed()
            }
        }
    }
    
    func updateNightlifeRatingAverage(completed: @escaping ()->()) {
        let db = Firestore.firestore()
        let reviewsRef = db.collection("colleges").document(self.documentID).collection("reviews")
        reviewsRef.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("error ")
                return completed()
            }
            var ratingTotal = 0.0
            for document in querySnapshot!.documents {
                let reviewDictionary = document.data()
                let rating = reviewDictionary["rating"] as! Int? ?? 0
                ratingTotal = ratingTotal + Double(rating)
            }
            self.averageNightlifeRating = ratingTotal / Double(querySnapshot!.count)
            self.numberOfReviews = querySnapshot!.count
            let dataToSave = self.dictionary
            let collegeRef = db.collection("colleges").document(self.documentID)
            collegeRef.setData(dataToSave) { error in
                guard error == nil else {
                    return completed()
                }
                completed()
            }
        }
    }
    
    func updateFoodRatingAverage(completed: @escaping ()->()) {
        let db = Firestore.firestore()
        let reviewsRef = db.collection("colleges").document(self.documentID).collection("reviews")
        reviewsRef.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("error ")
                return completed()
            }
            var ratingTotal = 0.0
            for document in querySnapshot!.documents {
                let reviewDictionary = document.data()
                let rating = reviewDictionary["rating"] as! Int? ?? 0
                ratingTotal = ratingTotal + Double(rating)
            }
            self.averageFoodRating = ratingTotal / Double(querySnapshot!.count)
            self.numberOfReviews = querySnapshot!.count
            let dataToSave = self.dictionary
            let collegeRef = db.collection("colleges").document(self.documentID)
            collegeRef.setData(dataToSave) { error in
                guard error == nil else {
                    return completed()
                }
                completed()
            }
        }
    }
    
    func updateProfessorRatingAverage(completed: @escaping ()->()) {
        let db = Firestore.firestore()
        let reviewsRef = db.collection("colleges").document(self.documentID).collection("reviews")
        reviewsRef.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("error ")
                return completed()
            }
            var ratingTotal = 0.0
            for document in querySnapshot!.documents {
                let reviewDictionary = document.data()
                let rating = reviewDictionary["rating"] as! Int? ?? 0
                ratingTotal = ratingTotal + Double(rating)
            }
            self.averageProfessorRating = ratingTotal / Double(querySnapshot!.count)
            self.numberOfReviews = querySnapshot!.count
            let dataToSave = self.dictionary
            let collegeRef = db.collection("colleges").document(self.documentID)
            collegeRef.setData(dataToSave) { error in
                guard error == nil else {
                    return completed()
                }
                completed()
            }
        }
    }
    func updateDiversityRatingAverage(completed: @escaping ()->()) {
        let db = Firestore.firestore()
        let reviewsRef = db.collection("colleges").document(self.documentID).collection("reviews")
        reviewsRef.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("error ")
                return completed()
            }
            var ratingTotal = 0.0
            for document in querySnapshot!.documents {
                let reviewDictionary = document.data()
                let rating = reviewDictionary["rating"] as! Int? ?? 0
                ratingTotal = ratingTotal + Double(rating)
            }
            self.averageDiversityRating = ratingTotal / Double(querySnapshot!.count)
            self.numberOfReviews = querySnapshot!.count
            let dataToSave = self.dictionary
            let collegeRef = db.collection("colleges").document(self.documentID)
            collegeRef.setData(dataToSave) { error in
                guard error == nil else {
                    return completed()
                }
                completed()
            }
        }
    }
    func updateSportsRatingAverage(completed: @escaping ()->()) {
        let db = Firestore.firestore()
        let reviewsRef = db.collection("colleges").document(self.documentID).collection("reviews")
        reviewsRef.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("error ")
                return completed()
            }
            var ratingTotal = 0.0
            for document in querySnapshot!.documents {
                let reviewDictionary = document.data()
                let rating = reviewDictionary["rating"] as! Int? ?? 0
                ratingTotal = ratingTotal + Double(rating)
            }
            self.averageSportsRating = ratingTotal / Double(querySnapshot!.count)
            self.numberOfReviews = querySnapshot!.count
            let dataToSave = self.dictionary
            let collegeRef = db.collection("colleges").document(self.documentID)
            collegeRef.setData(dataToSave) { error in
                guard error == nil else {
                    return completed()
                }
                completed()
            }
        }
    }
    func updateWeatherRatingAverage(completed: @escaping ()->()) {
        let db = Firestore.firestore()
        let reviewsRef = db.collection("colleges").document(self.documentID).collection("reviews")
        reviewsRef.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("error ")
                return completed()
            }
            var ratingTotal = 0.0
            for document in querySnapshot!.documents {
                let reviewDictionary = document.data()
                let rating = reviewDictionary["rating"] as! Int? ?? 0
                ratingTotal = ratingTotal + Double(rating)
            }
            self.averageWeatherRating = ratingTotal / Double(querySnapshot!.count)
            self.numberOfReviews = querySnapshot!.count
            let dataToSave = self.dictionary
            let collegeRef = db.collection("colleges").document(self.documentID)
            collegeRef.setData(dataToSave) { error in
                guard error == nil else {
                    return completed()
                }
                completed()
            }
        }
    }
    func updateGreekLifeRatingAverage(completed: @escaping ()->()) {
        let db = Firestore.firestore()
        let reviewsRef = db.collection("colleges").document(self.documentID).collection("reviews")
        reviewsRef.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("error ")
                return completed()
            }
            var ratingTotal = 0.0
            for document in querySnapshot!.documents {
                let reviewDictionary = document.data()
                let rating = reviewDictionary["rating"] as! Int? ?? 0
                ratingTotal = ratingTotal + Double(rating)
            }
            self.averageGreekLifeRating = ratingTotal / Double(querySnapshot!.count)
            self.numberOfReviews = querySnapshot!.count
            let dataToSave = self.dictionary
            let collegeRef = db.collection("colleges").document(self.documentID)
            collegeRef.setData(dataToSave) { error in
                guard error == nil else {
                    return completed()
                }
                completed()
            }
        }
    }
    func updateClassroomSizeRatingAverage(completed: @escaping ()->()) {
        let db = Firestore.firestore()
        let reviewsRef = db.collection("colleges").document(self.documentID).collection("reviews")
        reviewsRef.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("error ")
                return completed()
            }
            var ratingTotal = 0.0
            for document in querySnapshot!.documents {
                let reviewDictionary = document.data()
                let rating = reviewDictionary["rating"] as! Int? ?? 0
                ratingTotal = ratingTotal + Double(rating)
            }
            self.averageClassroomSizeRating = ratingTotal / Double(querySnapshot!.count)
            self.numberOfReviews = querySnapshot!.count
            let dataToSave = self.dictionary
            let collegeRef = db.collection("colleges").document(self.documentID)
            collegeRef.setData(dataToSave) { error in
                guard error == nil else {
                    return completed()
                }
                completed()
            }
        }
    }
    func updateWorkloadRatingAverage(completed: @escaping ()->()) {
        let db = Firestore.firestore()
        let reviewsRef = db.collection("colleges").document(self.documentID).collection("reviews")
        reviewsRef.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("error ")
                return completed()
            }
            var ratingTotal = 0.0
            for document in querySnapshot!.documents {
                let reviewDictionary = document.data()
                let rating = reviewDictionary["rating"] as! Int? ?? 0
                ratingTotal = ratingTotal + Double(rating)
            }
            self.averageWorkloadRating = ratingTotal / Double(querySnapshot!.count)
            self.numberOfReviews = querySnapshot!.count
            let dataToSave = self.dictionary
            let collegeRef = db.collection("colleges").document(self.documentID)
            collegeRef.setData(dataToSave) { error in
                guard error == nil else {
                    return completed()
                }
                completed()
            }
        }
    }
}
