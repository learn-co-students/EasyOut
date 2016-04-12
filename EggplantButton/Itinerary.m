//
//  Itinerary.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "Itinerary.h"

@implementation Itinerary

-(instancetype)init {
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

-(instancetype)initWithItineraryID:(NSString *)itineraryID
                        activities:(NSMutableArray *) activities
                            userID:(NSString *)userID
                      creationDate:(NSDate *)creationDate
                            photos:(NSMutableArray *) photos
                           ratings:(NSMutableDictionary *) ratings
                              tips:(NSMutableArray *) tips
{
    self = [super init];
    
    if(self) {
        _itineraryID = itineraryID;
        _activities = activities;
        _userID = userID;
        _creationDate = [NSDate date];
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