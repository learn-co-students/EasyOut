//
//  FirebaseIntegrationTestFunctions.swift
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/18/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

import Foundation
import Firebase

@objc class FirebaseTestFunctions : NSObject {
    
    // Test Function that calls all other functions to test
    func testFirebaseFunctions () {
        
        print("Running Firebase test functions.")
        
        // Create default test criteria
        let ref = Firebase(url:firebaseRootRef)
//        let image : UIImage = UIImage(named:"city")!
        print("authID.uid: \(ref.authData.uid)")
        
        // Check user's itineraries and activities for each itinerary
        FirebaseAPIClient.getUserFromFirebaseWithUserID(ref.authData.uid) { (user, success) in
            print(user.savedItineraries)
        }
        
        
//        // Check save image function
//        firebaseAPI.saveNewImageWithImage(image) { (imageID, success) in
//            print("Successfully saved an image")
//        }
        
//        // Check save profile photo function
//        FirebaseAPIClient.saveProfilePhotoForCurrentUser(image) { (success) in
//            print("Returned to save profile photo test")
//            if success {
//                print("Successfully saved profile photo for user with userID: \(ref.authData.uid)")
//            }
//        }

        
//        // Check function to get all usernames in Firebase
//        print("Calling get all users function")
//        firebaseAPI.getAllUsersWithCompletion { (allUsernames) in
//            if allUsernames.isEmpty {
//                print("No usernames were returned.")
//            } else {
//                print("This is the test function calling for all usernames:\n\(allUsernames)")
//            }
//        }
//        
//        
//        // Create new test user
//        let newUser : User = User.init(email: "testuser@test.com", username: "testUser")
//        
//        
//        // Check function to check if user information exists
//        print("Calling check if user information exists function")
//        firebaseAPI.checkIfUserExistsWithInformation("testUser", email: "testuser@test.com", completion: { (doesExist) in
//            if doesExist {
//                print("Test account exists")
//            } else {
//                print("Test account does not exist")
//            }
//        })
//        
//        
//        // Register new test user
//        print("Calling register new user function")
//        firebaseAPI.registerNewUserWithUser(newUser, password: "whatever") { result in
//            
//            // Check registration success
//            let registrationResult = result ? "Registration was successful" : "Registration was not successful"
//            
//            print(registrationResult)
//            
////            if result {
////
////                // Remove test user from Firebase
////                firebaseAPI.removeUserFromFirebaseWithEmail("testUser@test.com", password: "whatever") { (result) in
////
////                    let removalResult = result ? "Test user successfully removed from Firebase" : "Test user was not removed from Firebase"
////
////                    print(removalResult)
////                }
////            }
//        }
//        
//        
//        // Check function to check if user information is unique
//        print("Calling check if user information exists function")
//        firebaseAPI.checkIfUserExistsWithInformation("testUser", email: "testuser@test.com", completion: { (doesExist) in
//            if doesExist {
//                print("Test account exists")
//            } else {
//                print("Test account does not exist")
//            }
//        })
//        
//        
//        // Check function to log new user in
//        print("Calling loginUser")
//        firebaseAPI.logInUserWithEmail("testUser@test.com", password: "whatever") { (result) in
//            
//            // Check login success
//            let loginResult = result ? "Login was successful" : "Login was not successful"
//            
//            print(loginResult)
//        }
//        
//        
//        // Check function to get all itineraries
//        print("Calling getAllItineraries")
//        firebaseAPI.getAllItinerariesWithCompletion { (itineraries) in
//            print("Received itineraries from getAllItineraries test")
//        }
//        
//        // Check function to save new itinerary to Firebase
//        print("Creating test activities")
//        let testActivity = Activity.init(fromDictionary: ["testActivity" : true])
//        let testActivitiesArray: NSMutableArray = [ testActivity ]
//        print(testActivitiesArray)
//        print("Creating test itinerary")
//        let testItinerary = Itinerary.init(activities: testActivitiesArray, userID: "testUserID", creationDate: NSDate())
//        print("Calling saveNewItinerary")
//        firebaseAPI.saveItineraryWithItinerary(testItinerary) { (itineraryID) in
//            print("Saved itinerary with itineraryID: \(itineraryID)")
//
//            // Check function to get an itinerary with an itineraryID
//            print("Calling getItineraryWithItineraryID")
//            firebaseAPI.getItineraryWithItineraryID(itineraryID) { (itinerary) in
//                print("Itinerary returned:\(itinerary)")
//
//                // Check function to remove an itinerary
//                firebaseAPI.removeItineraryWithItineraryID(itineraryID, completion: { (success) in
//                    if success {
//                        print("Successfully removed itinerary with ID: \(itineraryID)")
//                    } else {
//                        print("Failed to remove itinerary with ID: \(itineraryID)")
//                    }
//                })
//            }
//        }
        
    // Make sure no user is logged in
//    print("Calling log out user function")
//    firebaseAPI.logOutUser()

    // Check function to add an itinerary to a user's savedItineraries

    // Check function to remove an itinerary from a user's savedItineraries

    // Check function to resize an image

    // Check function to save an image to Firebase
        
    }
}