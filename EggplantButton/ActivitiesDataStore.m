//
//  ActivitiesDataStore.m
//  EggplantButton
//
//  Created by Stephanie on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ActivitiesDataStore.h"
#import "OpenTableAPIClient.h"
#import "Restaurant.h"
#import "TicketMasterAPIClient.h"
#import "TicketMasterEvent.h"


@implementation ActivitiesDataStore

+ (instancetype)sharedDataStore {
    static ActivitiesDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[ActivitiesDataStore alloc] init];
    });
    
    return _sharedDataStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _restaurants = [[NSMutableArray alloc]init];
        _events = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)getRestaurantsWithCompletion:(void (^)(BOOL success))completionBlock
{
    [OpenTableAPIClient getRestaurantWithCompletion:^(NSArray *restaurants) {
        
        for(NSDictionary *restaurant in restaurants) {
            
            [self.restaurants addObject:[Restaurant restaurantFromDictionary:restaurant]];
            
        }
        
        completionBlock(YES);
    }];
    
}

@end
