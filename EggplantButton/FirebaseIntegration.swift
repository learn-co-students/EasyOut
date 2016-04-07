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
    
    // Create a reference to root Firebase location
    let firebaseRootRef = Firebase(url:"https://boiling-torch-1157.firebaseio.com")
    
    // Create child references within the root reference
    let usersRef = firebaseRootRef.childByAppendingPath("users")
    let itinerariesRef = firebaseRootRef.childByAppendingPath("itinieraries")
    
    // Create test user reference
    let currentUserRef = firebaseRootRef.childByAppendingPath("user")
    
    // Create child references for current user
    let 
    
    // Return list of all users
    class func getAllUsersWithCompletion(completion:(success: Bool) -> ()) {
        
        //hit firebase reference (using firebaseURL)
        //Use the method firebase provides to do this (get that snapshot stuff)
        //when you have snapshot stuff, loop through it or whatever to create your custom objects.
        //then call on completion
        
        completion(success: true)
        
    }
    
    // Return list of all itineraries
    class func getAllItinerariesWithCompletion(completion:(success: Bool) -> ()) {
        
        
        
        completion(success: true)
    }
    
    // Test function
    func sayHi() {
        
        // Write data to Firebase
//        firebaseRootRef.setValue(["users" : "ian"])
        
        // Read data and react to changes
        firebaseRootRef.observeEventType(.Value, withBlock: {
            snapshot in
            print("\(snapshot.key) -> \(snapshot.value)")
        })
    }
}