//
//  OpenTableAPIClient.h
//  EggplantButton
//
//  Created by Stephanie on 3/30/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenTableAPIClient : NSObject

+(void)getRestaurantWithCompletion:(void (^) (NSArray *restaurants)) completion;


@end
