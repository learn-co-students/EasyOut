//
//  RestaurantDataStore.m
//  EggplantButton
//
//  Created by Stephanie on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "RestaurantDataStore.h"
#import "OpenTableAPIClient.h"
#import "Restaurant.h"

@implementation RestaurantDataStore

+ (instancetype)sharedDataStore {
    static RestaurantDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[RestaurantDataStore alloc] init];
    });
    
    return _sharedDataStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _restaurants = [[NSMutableArray alloc]init];
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
