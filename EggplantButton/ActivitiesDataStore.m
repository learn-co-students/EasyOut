//
//  ActivitiesDataStore.m
//  EasyOut
//
//  Created by Stephanie on 4/7/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "Activity.h"
#import "ActivitiesDataStore.h"
#import "FoursquareAPIClient.h"


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
        _randoms = [[NSMutableArray alloc]init];
        _restaurants = [[NSMutableArray alloc]init];
        _drinks = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)getActivityforSection:(NSString *)section Location: (NSString *)location WithCompletion:(void (^)(BOOL success))completionBlock
{
    [FoursquareAPIClient getActivityforSection:section Location:location WithCompletion:^(NSArray *activities) {
        
        for(NSDictionary *activity in activities) {
            
            NSArray *randomsOptions = @[@"arts", @"outdoors", @"sights"];
            NSArray *restaurantsOptions = @[@"food", @"trending"];
            NSArray *drinksOptions =  @[@"drinks", @"nextVenues"];
            
            if (!activity) {
                
                completionBlock(NO);
                return;
            }
            
            Activity *newActivity = [Activity activityFromDictionary:activity];

            if([randomsOptions containsObject:section]) {
                
                [self.randoms addObject:newActivity];
                
            }

            else if([restaurantsOptions containsObject:section]) {
                
                [self.restaurants addObject:newActivity];
                
            }
            else if([drinksOptions containsObject:section]) {
                
                [self.drinks addObject:newActivity];
            }
        }
        completionBlock(YES);
    }];
    

    
}


@end
