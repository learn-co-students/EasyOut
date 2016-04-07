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
               image:(NSString *)imageURL {
    
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
    }
    return self;
}




@end
