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
    
    // Login and authenticate user given email and password
    func loginUserWithEmail(email:String, password:String, completion: Bool -> Void) {
        
        print("Attempting to log in user with email: \(email)")
        
        // Set base
        let ref = Firebase(url:firebaseRootRef)
        
        // Attempt user login
        ref.authUser(email, password: password) {
            error, authData in
            
            print("inAUTHUSER Closure--- error: \(error), authData: \(authData)")
            
            if (error != nil) {
                // an error occurred while attempting login
                if let errorCode = FAuthenticationError(rawValue: error.code) {
                    switch (errorCode) {
                    case .UserDoesNotExist:
                        print("Invalid user")
                    case .InvalidEmail:
                        print("Invalid email")
                    case .InvalidPassword:
                        print("Invalid password")
                    default:
                        print("Default error")
                    }
                }
                
                print("An error occurred while attempting login: \(error.description)")
                
                completion(false)
                
            } else {
                print("User is logged in.\nChecking authData for data.")
            }
            
            if authData.auth != nil {
                print("authData has data!")
                completion(true)
            } else {
                print("authData has no data :(")
                completion(false)
            }
        }
    }
    
    
    // Log user out
    func logOutUser() {
        
        // Set references
        let ref = Firebase(url:firebaseRootRef)
        
        ref.unauth()
        
        print("User logged out.")
    }
    
    
    // Register a new user in firebase given a User object and password
    func registerNewUserWithUser(user : User, password : String, completion: (Bool) -> ()) {
        
        print("Attempting to register user: \(user.username)")
        
        // Set reference for firebase account
        let ref = Firebase(url:firebaseRootRef)
        
        print("user email = \(user.email)")
        print("password = \(password)")
        print("ref = \(ref)")
        
        
        // Create user with email from user object and password string
        ref.createUser(user.email, password: password, withValueCompletionBlock: { error, result in
            
            // Check if the userID was created in registration attempt and set it if it was
            guard let uid = result["uid"] as? String else { completion(false); print("No userID found for user reference when registering user with email: \(user.email)."); return }
            
            print("Result of user registration attempt:\n\(result)")
            
            if error != nil {
                print("There was an error creating the user: \(error.description)")
            } else {
                
                print("Successfully created user account with uid: \(uid)")
                
                // Set references for new user
                let usersRef = ref.childByAppendingPath("users")
                let userRef = usersRef.childByAppendingPath(uid)
                
                // Set properties for new user account
                userRef.setValue([
                    "userID" : uid,
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
                print("Registered new user: \(userRef)")
            }
            
            completion(true)
        })
    }
    
    
    // Return list of all users
    func getAllUsersWithCompletion(completion: Array<String> -> Void) {
    
        print("Getting a list of all users at the users reference in Firebase")
        
        // Create array for all usernames
        var allUsernames = [String]()
        
        // Set refgerence to root Firebase location
        let ref = Firebase(url:firebaseRootRef)
        
        // Set child references within the root reference
        let usersRef = ref.childByAppendingPath("users")
        
        // Attach a closure to read the data at our posts reference
        usersRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
//            print("This is the snapshot.value:\n\(snapshot.value)")
            
            // Add each username value for each user reference to the allUsernames array
            for child in snapshot.children{
                if let username = child.value["username"] as? String {
                    print("Adding \(username) to the allUsernames array")
                    allUsernames.append(username.lowercaseString)
                }
            }
            
            print("All usernames inside the observe block:\n\(allUsernames)")
            
            completion(allUsernames)
            
            }, withCancelBlock: { error in
                print("Error retrieving all usernames:\n\(error.description)")
                completion([])
        })
    }
    
    
    // Compare given username to all usernames in Firebase and return unique-status
    func checkIfUsernameExistsWithUsername(username: String, completion: (doesExist: Bool) -> Void) {
        
        print("Checking if username: \(username) exists")
        
        // Call function to retrieve all usernames in Firebase
        getAllUsersWithCompletion { (allUsernames) in
            
            print("Filtering returned usernames by \(username)")
            
            // Filter usernames returned from Firebase by the username passed into the check function
            let filteredNames = allUsernames.filter { $0 == username.lowercaseString }
            
            // Pass the appropriate response to the completion block depending on presence of the given username
            if filteredNames.isEmpty {
                print("Username is not in use")
                completion(doesExist: false)
            } else {
                print("Username is in use")
                completion(doesExist: true)
            }
        }
    }
    
    
    // Return list of all itineraries
    func getAllItinerariesWithCompletion(completion:(success: Bool) -> ()) {
        
        completion(success: true)
    }
    
    
    func saveNewItineraryWithItinerary(itinerary : Itinerary) -> String {
        
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
    func saveNewImageWithImage(image : UIImage, completion: String -> Void) {
        
        // Resize image to fit inside a Firebase value (10MB file size)
        let scaledImage = resizeImage(image)
        
        // Set references for new image
        let ref = Firebase(url:firebaseRootRef)
        let imagesRef = ref.childByAppendingPath("images")
        
        // Create firebase reference for given itinerary
        let newImageRef = imagesRef.childByAutoId()
        
        // Create data from image
        let newImageData : NSData = UIImagePNGRepresentation(scaledImage)!
        
        // Convert image data into base 64 string
        let newImageBase64String : NSString! = newImageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        // Set values of the new itinerary reference with properties on the itinerary
        let newImageID = newImageRef.key
        newImageRef.setValue([
            "imageID" : newImageID,
            "imageBase64String" : newImageBase64String // TODO: Values for this key should be the keys for every photo attached to the itinerary, and the photo keys should be created in another function
            ])
        
        print("Image with ImageID: \(newImageID) added to Firebase")
        
        // Return the new image's ID
        completion(newImageID)
    }
    
    
    // Retrieve an image from a reference in Firebase
    func getImageForImageID(imageID: String, completion: UIImage -> Void) {
        
        print("Getting image for imageID: \(imageID)")
        
        // Set Firebase references
        let ref = Firebase(url:firebaseRootRef)
        let imagesRef = ref.childByAppendingPath("images")
        let imageRef = imagesRef.childByAppendingPath(imageID)
        
        // Retrieve value stored for image data
        imageRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            let imageBase64String = snapshot.value["imageBase64String"] as! String
            
            let imageData : NSData = NSData(base64EncodedString: imageBase64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            
            let image = UIImage(data: imageData)
            
            completion(image!)
        })
    }
    
    
    // Create a User object from Firebase data using a userID and return User object and success state
    func getUserFromFirebaseWithUserID(userID: String, completion: (User, success: Bool) -> Void) {
        
        print("Creating user object from user reference: \(userID)")
        
        // Set references to call for user info
        let ref = Firebase(url:firebaseRootRef)
        let usersRef = ref.childByAppendingPath("users")
        let userRef = usersRef.childByAppendingPath(userID)
        
        // Read data at user reference
        userRef.observeEventType(.Value, withBlock: { snapshot in
            let sv = snapshot.value
            print("User ref:\n\(sv)")
            
            // Create new User object
            let newUser : User = User.init(firebaseUserDictionary: sv as! Dictionary)
            
            print("Created User object for: \(newUser.username)")
            
            completion(newUser, success: true)
            
            }, withCancelBlock: { error in
                print("Error retrieving user in user creation:\n\(error.description)")
                completion(User.init(), success: false)
        })
    }
    
    
    // Convert date objects to strings
    func convertDateToStringWithDate(date:NSDate) -> String {
        
        // Create date formatter and set format style
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Format date into string
        let dateString = dateFormatter.stringFromDate(date)
        
        print("Converted date into: \(dateString)")
        
        // Send back the converted date
        return dateString
    }
    
    
    // Remove user account from Firebase
    func removeUserFromFirebaseWithEmail(email:String, password:String, competion:(Bool) -> ()) {
        
        print("Attempting to remove user with email \(email)")
        
        // Create a reference to root Firebase location
        let ref = Firebase(url:firebaseRootRef)
        
        print(ref)
        
        ref.removeUser(email, password: password) { (error:NSError!) in
            if error != nil {
                print("Error while removing user: \(error.description)")
            }
        }
        
        competion(true)
    }
    
    
    // Resize an image to fit in a Firebase value
    func resizeImage(image: UIImage) -> UIImage {
        
        // Create new image placeholder
        var newImage: UIImage = UIImage()
        
        // Define initial image file size
        var imageData: NSData = NSData(data: UIImageJPEGRepresentation((image), 1)!)
        var imageSizeInKB: Int = imageData.length / 1024
        
        // While the image size is greater than 10MB, run size reduction
        while imageSizeInKB > 10000 {
            
            // Define the new size of the image at 90% of its original size
            let newSize = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.9, 0.9))
            
            // Calculate the rectangle used for scaling
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            
            // Define image context for resizing
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            
            // Use image context to draw scaled image
            image.drawInRect(rect)
            
            // Create new image from the scaled image and close the image context
            newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            imageData = NSData(data: UIImageJPEGRepresentation((newImage), 1)!)
            imageSizeInKB = imageData.length / 1024
        }

        // Return the scaled image
        return newImage
    }
    
    
    // Test Function that calls all other functions to test
    func testFirebaseFunctions () {
        
        print("Running Firebase test functions.")
        
        // Make sure no user is logged in
        print("Calling log out user function")
        logOutUser()
        
        // Check function to get all usernames in Firebase
        print("Calling get all users function")
        getAllUsersWithCompletion { (allUsernames) in
            if allUsernames.isEmpty {
                print("No usernames were returned.")
            } else {
                print("This is the test function calling for all usernames:\n\(allUsernames)")
            }
        }
        
        // Check function to check if username is unique (should not be unique)
        print("Calling check if username exists function")
        checkIfUsernameExistsWithUsername("testy") { (doesExist) in
            if doesExist {
                print("Account with username testy exists")
            } else {
                print("Account with username testy does not exist")
            }
        }
        
        // Create new test user
        let newUser : User = User.init(email: "testUser@test.com", username: "testUser")
        
        // Register new test user
        print("Calling register new user function")
        registerNewUserWithUser(newUser, password: "whatever") { result in
            
            let registrationResult = result ? "Registration was successful" : "Registration was not successful"
            
            print(registrationResult)
            
            if result {
                
                // Remove test user from Firebase
                self.removeUserFromFirebaseWithEmail("testUser@test.com", password: "whatever") { (success) in
                    
                    let removalResult = success ? "Test user successfully removed from Firebase" : "Test user was not removed from Firebase"
                    
                    print(removalResult)
                    
                }
            }
        }
        
        // Check function to check if test user account still exists
        print("Calling check if username exists function for testUser")
        checkIfUsernameExistsWithUsername("testUser") { (doesExist) in
            if doesExist {
                print("testUser is the username of an active account")
            } else {
                print("testUser is not in use")
            }
        }
        
        // Log new user in
        print("Calling login function")
        self.loginUserWithEmail("test@test.com", password: "whatever") { (success) in
            
            let loginResult = success ? "Login was successful" : "Login was not successful"
            
            print(loginResult)
            
            // Make sure no user is logged in
            print("Calling log out function")
            self.logOutUser()
        }
        
        // Make sure no user is logged in
        print("Calling log out function")
        logOutUser()
        
        // Check function to resize an image
        
        // Check function to save an image to Firebase
    }
}