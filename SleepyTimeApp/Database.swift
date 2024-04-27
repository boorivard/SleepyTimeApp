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
    
    static func updateDocument(date: Date, ratings: [String: Any]){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            
            let docRef = db.collection(uid).document(dateString)
            docRef.setData(ratings) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added with ID: \(docRef.documentID)")
                    }
                }
        }
    }
    
    static func readDocument(for date: Date, completion: @escaping ([String: Any]) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            
            let docRef = db.collection(uid).document(dateString)
                let unsubscribe = docRef.addSnapshotListener { documentSnapshot, error in
                    if let error = error {
                        print("Error fetching document: \(error)")
                        return
                    }
                    guard let document = documentSnapshot else {
                        print("Document does not exist")
                        return
                    }
                    if document.exists {
                        print("Current data: \(document.data())")
                        completion(document.data() ?? [:])
                        
                    } else {
                        print("Document does not exist")
                        completion([:])
                    }
                }
            }
            else {
            print("User not authenticated")
            completion([:]) // Return an empty dictionary
        }
    }

}
