//
//  ActivitiesDataStore.h
//  EggplantButton
//
//  Created by Stephanie on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivitiesDataStore : NSObject

@property (strong, nonatomic) NSMutableArray *restaurants;
@property (nonatomic,strong) NSMutableArray *events;


+ (instancetype)sharedDataStore;


-(void)getRestaurantsWithCompletion:(void (^)(BOOL success))completionBlock;

-(void)getEventsForLat:(NSString *)lat lng:(NSString *)lng withCompletion:(void (^)(BOOL success))completionBlock;


@end
