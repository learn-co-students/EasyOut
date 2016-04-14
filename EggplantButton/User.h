//
//  User.h
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

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


-(instancetype)initWithEmail:(NSString *)email
                    username:(NSString *)username;

-(instancetype) initWithUserID:(NSString *)userID;

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
                    reputation:(NSUInteger)reputation;

@end
