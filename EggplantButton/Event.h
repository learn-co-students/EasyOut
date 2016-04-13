//
//  TicketMasterEvents.h
//  ticketMasterApi
//
//  Created by Adrian Brown  on 4/4/16.
//  Copyright © 2016 Adrian Brown . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"
#import <UIKit/UIKit.h>


@interface Event : Activity

@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSString *eventURL;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *segment;
@property (strong, nonatomic) NSString *genre;
@property (strong, nonatomic) NSString *subGenre;
@property (strong, nonatomic) NSString *venueName;

-(instancetype)initWithDictionary:(NSDictionary *)eventDictionary;

+(Event *)eventFromDictionary:(NSDictionary *)eventDictionary; 



@end
