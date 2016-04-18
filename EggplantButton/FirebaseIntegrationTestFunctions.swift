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
        
        
        // Create instance of FirebaseAPIClient
        let firebaseAPI : FirebaseAPIClient = FirebaseAPIClient()
        
        print("Running Firebase test functions.")
        
        
        // Create a reference to root Firebase location
        let ref = Firebase(url:firebaseRootRef)
        
        print("authID.uid: \(ref.authData.uid)")

        
        // Check function to get all usernames in Firebase
        print("Calling get all users function")
        firebaseAPI.getAllUsersWithCompletion { (allUsernames) in
            if allUsernames.isEmpty {
                print("No usernames were returned.")
            } else {
                print("This is the test function calling for all usernames:\n\(allUsernames)")
            }
        }
        
        
        // Create new test user
        let newUser : User = User.init(email: "testuser@test.com", username: "testUser")
        
        
        // Check function to check if user exists
        print("Calling check if username exists function")
        firebaseAPI.checkIfUserExistsWithUsername("testUser", email: "testuser@test.com", completion: { (doesExist) in
            if doesExist {
                print("Test account exists")
            } else {
                print("Test account does not exist")
            }
        })
        
        
        // Register new test user
        print("Calling register new user function")
        firebaseAPI.registerNewUserWithUser(newUser, password: "whatever") { result in
            
            // Check registration success
            let registrationResult = result ? "Registration was successful" : "Registration was not successful"
            
            print(registrationResult)
            
//            if result {
//
//                // Remove test user from Firebase
//                firebaseAPI.removeUserFromFirebaseWithEmail("testUser@test.com", password: "whatever") { (result) in
//
//                    let removalResult = result ? "Test user successfully removed from Firebase" : "Test user was not removed from Firebase"
//
//                    print(removalResult)
//                }
//            }
        }
        
        
        // Check function to check if username is unique
        print("Calling check if username exists function")
        firebaseAPI.checkIfUserExistsWithUsername("testUser", email: "testuser@test.com", completion: { (doesExist) in
            if doesExist {
                print("Test account exists")
            } else {
                print("Test account does not exist")
            }
        })
        
        
        // Check function to log new user in
        print("Calling loginUser")
        firebaseAPI.logInUserWithEmail("testUser@test.com", password: "whatever") { (result) in
            
            // Check login success
            let loginResult = result ? "Login was successful" : "Login was not successful"
            
            print(loginResult)
        }
        
        
        // Check function to get all itineraries
        print("Calling getAllItineraries")
        firebaseAPI.getAllItinerariesWithCompletion { (itineraries) in
            if let itineraries = itineraries {
                print("Received itineraries from getAllItineraries test:\n\(itineraries)")
            }
        }
        
        // Check function to save new itinerary to Firebase
        print("Creating test activities")
        let testActivityType: ActivityType = ActivityType.init(rawValue: 0)!
        let testActivity1 = Activity.init(name: "test1", address: "test1", city: "test1", postalCode: "10001", imageURL: NSURL.fileURLWithPath("testURL"), activityType: testActivityType)
        let testActivity2 = Activity.init(name: "test2", address: "test2", city: "test2", postalCode: "10001", imageURL: NSURL.fileURLWithPath("testURL"), activityType: testActivityType)
        let testActivity3 = Activity.init(name: "test3", address: "test3", city: "test3", postalCode: "10001", imageURL: NSURL.fileURLWithPath("testURL"), activityType: testActivityType)
        let testActivitiesArray: NSMutableArray = [ testActivity1, testActivity2, testActivity3]
        print(testActivitiesArray)
        print("Creating test itinerary")
        let testItinerary = Itinerary.init(activities: testActivitiesArray, userID: "testUserID", creationDate: NSDate())
        print("Calling saveNewItinerary")
        firebaseAPI.saveItineraryWithItinerary(testItinerary) { (itineraryID) in
            print("Saved itinerary with itineraryID: \(itineraryID)")

            // Check function to get an itinerary with an itineraryID
            print("Calling getItineraryWithItineraryID")
            firebaseAPI.getItineraryWithItineraryID(itineraryID) { (itinerary) in
                print("Itinerary returned:\(itinerary)")

//                // Check function to remove an itinerary
//                self.removeItineraryWithItineraryID(itineraryID, completion: { (success) in
//                    if success {
//                        print("Successfully removed itinerary with ID: \(itineraryID)")
//                    } else {
//                        print("Failed to remove itinerary with ID: \(itineraryID)")
//                    }
//                })
            }
        }
        
    // Make sure no user is logged in
//    print("Calling log out user function")
//    firebaseAPI.logOutUser()

    // Check function to add an itinerary to a user's savedItineraries

    // Check function to remove an itinerary from a user's savedItineraries

    // Check function to resize an image

    // Check function to save an image to Firebase
        
    }
}