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
    
    // Test Function that calls all other functions to test
    func testFirebaseFunctions () {
        let itinerary : Itinerary = Itinerary.init(activities: ["whatever", "ativities", "haha fun"], userID: "159b8eee-8476-40d8-9f33-f35412df6cd1", creationDate: NSDate())
        createNewItineraryWithItinerary(itinerary)
    }
    
    
    // TODO: Global save function which calls appropriate API save function based on type of data passed in
    
    
    // Return list of all users
    func getAllUsersWithCompletion(completion:(success: Bool) -> Void) {
        
        // Create a reference to root Firebase location
        let ref = Firebase(url:firebaseRootRef)
        
        // Create child references within the root reference
        let usersRef = ref.childByAppendingPath("users")
        
        // Attach a closure to read the data at our posts reference
        usersRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            print(snapshot.value)
            
            var allUsernames = [String]()
            for child in snapshot.children{
                if let username = child.value["username"] as? String {
                    print(username)
                    allUsernames.append(username.lowercaseString)
                }
            }
            print("all usernames: \(allUsernames)")
            let filteredNames = allUsernames.filter { $0 == "JoN123".lowercaseString }
            if filteredNames.isEmpty {
                print("Success! that is a unique username")
                // continue and save their data
            } else {
                print("failure! name is taken :(")
                // present alert and reset
            }
            
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
    func getAllItinerariesWithCompletion(completion:(success: Bool) -> ()) {
        
        
        
        completion(success: true)
    }
    
    // Login and authenticate user given email and password
    func loginUserWithEmail(email : String, password : String) {
        
        // Set base
        let ref = Firebase(url:firebaseRootRef)
        
        // Attempt user login
        ref.authUser(email, password: password) {
            error, authData in
            if error != nil {
                print("An error occurred while attempting login: \(error.description)")
            } else {
                print("User is logged in, checking authData for data")
                
                if authData.auth != nil {
                    print("authData has data!")
                } else {
                    print("authData has no data :(")
                }
                
            }
        }
    }
    // Create a new user in firebase given a User object and password
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
                                    "profilePhoto" : ""
                                ])
                            
                            // We should actually call firebase to pull values for new user and make sure everything was set correctly
                            print("Created new user: \(userRef)")            }
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
            "creationDate" : convertDateToStringWithDate(itinerary.creationDate),
            "activities" : itinerary.activities,
            "ratings" : itinerary.ratings,
            "tips" : itinerary.tips,
            "photos" : itinerary.photos,
            "userID" : ref.authData.uid,
            "title" : itinerary.title
        ])
        
        print("Added new itinerary with title: \(itinerary.title) and ID: \(newItineraryID)")
        
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
    
    // Convert date objects to strings
    func convertDateToStringWithDate(date : NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
}