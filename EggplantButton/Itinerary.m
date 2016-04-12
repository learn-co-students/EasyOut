//
//  Itinerary.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "Itinerary.h"

@implementation Itinerary

//-(instancetype)init {
//    
//    self = [super init];
//    
//    if (self) {
//        
//    }
//    
//    return self;
//}

// Initialize a new Itinerary object when saving an itinerary from the main view controller
-(instancetype)initWithActivities:(NSMutableArray *) activities
                           userID:(NSString *)userID
                     creationDate:(NSDate *)creationDate
{
    self = [super init];
    
    if(self) {
        _itineraryID = @"";
        _activities = activities;
        _userID = userID;
        _creationDate = creationDate;
        _photos = [[NSMutableArray alloc] init];
        _ratings = [[NSMutableDictionary alloc] init];
        _tips = [[NSMutableArray alloc] init];
    }
    
    return self;
}

// initwith avtivity, userID, creationDate with default

-(instancetype)initWithItineraryID:(NSString *)itineraryID {
    
    
    return self;
}


@end
