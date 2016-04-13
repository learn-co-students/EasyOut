//
//  User.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)init {
    self = [self initWithUserID:@"8455b42e-e7d0-49cb-bcce-2e03331b402f"];
    if (self) {
        
    }
    
    return self;
}

-(instancetype) initWithEmail:(NSString *)email username:(NSString *)username{
    
    self = [super init];
    
    if (self) {
        _userID = @"";
        _username = username;
        _email = email;
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

@end
