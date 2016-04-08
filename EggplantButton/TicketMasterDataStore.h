//
//  TicketMasterDataStore.h
//  EggplantButton
//
//  Created by Adrian Brown  on 4/6/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketMasterAPIClient.h"
#import <CoreLocation/CoreLocation.h>
#import "TicketMasterEvent.h"

@interface TicketMasterDataStore : NSObject


@property (nonatomic,strong) NSMutableArray *allEvents;

+(instancetype)sharedDataStore;
-(instancetype)init;
-(void)getEventsForLocation: (CLLocation *) location withCompletion: (void (^)(BOOL))successBlock;

@end
