//
//  FirebaseIntegration.swift
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/6/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

import Foundation
import Firebase


@objc class FireBaseAPIClient: NSObject {
    
    // Create a reference to a Firebase location
    let firebaseDataStore = Firebase(url:"https://boiling-torch-1157.firebaseio.com")
    
    // Write data to Firebase
//    firebaseDataStore.setValue("Do you have data? You'll love Firebase.")
    
    
    class func getAllUsersWithCompletion(completion:(success: Bool) -> ()) {
        
        //hit firebase reference (using firebaseURL)
        //Use the method firebase provides to do this (get that snapshot stuff)
        //when you have snapshot stuff, loop through it or whatever to create your custom objects.
        //then call on completion
        
        completion(success: true)
        
    }
    
    class func getAllItinerariesWithCompletion(completion:(success: Bool) -> ()) {
        
        
        
        completion(success: true)
    }
    
    // Test function
    func sayHi() {
        
        // Write data to Firebase
        firebaseDataStore.setValue(["users" : "ian"])
        
        // Read data and react to changes
        firebaseDataStore.observeEventType(.Value, withBlock: {
            snapshot in
            print("\(snapshot.key) -> \(snapshot.value)")
        })
    }
}