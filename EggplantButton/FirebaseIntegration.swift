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
    class func logInUserWithEmail(email:String, password:String, completion: (authData: FAuthData!, error: NSError!) -> Void) {
        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Attempt user authentication
        ref.authUser(email, password: password) {
            error, authData in
            
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
                
                
                completion(authData: authData, error: error)
                
            } else {
                
                if authData.auth != nil {
                    print("authData has data!")
                    completion(authData: authData, error: error)
                } else {
                    print("authData has no data :(")
                    completion(authData: authData, error: error)
                }
            }
        }
    }
    
    
    // Log user out
    class func logOutUser() {
        
//        print("Attempting to log user out")
        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Check if a user is currently logged in
        if ref.authData != nil {
            
            // Unauthorize (log out) user
//            print("Logging out user with useriD \(ref.authData.uid)")
            ref.unauth()
//            print("User logged out")
            
        } else {
//            print("No user currently logged in")
        }
        
    }
    
    
    // Register a new user in firebase given a User object and password
    class func registerNewUserWithUser(user: User, password: String, completion: (Bool) -> ()) {
        
//        print("Attempting to register user with\nUsername: \(user.username)\nEmail: \(user.email)\nPassword: \(password)")
        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Create user with email from user object and password string
        ref.createUser(user.email, password: password, withValueCompletionBlock: { error, result in
            
            // Check for any errors and continue if there are none
            if error != nil {
//                print("There was an error creating the user \(error.description)")
                completion(false)
            } else {
                
                // Check if the userID was created in registration attempt and set it if it was
                guard let uid = result["uid"] as? String else { completion(false);
                    
//                    print("No userID found for user reference when registering user with email \(user.email)."); 
                    return }
                
//                print("Result of user registration attempt:\n\(result)")
//                
//                print("Successfully created user account with uid \(uid)")
                
                // Set references for new user
                let usersRef = ref.childByAppendingPath("users")
                let userRef = usersRef.childByAppendingPath(uid)
                
                // Set properties for new user account
//                print("Setting values for new user")
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
                    "profilePhoto" : user.profilePhoto,
                    "associatedImages" : user.associatedImages
                ])
                
                // We should actually call firebase to pull values for new user and make sure everything was set correctly
//                print("Registered new user: \(userRef)")
            }
            
            // Log in the user
//            print("Calling logInUser from within createUser completion block")
            self.logInUserWithEmail(user.email, password: password, completion: { (authData, error) in
                if error != nil {
//                    print("****Error trying to log user in after registration: \(error)")
                    
                    completion(false)
                } else {
                    
//                    print("Logged in user with userID \(authData.uid) after registration")
                    
                    completion(true)
                }
            })
        })
    }
    
    
    // Return list of all users
    class func getAllUsersWithCompletion(completion: Array<String> -> Void) {
    
//        print("Getting a list of all users at the users reference in Firebase")
        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Create array for all usernames
        var allUsernames = [String]()
        
        // Set child references within the root reference
        let usersRef = ref.childByAppendingPath("users")
        
        // Attach a closure to read the data at our users reference
        usersRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
                // Add each username value for each user reference to the allUsernames array
                for child in snapshot.children{
                    if let username = child.value["username"] as? String {
//                        print("Adding \(username) to the allUsernames array")
                        allUsernames.append(username.lowercaseString)
                    }
                }
                
//                print("All usernames inside the observe block:\n\(allUsernames)")
            
                completion(allUsernames)
                
            }, withCancelBlock: { error in
//                print("****Error retrieving all usernames:\n\(error.description)")
                completion([])
        })
    }
    
    
    // Return list of all email addresses
    class func getAllEmailsWithCompletion(completion: Array<String> -> Void) {
        
//        print("Getting a list of all emails at the users reference in Firebase")
        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Create array for all email addresses
        var allEmailAddresses = [String]()
        
        // Set child references within the root reference
        let usersRef = ref.childByAppendingPath("users")
        
        // Attach a closure to read the data at our users reference
        usersRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            // Add each email address value for each user reference to the allUsernames array
            for child in snapshot.children{
                if let emailAddress = child.value["email"] as? String {
                    print("Adding \(emailAddress) to the allEmailAddresses array")
                    allEmailAddresses.append(emailAddress.lowercaseString)
                }
            }
            
//            print("Successfully received all users")
            
            completion(allEmailAddresses)
            
            }, withCancelBlock: { error in
//                print("****Error retrieving all email addresses:\n\(error.description)")
                completion([])
        })
    }
    
    
    // Create a User object from Firebase data using a userID and return User object and success state
    class func getUserFromFirebaseWithUserID(userID: String, completion: (user: User, success: Bool) -> Void) {
        
//        print("Creating user object from user reference \(userID)")
        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Set Firebase references
        let usersRef = ref.childByAppendingPath("users")
        let userRef = usersRef.childByAppendingPath(userID)
        
        // Read data at user reference
        userRef.observeEventType(.Value, withBlock: { snapshot in
            let sv = snapshot.value
//            print("User ref:\n\(sv)")
            
            // Create new User object
            let newUser : User = User.init(firebaseUserDictionary: sv as! Dictionary)
            
//            print("Created User object for \(newUser.username)")
            
            completion(user: newUser, success: true)
            
            }, withCancelBlock: { error in
//                print("****Error retrieving user in user creation:\n\(error.description)")
                completion(user: User.init(), success: false)
        })
    }
    
    
    // Compare given username to all usernames in Firebase and return unique-status
    class func checkIfUserExistsWithInformation(username: String, email: String, completion: (doesExist: Bool) -> Void) {
        
        print("Checking if \(username) or \(email) exists in Firebase")
        
        checkIfUserExistsWithUsername(username) { (doesExist) in
            
            if doesExist {
                print("Username is in use")
            } else {
                print("Username is not in use")
            }
        }
       
        checkIfUserExistsWithEmail(email) { (doesExist) in
            if doesExist {
                print("Email is in use")
            } else {
                print("Email is not in use")
            }
        }
    }
    
    // Compare given username to all usernames in Firebase and return unique-status
    class func checkIfUserExistsWithUsername(username: String, completion: (doesExist: Bool) -> Void) {
        
        print("Checking if \(username) exists in Firebase")
        
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
    
    // Compare given email to all emails in Firebase and return unique-status
    class func checkIfUserExistsWithEmail(email: String, completion: (doesExist: Bool) -> Void) {
        
        print("Checking if \(email) exists in Firebase")
        
        // Call function to get all emails in Firebase
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
    
    
    class func saveItineraryWithItinerary(itinerary: Itinerary, completion: (itineraryID: String) -> Void) {
        
        print("Attempting to save new itinerary: \(itinerary.title)")
        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Set references for new itinerary
        let itinerariesRef = ref.childByAppendingPath("itineraries")
        print("Creating reference for new itinerary in Firebase")
        let newItineraryRef = itinerariesRef.childByAutoId()
        
        // Access unique key created for new itinerary reference
        let newItineraryID = newItineraryRef.key
        
        // Convert activities into dictionaries
        var activities : [[String:AnyObject]] = []
        for activityObject in itinerary.activities as NSMutableArray {
            
            var activityDictionary = [String : AnyObject]()
            
            let address : Array = activityObject.address
            
            let address0 : String = address[0] as! String
            let address1 : String = address[1] as! String
            
            activityDictionary = [ "name" : activityObject.name,
                                   "address0" : address0,
                                   "address1" : address1,
                                   "type" : activityObject.type,
                                   "imageURL" : activityObject.imageURL.description,
//                                   "price" : activityObject.price,
//                                   "moreDetailsURL" : activityObject.moreDetailsURL
            ]
            
            activities.append(activityDictionary)
        }
        
        // Set values of the new itinerary reference with properties on the itinerary
        newItineraryRef.setValue([
            "itineraryID" : newItineraryID,
            "creationDate" : convertDateToStringWithDate(itinerary.creationDate),
            "activities" : activities,
            "ratings" : itinerary.ratings,
            "tips" : itinerary.tips,
            "photos" : itinerary.photos,
            "userID" : ref.authData.uid,
            "title" : itinerary.title
            ])
        
        
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
    class func addItineraryToUserWithUserID(userID: String, itineraryID: String, completion: Bool -> Void) {
        
        print("Attempting to add new itineraryID to savedItineraries of current user")
        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Set Firebase references
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
    class func getAllItinerariesWithCompletion(completion:(itineraries: [String:AnyObject]?) -> Void) {
        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Set references for new itinerary
        let itinerariesRef = ref.childByAppendingPath("itineraries")
        
        // Create an observe event for the itineraries reference
        itinerariesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            completion(itineraries: (snapshot.value as! Dictionary))
            }, withCancelBlock: { error in
                completion(itineraries: nil)
        })
    }

    
    class func getItineraryWithItineraryID(itineraryID: String, completion: Itinerary? -> Void) {


        // Get all itineraries
        getAllItinerariesWithCompletion { (itineraries) in
            
            // Check if itineraries were returned
            if let itineraries = itineraries {
                
                // Check if the itineraries dictionary contains a key matching the itineraryID
                if let itineraryDictionary = itineraries[itineraryID] {
                    
                    // Create Itinerary object from itineraryDictionary
                    let itinerary: Itinerary = Itinerary.init(firebaseItineraryDictionary: itineraryDictionary as! [NSObject : AnyObject])
                    
                    // Send the matching itinerary to the completion block
                    completion(itinerary)
                } else {
                    
                    // Send nil to the completion block
                    completion(nil)
                }
            } else {
                
                // Send nil to the completion block
                completion(nil)
            }
        }
    }
    
    // Remove itinerary from Firebase within both the itineraries dictionary as well as from the saved itineraries of the associated user
    class func removeItineraryWithItineraryID(itineraryID: String, completion: (success: Bool) -> Void) {
        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Retrieve the itinerary
        getItineraryWithItineraryID(itineraryID) { (itinerary) in
            if let realItinerary = itinerary {
                
                // Set Firebase references
                let itinerariesRef = ref.childByAppendingPath("itineraries")
                
                // Check that the userID associated with the itinerary matches the userID of the current user
                if realItinerary.userID == ref.authData.uid {
                    
                    // TODO: MOVE CONTENTS TO A NEW FUNCTION
                    
                    // If the userIDs are a match, remove the itinerary from the itineraries reference
                    let itineraryRef = itinerariesRef.childByAppendingPath(itineraryID)
                    itineraryRef.removeValueWithCompletionBlock({ (error, result) in
                        
                        if (error != nil) {
                            completion(success: false)
                        } else {
                            
                            // Call method to remove itinerary from user's savedItineraries
                            self.removeItineraryFromUserWithUserID(ref.authData.uid, itineraryID: itineraryID, completion: { (success) in
                                if success {
                                    completion(success: true)
                                } else {
                                    completion(success: false)
                                }
                            })
                        }
                    })
                }
                
            } else {
                completion(success: false)
            }
        }
    }
    
    
    // Remove itinerary item from user's savedItineraries
    // Called only from within this integration, everytime an itinerary is removed from Firebase
    class func removeItineraryFromUserWithUserID(userID: String, itineraryID: String, completion: (success: Bool) -> Void) {
        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Set Firebase references
        let usersRef = ref.childByAppendingPath("users")
        let userRef = usersRef.childByAppendingPath(ref.authData.uid)
        let savedItinerariesRef = userRef.childByAppendingPath("savedItineraries")
        
        // Call method to remove value at the reference for the given itineraryID
        savedItinerariesRef.childByAppendingPath(itineraryID).removeValueWithCompletionBlock { (error, result) in
            if (error != nil) {
                completion(success: false)
            } else {
                completion(success: true)
            }
        }
    }
    
    
    // Create a new image reference in Firebase and return its unique ID
    class func saveNewImageWithImage(image: UIImage, completion: (imageID: String, success: Bool) -> Void) {
        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Resize image to fit inside a Firebase value (10MB file size)
        self.resizeImage(image) { (scaledImage) in
            
            // Set references
            let imagesRef = ref.childByAppendingPath("images")
            let newImageRef = imagesRef.childByAutoId()
            
            // Create data from image
            let newImageData : NSData = UIImageJPEGRepresentation(scaledImage, 1)!
            
            // Convert image data into base 64 string
            let newImageBase64String : NSString! = newImageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            
            // Set values of the new image reference
            let newImageDictionary = [
                "imageID" : newImageRef.key,
                "imageBase64String" : newImageBase64String
                ]
            
            newImageRef.setValue(newImageDictionary, withCompletionBlock: { (error, result) in
                if error != nil {
                    completion(imageID: "", success: false)
                } else {
                    // Add the imageID to the current user's associatedImages reference
                    self.addImageIDToCurrentUser(newImageRef.key, completion: { (success) in
                        if success {
                            
                            // Return the new imageID
                            completion(imageID: newImageRef.key, success: true)
                        } else {
                            
                            // Return a blank imageID
                            completion(imageID: "", success: false)
                        }
                    })
                    completion(imageID: newImageRef.key, success: true)
                }
            })
        }
    }
    
    
    // Add imageID to current user
    class func addImageIDToCurrentUser(imageID: String, completion: (success: Bool) -> Void) {
        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Set Firebase references
        let usersRef = ref.childByAppendingPath("users")
        let userRef = usersRef.childByAppendingPath(ref.authData.uid)
        let associatedImagesRef = userRef.childByAppendingPath("associatedImages")
        
        // Save the new imageID as a key with Bool value of true
        associatedImagesRef.childByAppendingPath(imageID).setValue(true) { (error, result) in
            
            if (error != nil) {
                completion(success: false)
            } else {
                completion(success: true)
            }
        }
    }
    
    
    // Set profile photo for current user
    class func saveProfilePhotoForCurrentUser(image: UIImage, completion: (success: Bool) -> Void) {

        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Set Firebase references
        let usersRef = ref.childByAppendingPath("users")
        let userRef = usersRef.childByAppendingPath(ref.authData.uid)
        let profilePhotoRef = userRef.childByAppendingPath("profilePhoto")
        
        // Save the new image to Firebase
        self.saveNewImageWithImage(image) { (imageID, success) in
            if success {
                
                // Read the data in the current user reference
                userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    // Get the value for the profilePhoto key
                    let oldProfilePhotoRef = snapshot.value["profilePhoto"] as! String
                    
                    // Check if the current profilePhoto value is empty
                    if oldProfilePhotoRef.isEmpty {
                        
                        // Add the imageID for the new image to the profilePhoto reference
                        profilePhotoRef.setValue(imageID)
                        completion(success: true)
                        
                    } else {
                        
                        // Overwrite old profile photo on Firebase
                        profilePhotoRef.setValue(imageID, withCompletionBlock: { (error, result) in
                            if error != nil {
                                completion(success: false)
                            } else {
                                completion(success: true)
                            }
                        })
                        
                        // TODO:
                        // Remove imageID from profilePhoto reference
                        // Remove imageID from associatedImages reference
                        // Test that old imageID is still in associatedImages
                        
                    }
                    
                }, withCancelBlock: { error in
                    completion(success: false)
                })
                
            } else {
                completion(success: false)
            }
        }
    }
    
    
    // Remove image from Firebase given the imageID
    class func removeImageWithImageID(imageID: String, completion: (success: Bool) -> Void) {
        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Set Firebase references
        let imagesRef = ref.childByAppendingPath("images")
        let imageToRemoveRef = imagesRef.childByAppendingPath(imageID)
        
        // Remove imageID value from Firebase
        imageToRemoveRef.removeValueWithCompletionBlock { (error, result) in
            
            if error != nil {
                completion(success: false)
            } else {
                completion(success: true)
            }
        }
    }
    
    
    // Retrieve an image from a reference in Firebase
    class func getImageForImageID(imageID: String, completion: UIImage -> Void) {
        
        // Set root Firebase reference
        let ref = Firebase(url:firebaseRootRef)
        
        // Set Firebase references
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
    class func convertDateToStringWithDate(date:NSDate) -> String {
        
        // Create date formatter and set format style
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Format date into string
        let dateString = dateFormatter.stringFromDate(date)
        
        // Send back the converted date
        return dateString
    }
    
    
    // Remove user account from Firebase
    class func removeUserFromFirebaseWithEmail(email:String, password:String, competion:(Bool) -> ()) {
        
        // Set Firebase references
        let ref = Firebase(url:firebaseRootRef)
        let usersRef = ref.childByAppendingPath("users")
        let imagesRef = ref.childByAppendingPath("images")
        let itinerariesRef = ref.childByAppendingPath("itineraries")
        let currentUserRef = usersRef.childByAppendingPath(ref.authData.uid)
        let associatedImagesRef = currentUserRef.childByAppendingPath("associatedImages")
        let savedItinerariesRef = currentUserRef.childByAppendingPath("savedItineraries")
        
        // Remove all user itineraries and associated images
        
        
        FirebaseAPIClient.logOutUser()
        
        ref.removeUser(email, password: password) { (error:NSError!) in
            if error != nil {
            }
        }
        
        competion(true)
    }
    
    
    // Resize an image to fit in a Firebase value
    class func resizeImage(oldImage: UIImage, completion: (scaledImage: UIImage) -> Void) {
        
        var newImage: UIImage = oldImage
        
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