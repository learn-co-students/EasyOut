//
//  TicketMasterAPIClient.h
//  ticketMasterApi
//
//  Created by Adrian Brown  on 4/1/16.
//  Copyright © 2016 Adrian Brown . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TicketMasterAPIClient : NSObject <CLLocationManagerDelegate>

+(void)getEventsFromLocation: (CLLocation *) location completion:(void (^)(NSArray *))completionBlock;


@end
