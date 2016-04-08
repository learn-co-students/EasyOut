//
//  Firebase.swift
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

import Foundation
import Firebase

@objc class FireBaseAPIClient: NSObject {
    
    // Create a reference to root Firebase location
    let rootRef = Firebase(url:firebaseRootRef)
    
    
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
    
    class func createNewUserWithUsername(username : String) {
        
        
        
    }
    
    // Test function
    func sayHi() {
        
        // Create child references within the root reference
        let usersRef = firebaseRootRef.childByAppendingPath("users")
        let itinerariesRef = firebaseRootRef.childByAppendingPath("itinieraries")
        
        // Create test user reference
        let userRef = usersRef.childByAppendingPath("user")
        
        // Create child references for current user
        let userName = userRef.childByAppendingPath("username")
        
        print(usersRef)
        print(itinerariesRef)
        print(userName)
        
        // Write data to Firebase
        firebaseRootRef.setValue(["users" : "ian"])
        
        // Read data and react to changes
        firebaseRootRef.observeEventType(.Value, withBlock: {
            snapshot in
            print("\(snapshot.key) -> \(snapshot.value)")
        })
    }
}
