//
//  OpenTableAPIClient.m
//  EggplantButton
//
//  Created by Stephanie on 3/30/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "OpenTableAPIClient.h"
#import <AFNetworking.h>


@implementation OpenTableAPIClient

NSString *const OT_API_URL = @"http://opentable.herokuapp.com";

+(void)getRestaurantWithCompletion:(void (^) (NSArray * restaurants)) completion {

    NSString *opentableURL = [NSString stringWithFormat:@"%@/api/restaurants?zip=11103", OT_API_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:opentableURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completion(responseObject[@"restaurants"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Fail: %@",error.localizedDescription);
        
    }];

}
@end
