//
//  TicketMasterEvents.h
//  ticketMasterApi
//
//  Created by Adrian Brown  on 4/4/16.
//  Copyright © 2016 Adrian Brown . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TicketMasterEvent : NSObject

@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSString *eventURL;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *segment;
@property (strong, nonatomic) NSString *genre;
@property (strong, nonatomic) NSString *subGenre;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *postalCode;



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
                          city:(NSString*)city
                    postalCode:(NSString *)postalCode;


+(TicketMasterEvent *)eventFromDictionary:(NSDictionary *)eventDictionary;



@end
