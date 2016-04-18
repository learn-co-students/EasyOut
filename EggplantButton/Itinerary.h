//
//  Itinerary.h
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Activity.h"

@interface Itinerary : NSObject

@property (strong, nonatomic) NSString *itineraryID;
@property (strong, nonatomic) NSMutableArray *activities;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSDate *creationDate;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableDictionary *ratings;
@property (strong, nonatomic) NSMutableArray *tips;
@property (strong, nonatomic) NSString *title;

-(instancetype)initWithActivities:(NSMutableArray *) activities
                           userID:(NSString *)userID
                     creationDate:(NSDate *)creationDate;

-(instancetype)initWithItineraryDictionary:(NSDictionary *)dictionary;

-(instancetype)initWithUserID:(NSString *)userID
                  itineraryID:(NSString *)itineraryID
                        title:(NSString *)title
                 creationDate:(NSDate *)creationDate
                   activities:(NSMutableArray *)activities
                       photos:(NSMutableArray *)photos
                      ratings:(NSMutableDictionary *)ratings
                         tips:(NSMutableDictionary *)tips;

@end
