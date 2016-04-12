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
@property (strong, nonatomic) NSString *creatorID;
@property (strong, nonatomic) NSDate *creationDate;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSDictionary *ratings;
@property (strong, nonatomic) NSMutableArray *tips;

-(instancetype)initWithItineraryID:(NSString *)itineraryID
                        activities:(NSMutableArray *) activities
                         creatorID:(NSString *)creatorID
                      creationDate:(NSDate *)creationDate
                            photos:(NSMutableArray *) photos
                           ratings:(NSDictionary *) ratings
                              tips:(NSMutableArray *) tips;

@end
