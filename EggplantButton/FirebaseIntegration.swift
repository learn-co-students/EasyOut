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
        
        // Create a reference to root Firebase location
        let ref = Firebase(url:firebaseRootRef)
        
        // Create child references within the root reference
        let usersRef = ref.childByAppendingPath("users")
        let itinerariesRef = ref.childByAppendingPath("itinieraries")
        
        // Create test user reference
        let userRef = usersRef.childByAppendingPath("user")
        
        // Create child references for current user
        let userName = userRef.childByAppendingPath("username")
        
        print(usersRef)
        print(itinerariesRef)
        print(userName)
        
//        // Write data to Firebase
//        ref.setValue(["users" : "ian"])
        
        // Read data and react to changes
        ref.observeEventType(.Value, withBlock: {
            snapshot in
            print("\(snapshot.key) -> \(snapshot.value)")
        })
        
        FireBaseAPIClient.createNewUserWithEmail("email@example.com", password: "correcthorsebatterystaple")
    }
    
    class func createNewUserWithEmail(email : String, password : String) {
        
        let ref = Firebase(url:firebaseRootRef)
        ref.createUser(email, password: password,
                       withValueCompletionBlock: { error, result in
                        if error != nil {
                            // There was an error creating the account
                        } else {
                            let uid = result["uid"] as? String
                            
                            print("Successfully created user account with uid: \(uid)")
                            
                            let usersRef = ref.childByAppendingPath("users")
                            let userRef = usersRef.childByAppendingPath(uid)
                            
                            userRef.setValue(["uniqueID" : uid!, "email" : email])
                        }
        })
        
        
    }
}

//        @property (strong, nonatomic) NSString *uniqueID;
//        @property (strong, nonatomic) NSString *username;
//        @property (strong, nonatomic) NSString *email;
//        @property (strong, nonatomic) NSString *bio;
//        @property (strong, nonatomic) NSString *location;
//        @property (strong, nonatomic) NSMutableArray *savedItineraries;
//        @property (strong, nonatomic) NSMutableDictionary *preferences;
//        @property (strong, nonatomic) NSMutableDictionary *ratings;
//        @property (strong, nonatomic) NSMutableDictionary *tips;
//        @property (strong, nonatomic) NSData *profilePhoto;
//        @property (nonatomic) NSUInteger reputation;
