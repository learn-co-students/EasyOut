//
//  Firebase.swift
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

import Foundation
import Firebase

@objc class FirebaseAPIClient: NSObject {
    
    // TODO: Global save function which calls appropriate API save function based on type of data passed in
    
    
    // Return list of all users
    func getAllUsersWithCompletion(completion:(success: Bool) -> (AnyObject)) {
        
        // Create a reference to root Firebase location
        let ref = Firebase(url:firebaseRootRef)
        
        // Create child references within the root reference
        let usersRef = ref.childByAppendingPath("users")
        
        // Attach a closure to read the data at our posts reference
        ref.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        
        
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
//        FireBaseAPIClient.createNewUserWithEmail("email1@example.com", password: "correcthorsebatterystaple")
    }
    
    // Create a new user in firebase given email and password
    func createNewUserWithEmail(email : String, password : String) {
        
        let ref = Firebase(url:firebaseRootRef)
        ref.createUser(email, password: password,
                       withValueCompletionBlock: { error, result in
                        if error != nil {
                            print("There was an error creating the user: \(error.description)")
                        } else {
                            let uid = result["uid"] as? String
                            
                            print("Successfully created user account with uid: \(uid)")
                            
                            let usersRef = ref.childByAppendingPath("users")
                            let userRef = usersRef.childByAppendingPath(uid)
                            
                            userRef.setValue([
                                "userID" : uid!,
                                "username" : "username",
                                "email" : email,
                                "bio" : "bio",
                                "location" : "location",
                                "saved itineraries" : [ "itineraryID" : "itinerary" ],
                                "preferences" : [
                                    "default location" : "New York, NY",
                                    "default price" : 2,
                                    "default start time" : 1
                                ],
                                "ratings" : [ "itineraryID" : 0 ],
                                "tips" : [ "itineraryID" : "tip" ],
                                "reputation" : 0,
                                "profilePhoto" : "imageID"
                            ])
                            
                            print("Created new user: \(userRef)")
                        }
        })
    }
    
    // Create a new user in firebase given a User object and password
    // **** SHOULD BE DEFAULT FOR USER CREATION ****
    func createNewUserWithUser(user : User, password : String) {
        
        let ref = Firebase(url:firebaseRootRef)
        
        ref.createUser(user.email, password: password, withValueCompletionBlock: { error, result in
                        if error != nil {
                            print("There was an error creating the user: \(error.description)")
                            // TODO: Add warning to the user if we encounter an error
                        } else {
                            let uid = result["uid"] as? String
                            
                            print("Successfully created user account with uid: \(uid)")
                            
                            let usersRef = ref.childByAppendingPath("users")
                            let userRef = usersRef.childByAppendingPath(uid)
                            
                            userRef.setValue([
                                    "userID" : uid!,
                                    "username" : user.username,
                                    "email" : user.email,
                                    "bio" : user.bio,
                                    "location" : user.location,
                                    "saved itineraries" : user.savedItineraries,
                                    "preferences" : user.preferences,
                                    "ratings" : user.ratings,
                                    "tips" : user.tips,
                                    "reputation" : user.reputation,
                                    "profilePhoto" : user.profilePhoto
                                ])
                            
                            // We should actually call firebase to pull values for new user and make sure everything was set correctly
                            print("Created new user: \(userRef)")
                        }
        })
    }
    
    func createNewItineraryWithItinerary(itinerary : Itinerary) -> String {
        
        // Set references for new itinerary
        let ref = Firebase(url:firebaseRootRef)
        let itinerariesRef = ref.childByAppendingPath("itineraries")
    
        // Create firebase reference for given itinerary
        let newItineraryRef = itinerariesRef.childByAutoId()
        
        // Access unique key created for new itinerary reference
        let newItineraryID = newItineraryRef.key
        
        // Set values of the new itinerary reference with properties on the itinerary
        newItineraryRef.setValue([
            "itineraryID" : newItineraryID,
            "creationDate" : itinerary.creationDate,
            "activities" : itinerary.activities,
            "ratings" : itinerary.ratings,
            "tips" : itinerary.tips,
            "photos" : itinerary.photos,
            "userID" : ref.authData.uid
        ])
        
        // Return the new
        return newItineraryID
    }
    
    // Create a new image reference in Firebase and return its unique ID
    func createNewImageWithImage(image : UIImage) -> String {
        
        // Set references for new itinerary
        let ref = Firebase(url:firebaseRootRef)
        let imagesRef = ref.childByAppendingPath("images")
        
        // Create firebase reference for given itinerary
        let newImageRef = imagesRef.childByAutoId()
        
        // Create data from image
        let newImageData : NSData = UIImagePNGRepresentation(image)!
        
        // Convert image data into base 64 string
        let newImageBase64String : NSString! = newImageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        // Set values of the new itinerary reference with properties on the itinerary
        let newImageID = newImageRef.key
        newImageRef.setValue([
            "imageID" : newImageID,
            "imageBase64String" : newImageBase64String // TODO: Values for this key should be the keys for every photo attached to the itinerary, and the photo keys should be created in another function
            ])
        
//        print(newImageData)
        
        // Return the new image's ID
        return newImageID
    }
}