//
//  Itinerary.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "Itinerary.h"

@implementation Itinerary

// Initialize a new Itinerary object when saving an itinerary from the main view controller
-(instancetype)initWithActivities:(NSMutableArray *) activities
                           userID:(NSString *)userID
                     creationDate:(NSDate *)creationDate
{
    self = [super init];
    
    if(self) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [dateFormatter stringFromDate:creationDate];
        
        _itineraryID = @"";
        _activities = activities;
        _userID = userID;
        _creationDate = creationDate;
        _photos = [[NSMutableArray alloc] init];
        _ratings = [[NSMutableDictionary alloc] init];
        _tips = [[NSMutableArray alloc] init];
        _title = [NSString stringWithFormat:@"Itinerary for %@", dateString];
    }
    
    return self;
    
}

// Initializer for Firebase dictionaries
-(instancetype)initWithItineraryDictionary:(NSDictionary *)dictionary {
    
    NSMutableDictionary *newDictionary = [dictionary mutableCopy];
    
    NSArray *keys = [dictionary allKeys];
    
    // Check for empty dictionaries that Firebase may not have saved
    if (![keys containsObject:@"activities"]) {
        [newDictionary setObject:[[NSMutableArray alloc] init] forKey:@"activities"];
    }
    if (![keys containsObject:@"photos"]) {
        [newDictionary setObject:[[NSMutableArray alloc] init] forKey:@"photos"];
    }
    if (![keys containsObject:@"tips"]) {
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"tips"];
    }
    if (![keys containsObject:@"ratings"]) {
        [newDictionary setObject:[[NSMutableDictionary alloc] init] forKey:@"ratings"];
    }
    
    self = [self initWithUserID:newDictionary[@"userID"]
                    itineraryID:newDictionary[@"itineraryID"]
                          title:newDictionary[@"title"]
                   creationDate:newDictionary[@"creationDate"]
                     activities:newDictionary[@"activities"]
                         photos:newDictionary[@"photos"]
                        ratings:newDictionary[@"ratings"]
                           tips:newDictionary[@"tips"]
            ];
    
    NSLog(@"User initialized from Firebase dictionary");
    
    return self;
}

// Designated initializer
-(instancetype)initWithUserID:(NSString *)userID
                  itineraryID:(NSString *)itineraryID
                        title:(NSString *)title
                 creationDate:(NSDate *)creationDate
                   activities:(NSMutableArray *)activities
                       photos:(NSMutableArray *)photos
                      ratings:(NSMutableDictionary *)ratings
                         tips:(NSMutableDictionary *)tips {
    
    return self;
}

@end
