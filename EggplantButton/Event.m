//
//  Event.m
//  EggplantButton
//
//  Created by Adrian Brown  on 4/4/16.
//  Copyright © 2016 Adrian Brown . All rights reserved.
//

#import "Event.h"

@implementation Event

-(instancetype)initWithDictionary:(NSDictionary *)eventDictionary{

    self = [super initWithName:eventDictionary[@"name"]
                       address:eventDictionary[@"_embedded"][@"venues"][0][@"address"][@"line1"]
                          city:eventDictionary[@"_embedded"][@"venues"][0][@"city"][@"name"]
                    postalCode:eventDictionary[@"_embedded"][@"venues"][0][@"postalCode"]
                      imageURL:[NSURL URLWithString: eventDictionary[@"images"][4][@"url"]]
                  activityType:EventType];
    if(self) {
        
        _eventID = eventDictionary[@"id"];
        _eventURL = eventDictionary[@"url"];
        _date = eventDictionary[@"localDate"];
        _time = eventDictionary[@"localTime"];
        _segment = eventDictionary[@"classifications"][0][@"segment"][@"name"];
        _genre = eventDictionary[@"classifications"][0][@"genre"][@"name"];;
        _subGenre = eventDictionary[@"classifications"][0][@"subGenre"][@"name"];

    }
    
    return self;

}


+(Event *)eventFromDictionary:(NSDictionary *)eventDictionary {
    
    Event *newEvent = [[Event alloc]initWithDictionary:eventDictionary];
        
    return newEvent;
}
@end
