//
//  TicketMasterAPIClient.m
//  ticketMasterApi
//
//  Created by Adrian Brown  on 4/1/16.
//  Copyright © 2016 Adrian Brown . All rights reserved.
//

#import "TicketMasterAPIClient.h"
#import "AFNetworking.h"
#import "Event.h"
#import "Secrets.h"

@implementation TicketMasterAPIClient

NSString *const TM_BASE_URL = @"https://app.ticketmaster.com/discovery/v2/events.json?";

+(void)getEventsForLat:(NSString *)lat lng:(NSString *)lng withCompletion:(void (^)(NSArray *))completionBlock {
    
    //DATE FORMATTING
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'Z'"];
    NSString *dateString = [dateFormat stringFromDate:now];
    
    
    
#warning need to add start date and time!!!
    //NETWORKING
    NSString *ticketMasterURL = [NSString stringWithFormat:@"%@latlong=%@,%@&radius=15&startDateTime=%@&apikey=%@",TM_BASE_URL ,lat,lng,dateString,consumerKey];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:ticketMasterURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        NSLog(@"%@", ticketMasterURL);
        
        NSArray *events = responseObject[@"_embedded"][@"events"];
             
        completionBlock(events);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
}






@end
