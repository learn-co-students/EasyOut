//
//  TicketMasterAPIClient.h
//  ticketMasterApi
//
//  Created by Adrian Brown  on 4/1/16.
//  Copyright © 2016 Adrian Brown . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketMasterAPIClient : NSObject

+(void)getEventsForLat:(NSString *)lat lng:(NSString *)lng withCompletion:(void (^)(NSArray * events))completionBlock;

@end
