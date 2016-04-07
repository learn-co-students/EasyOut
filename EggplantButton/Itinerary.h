//
//  Itinerary.h
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Itinerary : NSObject

@property (strong, nonatomic) NSString *itinieraryID;
@property (strong, nonatomic) NSMutableArray *activities;
@property (strong, nonatomic) User *creator;
@property (strong, nonatomic) NSDate *creationDate;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSDictionary *ratings;

@end
