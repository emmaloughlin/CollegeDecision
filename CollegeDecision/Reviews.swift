//
//  Reviews.swift
//  CollegeDecision
//
//  Created by Emma Loughlin on 11/30/18.
//  Copyright © 2018 Emma Loughlin. All rights reserved.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray: [Review] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(college: College, completed: @escaping () -> ())  {
        guard college.documentID != "" else {
            return
        }
        db.collection("colleges").document(college.documentID).collection("reviews").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("error  \(error!.localizedDescription)")
                return completed()
            }
            self.reviewArray = []
            
            for document in querySnapshot!.documents {
                let review = Review(dictionary: document.data())
                review.documentID = document.documentID
                self.reviewArray.append(review)
            }
            completed()
        }
    }
}
