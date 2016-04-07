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
        // Init all the things
    }
    
    return self;
}

@end
