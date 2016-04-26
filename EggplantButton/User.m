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
               associatedImages:[@{} mutableCopy]
            ];
    
    NSLog(@"User initialized with email: %@ and username: %@", email, username);
    
    return self;
}

// Use this initializer when creating a User object from a reference in Firebase
-(instancetype) initWithFirebaseUserDictionary:(NSDictionary *)dictionary {
    
    NSMutableDictionary *newDictionary = [dictionary mutableCopy];
    
    NSArray *keys = [dictionary allKeys];
    
    NSMutableArray *itineraryKeys = [[NSMutableArray alloc] init];
    NSMutableDictionary *itineraryObjects = [[NSMutableDictionary alloc] init];
    NSMutableArray *tipKeys = [[NSMutableArray alloc] init];
    NSMutableArray *ratingKeys = [[NSMutableArray alloc] init];
    NSMutableArray *associatedImageKeys = [[NSMutableArray alloc] init];
    
    // Check for empty dictionaries that Firebase may not have saved
    if (![keys containsObject:@"savedItineraries"]) {
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"savedItineraries"];
    } else {
        
        itineraryKeys = [[dictionary[@"savedItineraries"] allKeys] mutableCopy];
        
        for (NSString *key in itineraryKeys) {
            [FirebaseAPIClient getItineraryWithItineraryID:key completion:^(Itinerary * itinerary) {
                [itineraryObjects setObject:itinerary forKey:key];
            }];
        }
        
        [newDictionary[@"savedItineraries"] removeAllObjects];
        
        newDictionary[@"savedItineraries"] = itineraryObjects;
    }
    
    if (![keys containsObject:@"associatedImages"]) {
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"associatedImages"];
    } else {
        
        associatedImageKeys = [[dictionary[@"associatedImages"] allKeys] mutableCopy];
        
        for (NSString *key in associatedImageKeys) {
            [FirebaseAPIClient getImageForImageID:key completion:^(UIImage * image) {
                [newDictionary[@"associatedImages"] setObject:image forKey:key];
            }];
        }
    }
    
    if (![keys containsObject:@"tips"]) {
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"tips"];
    } else {
        NSLog(@"Tips exist for current user, but we aren't getting them from Firebase");
    }
    
    if (![keys containsObject:@"ratings"]) {
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"ratings"];
    } else {
        NSLog(@"Ratings exist for current user, but we aren't getting them from Firebase");
    }
    
    self = [self initWithUserID:newDictionary[@"userID"]
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

@end
