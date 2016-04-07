//
//  TicketMasterAPIClient.m
//  ticketMasterApi
//
//  Created by Adrian Brown  on 4/1/16.
//  Copyright © 2016 Adrian Brown . All rights reserved.
//

#import "TicketMasterAPIClient.h"
#import "TicketMasterEvent.h"
#import "Secrets.h"

@implementation TicketMasterAPIClient

NSString *const TM_BASE_URL = @"https://app.ticketmaster.com/discovery/v2/events.json?";

+(void)getEventsFromLocation: (CLLocation *)location completion:(void (^)(NSArray *))completionBlock {
    
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'Z'"];
    NSString *dateString = [dateFormat stringFromDate:now];
    NSLog(@"THE FORMATTED DATE: %@",dateString);
    
    NSString *baseURLTwo = [NSString stringWithFormat:@"%@latlong=%f,%f&radius=25&startDateTime=%@&apikey=%@",TM_BASE_URL ,location.coordinate.latitude,location.coordinate.longitude,dateString,consumerKey];
    
    NSLog(@"%@", baseURLTwo);
    
    NSURL *URL = [NSURL URLWithString:baseURLTwo];
    NSLog(@"%@",URL);
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            // FIXME: Handle error...
            completionBlock(nil);
            return;
        }
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
            NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
        }
        
        NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response Body:\n%@\n", body);
        
        
        NSDictionary *eventsReturned = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSLog(@"===========respone : %@========", eventsReturned);
        
        
        // array of events inside of events returned dictionary
        NSArray *events = eventsReturned[@"_embedded"][@"events"];
        
        completionBlock(events);
        
        
    }];
    
    
    [task resume];
    
    
}






@end
