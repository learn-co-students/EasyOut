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

-(instancetype)initWithUserID:(NSString *)userID {
    
    self = [super init];
    
    if (self) {
        _userID =userID;
        _username = @"testUsername";
        _email = @"test@test.test";
        _bio = @"";
        _location = @"";
        _savedItineraries = [@[] mutableCopy];
        _preferences = [@{@"default location" : @"New York, NY", @"default price" : @2, @"default start time" : @0} mutableCopy];
        _ratings = [@{} mutableCopy];
        _tips = [@{} mutableCopy];
        _profilePhoto = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://avatars3.githubusercontent.com/u/16245367?v=3&s=460"]];
        _reputation = 1;
    }
    
    NSLog(@"User initialized");
    
    return self;
}

-(instancetype) initWithEmail:(NSString *)email username:(NSString *)username{
    
    self = [self initWithUserID:@"" username:username email:email bio:@"" location:@"" savedItineraries:[@[] mutableCopy] preferences:[@{@"default location" : @"New York, NY", @"default price" : @2, @"default start time" : @0} mutableCopy] ratings:[@{} mutableCopy] tips:[@{} mutableCopy] profilePhoto:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://avatars3.githubusercontent.com/u/16245367?v=3&s=460"]] reputation:1];
    
    NSLog(@"User initialized with username: %@", username);
    
    return self;
}

-(instancetype) initWithUserID:(NSString *)userID
                      username:(NSString *)username
                         email:(NSString *)email
                           bio:(NSString *)bio
                      location:(NSString *)location
              savedItineraries:(NSMutableArray *)savedItineraries
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
        _tips = tips;
        _profilePhoto = profilePhoto;
        _reputation = reputation;
    }

    NSLog(@"User initialized in designated initializer with username: %@", username);
    
    return self;
}

@end
