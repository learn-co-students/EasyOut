//
//  TicketMasterEvents.m
//  ticketMasterApi
//
//  Created by Adrian Brown  on 4/4/16.
//  Copyright © 2016 Adrian Brown . All rights reserved.
//

#import "TicketMasterEvent.h"

@implementation TicketMasterEvent

-(instancetype)initWithEventID:(NSString *)eventID
                           url:(NSString *)eventURL
                          name:(NSString *)name
                          date:(NSString *)date
                          time:(NSString *)time
                       segment:(NSString *)segment
                         genre:(NSString *)genre
                      subGenre:(NSString *)subGenre
                         image:(NSString *)imageURL
                       address:(NSString *)address
                          city:(NSString *)city
                    postalCode:(NSString *)postalCode {
    
    self = [super init];
    if (self) {
        _eventID = eventID;
        _eventURL = eventURL;
        _name = name;
        _date = date;
        _time = time;
        _segment = segment;
        _genre = genre;
        _subGenre = subGenre;
        _imageURL = imageURL;
        _address = address;
        _city = city;
        _postalCode = postalCode;
    }
    return self;
}


// +(Restaurant *)restaurantFromDictionary:(NSDictionary *)restaurantDictionary
+(TicketMasterEvent *)eventFromDictionary:(NSDictionary *)eventDictionary {
    
    TicketMasterEvent *newEvent = [[TicketMasterEvent alloc]init];
    newEvent.name = eventDictionary[@"name"];
    newEvent.date = eventDictionary[@"localDate"];
    newEvent.time = eventDictionary[@"localTime"];
    
    newEvent.eventID = eventDictionary[@"id"];
    newEvent.eventURL = eventDictionary[@"url"];
    
    NSArray *image = eventDictionary[@"images"];
    newEvent.imageURL = image[4][@"url"];
    
    NSArray *venues = eventDictionary[@"_embedded"][@"venues"];
    newEvent.address = venues[0][@"address"][@"line1"];
    NSLog(@"This is the address %@",newEvent.address);
    newEvent.city = venues[0][@"city"][@"name"];
    NSLog(@"this is the city %@",newEvent.city);
    
    newEvent.postalCode = venues[0][@"postalCode"];
    NSLog(@"This is the postal code %@", newEvent.postalCode);
    
    
    return newEvent;
}
@end
