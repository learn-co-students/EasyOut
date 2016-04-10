//
//  OpenTableAPIClient.m
//  EggplantButton
//
//  Created by Stephanie on 3/30/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "OpenTableAPIClient.h"
#import "AFNetworking.h"


@implementation OpenTableAPIClient

NSString *const OT_API_URL = @"http://opentable.herokuapp.com";

+(void)getRestaurantWithCompletion:(void (^) (NSArray * restaurants)) completion {
    
    NSString *opentableURL = [NSString stringWithFormat:@"%@/api/restaurants?city=New York&per_page=100", OT_API_URL];
    
    NSString* urlTextEscaped = [opentableURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlTextEscaped parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSMutableArray *completeResponse = [[NSMutableArray alloc]init];
        
        NSInteger totalPages = [(NSNumber *)responseObject[@"total_entries"] integerValue]/[(NSNumber *)responseObject[@"per_page"] integerValue];
        
        NSLog(@"%ld", (long)totalPages);
        
        __block NSInteger currentPage = 1;
        
        __block NSInteger pagesAddedToArray = 0;
        
        while(currentPage <= totalPages) {
            
            NSString *pageURL = [NSString stringWithFormat:@"%@/api/restaurants?city=New York&per_page=100&page=%ld", OT_API_URL, (long)currentPage];
            
            NSString* pageUrlTextEscaped = [pageURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            AFHTTPSessionManager *pageManager = [AFHTTPSessionManager manager];
            
            [pageManager GET:pageUrlTextEscaped parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                
                [completeResponse addObjectsFromArray: (NSArray *)responseObject[@"restaurants"]];
                
                pagesAddedToArray++;
                
                if (pagesAddedToArray == totalPages) {
                    
                    completion(completeResponse);
                }
                
            }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         
                         NSLog(@"Fail: %@",error.localizedDescription);
                         
                     }];
            
            currentPage++;
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Fail: %@",error.localizedDescription);
        
    }];
    
}

@end
