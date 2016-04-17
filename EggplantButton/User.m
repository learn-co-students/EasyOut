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

//-(instancetype)initWithUserID:(NSString *)userID {
//    
//    self = [self initWithUserID:<#(NSString *)#> username:<#(NSString *)#> email:<#(NSString *)#> bio:<#(NSString *)#> location:<#(NSString *)#> savedItineraries:<#(NSMutableArray *)#> preferences:<#(NSMutableDictionary *)#> ratings:<#(NSMutableDictionary *)#> tips:<#(NSMutableDictionary *)#> profilePhoto:<#(NSData *)#> reputation:<#(NSUInteger)#>];
//    
//    NSLog(@"User initialized with userID: %@", userID);
//    
//    return self;
//}

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
                   profilePhoto:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://avatars3.githubusercontent.com/u/16245367?v=3&s=460"]]
                     reputation:1];
    
    NSLog(@"User initialized with email: %@ and username: %@", email, username);
    
    return self;
}

-(instancetype) initWithFirebaseUserDictionary:(NSDictionary *)dictionary {
    
    NSMutableDictionary *newDictionary = [dictionary mutableCopy];
    
    NSArray *keys = [dictionary allKeys];
    
    if (![keys containsObject:@"savedItineraries"]) {
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"savedItineraries"];
    }
    if (![keys containsObject:@"tips"]) {
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"tips"];
    }
    if (![keys containsObject:@"ratings"]) {
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"ratings"];
    }
    
    self = [self initWithUserID:newDictionary[@"userID]"] username:newDictionary[@"username"] email:newDictionary[@"email"] bio:newDictionary[@"bio"] location:newDictionary[@"location"] savedItineraries:newDictionary[@"savedItineraries"] preferences:newDictionary[@"preferences"] ratings:newDictionary[@"ratings"] tips:newDictionary[@"tips"] profilePhoto:newDictionary[@"profilePhoto"] reputation:[newDictionary[@"reputation"] integerValue]];
    
    return self;
}

-(instancetype) initWithUserID:(NSString *)userID
                      username:(NSString *)username
                         email:(NSString *)email
                           bio:(NSString *)bio
                      location:(NSString *)location
              savedItineraries:(NSMutableDictionary *)savedItineraries
                   preferences:(NSMutableDictionary *)preferences
                       ratings:(NSMutableDictionary *)ratings
                          tips:(NSMutableDictionary *)tips
                  profilePhoto:(NSData *)profilePhoto
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
        _tips = [NSMutableDictionary new];
        _profilePhoto = profilePhoto;
        _reputation = reputation;
    }

    NSLog(@"User initialized in designated initializer with username: %@", username);
    
    return self;
}

@end
