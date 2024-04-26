//
//  Database.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 4/25/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class Database{
    static var db = Firestore.firestore()
    static func initDB(){
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            let collectionName = uid// Replace with your desired collection name
            let collectionRef = db.collection(collectionName)
            // Check if the collection already exists
            collectionRef.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error checking collection existence: \(error)")
                    return
                }
                
                if snapshot?.isEmpty == false {
                    // Collection already exists
                    print("Collection '\(collectionName)' already exists.")
                } else {
                    // Create the collection
                    collectionRef.addDocument(data: [:])
                    { error in
                        if let error = error {
                            print("Error adding document: \(error)")
                        } else {
                            print("Document added successfully!")
                        }
                    }
                }
            }   
        }
    }
    
    static func updateDocument(){
        
    }
}
