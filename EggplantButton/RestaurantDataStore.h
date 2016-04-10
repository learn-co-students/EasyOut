//
//  RestaurantDataStore.h
//  EggplantButton
//
//  Created by Stephanie on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantDataStore : NSObject

@property (strong, nonatomic) NSMutableArray *restaurants;

+ (instancetype)sharedDataStore;


-(void)getRestaurantsWithCompletion:(void (^)(BOOL success))completionBlock;

@end
