//
//  Colleges.swift
//  CollegeDecision
//
//  Created by Emma Loughlin on 11/28/18.
//  Copyright © 2018 Emma Loughlin. All rights reserved.
//

import Foundation
import Firebase

class Colleges {
    var collegeArray = [College]()
    var db: Firestore!
    
    
    init() {
        db = Firestore.firestore()
    }
    func loadData(completed: @escaping () -> ())  {
        db.collection("colleges").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
                
            }
                
            self.collegeArray = []
           
            for document in querySnapshot!.documents {
                let college = College(dictionary: document.data())
                college.documentID = document.documentID
                self.collegeArray.append(college)
            }
            completed()
        }
    }
}


