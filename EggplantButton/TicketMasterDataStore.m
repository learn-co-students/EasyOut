//
//  TicketMasterDataStore.m
//  EggplantButton
//
//  Created by Adrian Brown  on 4/6/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "TicketMasterDataStore.h"
#import "TicketMasterEvent.h"

@implementation TicketMasterDataStore


+ (instancetype)sharedDataStore {
    
    static TicketMasterDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[TicketMasterDataStore alloc]init];
    });
    return _sharedDataStore;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _allEvents = [[NSMutableArray alloc]init];
        
    }
    return self; 
}

-(void)getEventsForLocation: (CLLocation *) location withCompletion: (void (^)(BOOL))successBlock {
    
    [TicketMasterAPIClient getEventsFromLocation:location completion:^(NSArray *events) {
    
        // handling error (pass nil from API if there is an error)
        if (!events) {
            successBlock(NO);
            return;
        }
        
        // for loop to create event objects,
        NSMutableArray *allEvents = [NSMutableArray new];
        
        for (NSDictionary *eventDictionary in events) {
    
            NSString *eventID = eventDictionary[@"id"];
            NSString *eventURL = eventDictionary[@"url"];
            NSString *name = eventDictionary[@"name"];
            
            NSDictionary *dateAndTime = eventDictionary[@"dates"][@"start"];
            NSString *localDate = dateAndTime[@"localDate"];
            NSString *localTime = dateAndTime[@"localTime"];
            
            NSArray *classifications = eventDictionary[@"classifications"];
            
            NSDictionary *allClassifications = classifications.firstObject;
            NSString *genre = allClassifications[@"genre"][@"name"];
            NSString *subGenre = allClassifications[@"subGenre"][@"name"];
            NSString *segment = allClassifications[@"segment"][@"name"];
            
            NSArray *images = eventDictionary[@"images"];
            NSString *image = images[4][@"url"];
            
            
            
            NSLog(@"\n\nTicketMasterEvent:\n\nid: %@\nurl: %@\nname: %@\nlocalDate: %@\nlocalTime: %@\ngenre: %@\nsubGenre: %@\nsegment: %@\nimageURL: %@\n\n",eventID,eventURL,name,localDate,localTime,genre,subGenre,segment,image);
            TicketMasterEvent *newEvent = [TicketMasterEvent eventFromDictionary:eventDictionary];
            [allEvents addObject:newEvent];
        }

        // add to array to pass around
        self.allEvents = allEvents;
        successBlock(YES);    
    }];
    
}
@end
