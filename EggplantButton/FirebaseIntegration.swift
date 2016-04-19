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
    func logInUserWithEmail(email:String, password:String, completion: Bool -> Void) {
        
        print("Attempting to log in user with email: \(email)")
        
        // Set base reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Attempt user authentication
        ref.authUser(email, password: password) {
            error, authData in
            
            print("Result of attempt to authenticate user: \(error), authData: \(authData)")
            
            if (error != nil) {
                // an error occurred while attempting login
                if let errorCode = FAuthenticationError(rawValue: error.code) {
                    switch (errorCode) {
                    case .UserDoesNotExist:
                        print("****Error type: Invalid user")
                    case .InvalidEmail:
                        print("****Error type: Invalid email")
                    case .InvalidPassword:
                        print("****Error type: Invalid password")
                    default:
                        print("****Error type: Other error")
                    }
                }
                
                print("An error occurred while attempting login: \(error.description)")
                
                completion(false)
                
            } else {
                print("User is logged in.\nChecking authData for data.")
                
                if authData.auth != nil {
                    print("authData has data!")
                    completion(true)
                } else {
                    print("authData has no data :(")
                    completion(false)
                }
            }
        }
    }
    
    
    // Log user out
    func logOutUser() {
        
        print("Attempting to log user out")
        
        // Set references
        let ref = Firebase(url:firebaseRootRef)
        
        // Check if a user is currently logged in
        if ref.authData != nil {
            
            // Unauthorize (log out) user
            print("Logging out user with useriD \(ref.authData.uid)")
            ref.unauth()
            print("User logged out")
            
        } else {
            print("No user currently logged in")
        }
        
    }
    
    
    // Register a new user in firebase given a User object and password
    func registerNewUserWithUser(user: User, password: String, completion: (Bool) -> ()) {
        
        print("Attempting to register user with\nUsername: \(user.username)\nEmail: \(user.email)\nPassword: \(password)")
        
        // Make sure username and email aren't already in use
        checkIfUserExistsWithUsername(user.username, email: user.email) { (doesExist) in
            if doesExist {
                
                print("Couldn't register user because username is already in use")
                completion(false)
                
            } else {
                
                print("Username is not in use, continuing with registration")
                
                // Set reference for firebase account
                let ref = Firebase(url:firebaseRootRef)
                
                // Create user with email from user object and password string
                ref.createUser(user.email, password: password, withValueCompletionBlock: { error, result in
                    
                    // Check for any errors and continue if there are none
                    if error != nil {
                        print("There was an error creating the user \(error.description)")
                    } else {
                        
                        // Check if the userID was created in registration attempt and set it if it was
                        guard let uid = result["uid"] as? String else { completion(false); print("No userID found for user reference when registering user with email \(user.email)."); return }
                        
                        print("Result of user registration attempt:\n\(result)")
                        
                        print("Successfully created user account with uid \(uid)")
                        
                        // Set references for new user
                        let usersRef = ref.childByAppendingPath("users")
                        let userRef = usersRef.childByAppendingPath(uid)
                        
                        // Set properties for new user account
                        print("Setting values for new user")
                        userRef.setValue([
                            "userID" : uid,
                            "username" : user.username,
                            "email" : user.email,
                            "bio" : user.bio,
                            "location" : user.location,
                            "savedItineraries" : user.savedItineraries,
                            "preferences" : user.preferences,
                            "ratings" : user.ratings,
                            "tips" : user.tips,
                            "reputation" : user.reputation,
                            "profilePhoto" : user.profilePhoto
                            ])
                        
                        // We should actually call firebase to pull values for new user and make sure everything was set correctly
                        print("Registered new user: \(userRef)")
                    }
                    
                    // Log in the user
                    print("Calling logInUser from within createUser completion block")
                    self.logInUserWithEmail(user.email, password: password, completion: { (success) in
                        if success {
                            print("Logged in user with userID \(ref.authData.uid) after registration")
                            completion(true)
                        } else {
                            print("Failed to log in user after registration")
                        }
                    })
                })
            }
        }
    }
    
    
    // Return list of all users
    func getAllUsersWithCompletion(completion: Array<String> -> Void) {
    
        print("Getting a list of all users at the users reference in Firebase")
        
        // Create array for all usernames
        var allUsernames = [String]()
        
        // Set reference to root Firebase location
        let ref = Firebase(url:firebaseRootRef)
        
        // Set child references within the root reference
        let usersRef = ref.childByAppendingPath("users")
        
        // Attach a closure to read the data at our posts reference
        usersRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
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
                print("****Error retrieving all usernames:\n\(error.description)")
                completion([])
            })
    }
    
    
    // Return list of all email addresses
    func getAllEmailsWithCompletion(completion: Array<String> -> Void) {
        
        print("Getting a list of all emails at the users reference in Firebase")
        
        // Create array for all email addresses
        var allEmailAddresses = [String]()
        
        // Set reference to root Firebase location
        let ref = Firebase(url:firebaseRootRef)
        
        // Set child references within the root reference
        let usersRef = ref.childByAppendingPath("users")
        
        // Attach a closure to read the data at our posts reference
        usersRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            // Add each email address value for each user reference to the allUsernames array
            for child in snapshot.children{
                if let emailAddress = child.value["email"] as? String {
                    print("Adding \(emailAddress) to the allEmailAddresses array")
                    allEmailAddresses.append(emailAddress.lowercaseString)
                }
            }
            
            print("Successfully received all users")
            
            completion(allEmailAddresses)
            
            }, withCancelBlock: { error in
                print("****Error retrieving all email addresses:\n\(error.description)")
                completion([])
        })
    }
    
    
    // Create a User object from Firebase data using a userID and return User object and success state
    func getUserFromFirebaseWithUserID(userID: String, completion: (user: User, success: Bool) -> Void) {
        
        print("Creating user object from user reference \(userID)")
        
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
            
            print("Created User object for \(newUser.username)")
            
            completion(user: newUser, success: true)
            
            }, withCancelBlock: { error in
                print("****Error retrieving user in user creation:\n\(error.description)")
                completion(user: User.init(), success: false)
        })
    }
    
    
    // Compare given username to all usernames in Firebase and return unique-status
    func checkIfUserExistsWithUsername(username: String, email: String, completion: (doesExist: Bool) -> Void) {
        
        print("Checking if \(username) or \(email) exists in Firebase")
        
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
        
        getAllEmailsWithCompletion { (allEmailAddresses) in
            print("Filtering returned usernames by \(email)")
            
            // Filter usernames returned from Firebase by the username passed into the check function
            let filteredEmails = allEmailAddresses.filter { $0 == email.lowercaseString }
            
            // Pass the appropriate response to the completion block depending on presence of the given username
            if filteredEmails.isEmpty {
                print("Email address is not in use")
                completion(doesExist: false)
            } else {
                print("Email address is in use")
                completion(doesExist: true)
            }

        }
    }
    
    
    func saveItineraryWithItinerary(itinerary: Itinerary, completion: (itineraryID: String) -> Void) {
        
        print("Attempting to save new itinerary: \(itinerary.title)")
        
        // Set references for new itinerary
        let ref = Firebase(url:firebaseRootRef)
        let itinerariesRef = ref.childByAppendingPath("itineraries")
        
        // Create firebase reference for given itinerary
        print("Creating reference for new itinerary in Firebase")
        let newItineraryRef = itinerariesRef.childByAutoId()
        
        // Access unique key created for new itinerary reference
        let newItineraryID = newItineraryRef.key
        
        // Set values of the new itinerary reference with properties on the itinerary
        print("Setting values for new itinerary with itineraryID: \(newItineraryID)")
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
        
        // Add the itinerary to the current user
        print("Calling addItineraryToUser function")
        addItineraryToUserWithUserID(ref.authData.uid, itineraryID: newItineraryID) { (success) in
            if success {
                print("addItineraryToUser function succeeded")
            } else {
                print("addItineraryToUser function did not succeed")
            }
        }
        
        // Return the new itineraryID
        completion(itineraryID: newItineraryID)
    }
    
    
    // Add itineraryID to current user's savedItineraries
    private func addItineraryToUserWithUserID(userID: String, itineraryID: String, completion: Bool -> Void) {
        
        print("Attempting to add new itineraryID to savedItineraries of current user")
        
        // Set Firebase references
        let ref = Firebase(url:firebaseRootRef)
        let usersRef = ref.childByAppendingPath("users")
        let userRef = usersRef.childByAppendingPath(ref.authData.uid)
        let savedItinerariesRef = userRef.childByAppendingPath("savedItineraries")
        
        // Save the new itineraryID as a key with Bool value of true
        savedItinerariesRef.childByAppendingPath(itineraryID).setValue(true) { (error, result) in
            
            if (error != nil) {
                print("There was an error adding the itineraryID to savedItineraries: \(error.description)")
                completion(false)
            } else {
                print("New itineraryID saved successfully:\n\(result)")
                completion(true)
            }
        }
    }
    
    
    // Return list of all itineraries
    func getAllItinerariesWithCompletion(completion:(itineraries: [String:AnyObject]?) -> Void) {
        
        print("Attempting to retrieve all itineraries")
        
        // Set references for new itinerary
        let ref = Firebase(url:firebaseRootRef)
        let itinerariesRef = ref.childByAppendingPath("itineraries")
        
        // Create an observe event for the itineraries reference
        itinerariesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            print("Successfully received snapshot at itineraries reference")
            completion(itineraries: (snapshot.value as! Dictionary))
            }, withCancelBlock: { error in
                print("****Error while trying to retrieve itineraries:\n\(error.description)")
                completion(itineraries: nil)
        })
    }

    
    func getItineraryWithItineraryID(itineraryID: String, completion: Itinerary? -> Void) {

        print("Attempting to get itinerary with itineraryID:\(itineraryID)")
        
        // Get all itineraries
        print("Calling getAllItineraries function")
        getAllItinerariesWithCompletion { (itineraries) in
            
            // Check if itineraries were returned
            print("Checking if itineraries were returned from the getAllItineraries function")
            if let itineraries = itineraries {
                
                // Check if the itineraries dictionary contains a key matching the itineraryID
                print("Checking if the returned itineraries contain one that matches the itineraryID")
                if let itineraryDictionary = itineraries[itineraryID] {
                    
                    // Create Itinerary object from itineraryDictionary
                    let itinerary: Itinerary = Itinerary.init(firebaseItineraryDictionary: itineraryDictionary as! [NSObject : AnyObject])
                    
                    // Send the matching itinerary to the completion block
                    print("Found a matching itinerary")
                    completion(itinerary)
                } else {
                    
                    // Send nil to the completion block
                    print("Did not find a matching itinerary")
                    completion(nil)
                }
            } else {
                
                // Send nil to the completion block
                print("Itineraries were not returned")
                completion(nil)
            }
        }
    }
    
    // Remove itinerary from Firebase within both the itineraries dictionary as well as from the saved itineraries of the associated user
    func removeItineraryWithItineraryID(itineraryID: String, completion: (success: Bool) -> Void) {
        
        print("Attempting to remove itinerary with ID: \(itineraryID)")
        
        // Retrieve the itinerary
        print("Calling getItineraryWithItineraryID")
        getItineraryWithItineraryID(itineraryID) { (itinerary) in
            if let realItinerary = itinerary {
                
                // Set Firebase references
                let ref = Firebase(url:firebaseRootRef)
                let itinerariesRef = ref.childByAppendingPath("itineraries")
                
                // Check that the userID associated with the itinerary matches the userID of the current user
                if realItinerary.userID == ref.authData.uid {
                    
                    // If the userIDs are a match, remove the itinerary from the itineraries reference
                    let itineraryRef = itinerariesRef.childByAppendingPath(itineraryID)
                    itineraryRef.removeValueWithCompletionBlock({ (error, result) in
                        
                        if (error != nil) {
                            print("****Error removing the itinerary: \(error.description)")
                            completion(success: false)
                        } else {
                            print("Itinerary removed successfully from itineraries dictionary in Firebase")
                            
                            // Call method to remove itinerary from user's savedItineraries
                            print("Calling method to remove itinerary from user's savedItineraries")
                            self.removeItineraryFromUserWithUserID(ref.authData.uid, itineraryID: itineraryID, completion: { (success) in
                                if success {
                                    print("Itinerary was successfully removed from user's savedItineraries")
                                    completion(success: true)
                                } else {
                                    print("Itinerary was not successfully removed from savedItineraries")
                                    completion(success: false)
                                }
                            })
                        }
                    })
                }
                
            } else {
                print("ItineraryID \(itineraryID) could not be located in itineraries dictionary")
                completion(success: false)
            }
        }
    }
    
    
    // Remove itinerary item from user's savedItineraries
    // Called only from within this integration, everytime an itinerary is removed from Firebase
    private func removeItineraryFromUserWithUserID(userID: String, itineraryID: String, completion: Bool -> Void) {
        
        // Set Firebase references
        let ref = Firebase(url:firebaseRootRef)
        let usersRef = ref.childByAppendingPath("users")
        let userRef = usersRef.childByAppendingPath(ref.authData.uid)
        let savedItinerariesRef = userRef.childByAppendingPath("savedItineraries")
        
        // Call method to remove value at the reference for the given itineraryID
        savedItinerariesRef.childByAppendingPath(itineraryID).removeValueWithCompletionBlock { (error, result) in
            if (error != nil) {
                print("****Error removing the itinerary from savedItineraries: \(error.description)")
                completion(false)
            } else {
                print("Itinerary removed successfully:\n\(result)")
                completion(true)
            }
        }
    }
    
    
    // Create a new image reference in Firebase and return its unique ID
    func saveNewImageWithImage(image : UIImage, imageID: String -> Void) {
        
        print("Attempting to save a new image to Firebase")
        
        // Resize image to fit inside a Firebase value (10MB file size)
        self.resizeImage(image) { (scaledImage) in
            
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
            imageID(newImageID)
        }
        
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
    
    
    // Convert date objects to strings
    private func convertDateToStringWithDate(date:NSDate) -> String {
        
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
    private func resizeImage(oldImage: UIImage, completion: (scaledImage: UIImage) -> Void) {
        
        // Create new image placeholder
        var newImage: UIImage = UIImage()
        
        // Define initial image file size
        var imageData: NSData = NSData(data: UIImageJPEGRepresentation((oldImage), 1)!)
        var imageSizeInKB: Int = imageData.length / 1024
        
        // While the image size is greater than 10MB, run size reduction
        while imageSizeInKB > 10000 {
            
            // Define the new size of the image at 90% of its original size
            let newSize = CGSizeApplyAffineTransform(oldImage.size, CGAffineTransformMakeScale(0.9, 0.9))
            
            // Calculate the rectangle used for scaling
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            
            // Define image context for resizing
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            
            // Use image context to draw scaled image
            oldImage.drawInRect(rect)
            
            // Create new image from the scaled image and close the image context
            newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            imageData = NSData(data: UIImageJPEGRepresentation((newImage), 1)!)
            imageSizeInKB = imageData.length / 1024
        }

        // Return the scaled image
        completion(scaledImage: newImage)
    }
    
}