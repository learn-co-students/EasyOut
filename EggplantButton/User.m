//
//  User.m
//  EasyOut
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import "User.h"
#import "EasyOut-Swift.h"

@implementation User

// Use this initializer when registering a new user
-(instancetype) initWithEmail:(NSString *)email username:(NSString *)username{
    
    self = [self initWithUserID:@""
                       username:username
                          email:email
                            bio:@""
                       location:@""
               savedItineraries:[@{} mutableCopy]
                    preferences:[@{@"default location" : @"New York, NY", @"default price" : @2, @"default start time" : @0} mutableCopy]
                        ratings:[@{} mutableCopy]
                           tips:[@{} mutableCopy]
                   profilePhoto:@""
                     reputation:1
               associatedImages:[@{} mutableCopy]
            ];
    
    NSLog(@"User initialized with email: %@ and username: %@", email, username);
    
    return self;
}

// The designated initializer
-(instancetype) initWithUserID:(NSString *)userID
                      username:(NSString *)username
                         email:(NSString *)email
                           bio:(NSString *)bio
                      location:(NSString *)location
              savedItineraries:(NSMutableDictionary *)savedItineraries
                   preferences:(NSMutableDictionary *)preferences
                       ratings:(NSMutableDictionary *)ratings
                          tips:(NSMutableDictionary *)tips
                  profilePhoto:(NSString *)profilePhoto
                    reputation:(NSUInteger)reputation
              associatedImages:(NSMutableDictionary *)associatedImages {
    
    self = [super init];
    
    if (self) {
        _userID = userID;
        _username = username;
        _email = email;
        _bio = bio;
        _location = location;
        _savedItineraries = savedItineraries;
        _preferences = preferences;
        _ratings = ratings;
        _tips = tips;
        _profilePhoto = profilePhoto;
        _reputation = reputation;
        _associatedImages = associatedImages;
    }
    
    NSLog(@"User initialized in designated initializer with username: %@", username);
    
    return self;
}

// Create a User object from a Firebase reference dictionary and pass the User back in a completion block
+(void) initWithFirebaseUserDictionary:(NSDictionary *)dictionary
                            completion:(void (^)(User *user))completion {
    
    NSLog(@"Dictionary passed into user initializer");
    
    NSMutableDictionary *newDictionary = [dictionary mutableCopy];
    
    NSArray *userElementKeys = [dictionary allKeys];
    
    // Check for empty dictionaries that Firebase may not have saved
    if (![userElementKeys containsObject:@"tips"]) {
        NSLog(@"User has no tips");
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"tips"];
    }
    
    if (![userElementKeys containsObject:@"ratings"]) {
        NSLog(@"User has no ratings");
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"ratings"];
    }
    
    if (![userElementKeys containsObject:@"savedItineraries"]) {
        NSLog(@"User has no saved itineraries");
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"savedItineraries"];
    }
        
    if (![userElementKeys containsObject:@"associatedImages"]) {
        NSLog(@"User has no associated images");
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"associatedImages"];
    }

    User *newUser = [[User alloc] createUserFromDictionary:newDictionary];
    NSLog(@"User %@ initialized from Firebase dictionary", newDictionary[@"name"]);
    
    completion(newUser);
}

// Internal method for creating a User from parsed Firebase dictionary
-(User *) createUserFromDictionary:(NSDictionary *)newDictionary {
    User *newUser = [[User alloc] initWithUserID:newDictionary[@"userID"]
                                        username:newDictionary[@"username"]
                                           email:newDictionary[@"email"]
                                             bio:newDictionary[@"bio"]
                                        location:newDictionary[@"location"]
                                savedItineraries:newDictionary[@"savedItineraries"]
                                     preferences:newDictionary[@"preferences"]
                                         ratings:newDictionary[@"ratings"]
                                            tips:newDictionary[@"tips"]
                                    profilePhoto:newDictionary[@"profilePhoto"]
                                      reputation:[newDictionary[@"reputation"] integerValue]
                                associatedImages:newDictionary[@"associatedImages"]
                     ];
    return newUser;
}



@end
