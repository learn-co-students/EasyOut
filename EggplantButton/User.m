//
//  User.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "User.h"

@interface User ()

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSMutableArray *savedItineraries;
@property (strong, nonatomic) NSMutableDictionary *preferences;
@property (strong, nonatomic) NSMutableDictionary *ratings;
@property (strong, nonatomic) NSMutableDictionary *tips;
@property (strong, nonatomic) NSData *profilePhoto;
@property (nonatomic) NSUInteger reputation;

@end

@implementation User

-(instancetype)init {
    self = [self initWithEmail:@"test@e.mail" password:@"password"];
    if (self) {
        
    }
    
    return self;
}

-(instancetype) initWithEmail:(NSString *)email
                     password:(NSString *)password {
    
    self = [super init];
    
    if (self) {
        _userID = @"id";
        _username = @"testUsername";
        _email = email;
        _bio = @"lol wut";
        _location = @"over there";
        _savedItineraries = [@[] mutableCopy];
        _preferences = [@{} mutableCopy];
        _ratings = [@{} mutableCopy];
        _tips = [@{} mutableCopy];
        _profilePhoto = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://avatars3.githubusercontent.com/u/16245367?v=3&s=460"]];
        _reputation = 1;
    }
    
    NSLog(<#NSString * _Nonnull format, ...#>)
    
    return self;
}

@end
