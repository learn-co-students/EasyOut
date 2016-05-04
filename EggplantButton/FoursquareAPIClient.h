//
//  FoursquareAPIClient.h
//  EasyOut
//
//  Created by Stephanie on 4/17/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoursquareAPIClient : NSObject

+(void)getActivityforSection:(NSString *)section Location:(NSString *)location WithCompletion:(void (^) (NSArray *activities)) completion;


@end
