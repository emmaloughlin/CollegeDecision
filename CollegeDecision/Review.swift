//
//  Review.swift
//  CollegeDecision
//
//  Created by Emma Loughlin on 11/30/18.
//  Copyright © 2018 Emma Loughlin. All rights reserved.
//

import Foundation
import Firebase

class Review {
    var title: String
    var text: String
    var locationRating: Int
    var nightlifeRating: Int
    var foodRating: Int
    var professorRating: Int
    var diversityRating: Int
    var sportsRating: Int
    var weatherRating: Int
    var greekLifeRating: Int
    var classroomSizeRating: Int
    var workloadRating: Int
    var reviewerUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["title": title, "text": text, "locationRating": locationRating,"nightlifeRating": nightlifeRating,"foodRating": foodRating,"professorRating": professorRating,"diversityRating": diversityRating,"sportsRating": sportsRating,"weatherRating": weatherRating,"greekLifeRating": greekLifeRating,"classroomSizeRating": classroomSizeRating,"workloadRating": workloadRating, "reviewerUserID": reviewerUserID]
}

    init(title: String, text: String,  locationRating: Int, nightlifeRating: Int, foodRating: Int, professorRating: Int, diversityRating: Int, sportsRating: Int, weatherRating: Int, greekLifeRating: Int, classroomSizeRating: Int, workloadRating: Int,reviewerUserID: String, documentID: String) {
        self.title = title
        self.text = text
        self.locationRating = locationRating
        self.nightlifeRating = nightlifeRating
        self.foodRating = foodRating
        self.professorRating = professorRating
        self.diversityRating = diversityRating
        self.sportsRating = sportsRating
        self.weatherRating = weatherRating
        self.greekLifeRating = greekLifeRating
        self.classroomSizeRating = classroomSizeRating
        self.workloadRating = workloadRating
        self.reviewerUserID = reviewerUserID
        self.documentID = documentID

    }
    
    
    convenience init(dictionary: [String: Any]) {
        let title = dictionary["title"] as! String? ?? ""
        let text = dictionary["text"] as! String? ?? ""
        let locationRating = dictionary["locationRating"] as! Int? ?? 0
        let nightlifeRating = dictionary["nightlifeRating"] as! Int? ?? 0
        let foodRating = dictionary["foodRating"] as! Int? ?? 0
        let professorRating = dictionary["professorRating"] as! Int? ?? 0
        let diversityRating = dictionary["diversityRating"] as! Int? ?? 0
        let sportsRating = dictionary["sportsRating"] as! Int? ?? 0
        let weatherRating = dictionary["weatherRating"] as! Int? ?? 0
        let greekLifeRating = dictionary["greekLifeRating"] as! Int? ?? 0
        let classroomSizeRating = dictionary["classroomSizeRating"] as! Int? ?? 0
        let workloadRating = dictionary["workloadRating"] as! Int? ?? 0
        let reviewerUserID = dictionary["reviewerUserID"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        self.init(title: title, text: text,locationRating: locationRating, nightlifeRating: nightlifeRating,foodRating: foodRating,professorRating: professorRating,diversityRating: diversityRating,sportsRating: sportsRating,weatherRating: weatherRating,greekLifeRating: greekLifeRating,classroomSizeRating: classroomSizeRating,workloadRating: workloadRating,reviewerUserID: reviewerUserID, documentID: "")
    }
    
    

    convenience init() {
        let currentUserID = Auth.auth().currentUser?.email ?? "Unknown User" 
        self.init(title: "", text: "", locationRating: 0, nightlifeRating: 0, foodRating: 0, professorRating: 0, diversityRating: 0, sportsRating: 0, weatherRating: 0, greekLifeRating: 0, classroomSizeRating: 0, workloadRating: 0, reviewerUserID: currentUserID, documentID: "")
    }
    
    func saveData(college: College, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        
        let dataToSave = self.dictionary

        if self.documentID != "" {
            let ref = db.collection("colleges").document(college.documentID).collection("reviews").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentID) in college \(college.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    college.updatelocationRatingAverage {
                        completed(true)
                    }
                    college.updateNightlifeRatingAverage {
                        completed(true)
                    }
                    college.updateFoodRatingAverage {
                        completed(true)
                    }
                    college.updateProfessorRatingAverage {
                        completed(true)
                    }
                    college.updateDiversityRatingAverage {
                        completed(true)
                    }
                    college.updateSportsRatingAverage {
                        completed(true)
                    }
                    college.updateWeatherRatingAverage {
                        completed(true)
                    }
                    college.updateGreekLifeRatingAverage {
                        completed(true)
                    }
                    college.updateClassroomSizeRatingAverage {
                        completed(true)
                    }
                    college.updateWorkloadRatingAverage {
                        completed(true)
                    }
                }
            }
        } else {
            var ref: DocumentReference? = nil // Let firestore create the new documentID
            ref = db.collection("colleges").document(college.documentID).collection("reviews").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("ERROR \(error.localizedDescription)")
                    completed(false)
                } else {
                    college.updatelocationRatingAverage {
                        completed(true)
                    }
                    college.updateNightlifeRatingAverage {
                        completed(true)
                    }
                    college.updateFoodRatingAverage {
                        completed(true)
                    }
                    college.updateProfessorRatingAverage {
                        completed(true)
                    }
                    college.updateDiversityRatingAverage {
                        completed(true)
                    }
                    college.updateSportsRatingAverage {
                        completed(true)
                    }
                    college.updateWeatherRatingAverage {
                        completed(true)
                    }
                    college.updateGreekLifeRatingAverage {
                        completed(true)
                    }
                    college.updateClassroomSizeRatingAverage {
                        completed(true)
                    }
                    college.updateWorkloadRatingAverage {
                        completed(true)
                    }
                }
            }
        }
    }
    
    func deleteData(college: College, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("colleges").document(college.documentID).collection("reviews").document(documentID).delete() { error in
            if let error = error {
                completed(false)
            } else {
                college.updatelocationRatingAverage {
                    completed(true)
                }
                college.updateNightlifeRatingAverage {
                    completed(true)
                }
                college.updateFoodRatingAverage {
                    completed(true)
                }
                college.updateProfessorRatingAverage {
                    completed(true)
                }
                college.updateDiversityRatingAverage {
                    completed(true)
                }
                college.updateSportsRatingAverage {
                    completed(true)
                }
                college.updateWeatherRatingAverage {
                    completed(true)
                }
                college.updateGreekLifeRatingAverage {
                    completed(true)
                }
                college.updateClassroomSizeRatingAverage {
                    completed(true)
                }
                college.updateWorkloadRatingAverage {
                    completed(true)
                }
            }
        }
    }
}
