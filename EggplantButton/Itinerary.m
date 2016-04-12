//
//  Itinerary.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "Itinerary.h"

@implementation Itinerary

-(instancetype)initWithItineraryID:(NSString *)itineraryID
                        activities:(NSMutableArray *) activities
                         creatorID:(NSString *)creatorID
                      creationDate:(NSDate *)creationDate
                            photos:(NSMutableArray *) photos
                           ratings:(NSDictionary *) ratings
                              tips:(NSMutableArray *) tips
{
    
    self = [super init];
    if(self) {
        _itineraryID = itineraryID;
        _activities = activities;
        _creatorID = creatorID;
        _creationDate = creationDate;
        _photos = photos;
        _ratings = ratings;
        _tips = tips;
        
    }
    
    return self;
}


@end
