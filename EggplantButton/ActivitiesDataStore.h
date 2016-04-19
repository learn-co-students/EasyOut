//
//  ActivitiesDataStore.h
//  EggplantButton
//
//  Created by Stephanie on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivitiesDataStore : NSObject

@property (strong, nonatomic) NSMutableArray *randoms;
@property (strong, nonatomic) NSMutableArray *restaurants;
@property (nonatomic,strong) NSMutableArray *drinks;


+ (instancetype)sharedDataStore;


-(void)getActivityforSection:(NSString *)section Location: (NSString *)location WithCompletion:(void (^)(BOOL success))completionBlock;


@end
