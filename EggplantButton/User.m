//
//  User.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "User.h"
#import "EggplantButton-Swift.h"

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
            ];
    
    NSLog(@"User initialized with email: %@ and username: %@", email, username);
    
    return self;
}

// Use this initializer when creating a User object from a reference in Firebase
-(instancetype) initWithFirebaseUserDictionary:(NSDictionary *)dictionary {
    
    NSMutableDictionary *newDictionary = [dictionary mutableCopy];
    
    NSArray *keys = [dictionary allKeys];
    
    // Check for empty dictionaries that Firebase may not have saved
    if (![keys containsObject:@"savedItineraries"]) {
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"savedItineraries"];
    }
    if (![keys containsObject:@"tips"]) {
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"tips"];
    }
    if (![keys containsObject:@"ratings"]) {
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"ratings"];
    }
    
    self = [self initWithUserID:newDictionary[@"userID]"]
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
            ];
    
    NSLog(@"User initialized from Firebase dictionary");
    
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
                    reputation:(NSUInteger)reputation {
    
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
    }

    NSLog(@"User initialized in designated initializer with username: %@", username);
    
    return self;
}

@end
