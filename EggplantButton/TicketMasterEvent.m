//
//  TicketMasterEvents.m
//  ticketMasterApi
//
//  Created by Adrian Brown  on 4/4/16.
//  Copyright © 2016 Adrian Brown . All rights reserved.
//

#import "TicketMasterEvent.h"

@implementation TicketMasterEvent

-(instancetype)initWithDictionary:(NSDictionary *)eventDictionary{

    self = [super initWithName:eventDictionary[@"name"]
                       address:eventDictionary[@"_embedded"][@"venues"][0][@"address"][@"line1"]
                          city:eventDictionary[@"_embedded"][@"venues"][0][@"city"][@"name"]
                    postalCode:eventDictionary[@"_embedded"][@"venues"][0][@"postalCode"]
                      imageURL:[NSURL URLWithString: eventDictionary[@"images"][4][@"url"]]];
    if(self) {
        
        _eventID = eventDictionary[@"id"];
        _eventURL = eventDictionary[@"url"];
        _date = eventDictionary[@"localDate"];
        _time = eventDictionary[@"localTime"];
        _segment = segment;
        _genre = genre;
        _subGenre = subGenre;

    }
    
    return self;

}



// +(Restaurant *)restaurantFromDictionary:(NSDictionary *)restaurantDictionary
+(TicketMasterEvent *)eventFromDictionary:(NSDictionary *)eventDictionary {
    
    TicketMasterEvent *newEvent = [[TicketMasterEvent alloc]init];

    
    NSArray *image = eventDictionary[@"images"];
    newEvent.imageURL = [NSURL URLWithString: image[4][@"url"]];
    
    NSArray *venues = eventDictionary[@"_embedded"][@"venues"];
    newEvent.address = ;
    newEvent.city = eventDictionary[@"_embedded"][@"venues"][0][@"city"][@"name"];
    
    newEvent.postalCode = eventDictionary[@"_embedded"][@"venues"][0][@"postalCode"];
    
    NSDictionary *allClassifications = classifications.firstObject;
    NSString *genre = allClassifications[@"genre"][@"name"];
    NSString *subGenre = allClassifications[@"subGenre"][@"name"];
    NSString *segment = allClassifications[@"segment"][@"name"];
    
    
    return newEvent;
}
@end
