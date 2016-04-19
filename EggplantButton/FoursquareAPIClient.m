 //
//  FoursquareAPIClient.m
//  EggplantButton
//
//  Created by Stephanie on 4/17/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "FoursquareAPIClient.h"
#import "Secrets.h"

// arts, outdoors, sights, food, drinks

NSString * const FSQ_BASE_URL= @"https://api.foursquare.com/";

@implementation FoursquareAPIClient

+(void)getActivityforSection:(NSString *)section Location:(NSString *)location WithCompletion:(void (^) (NSArray *activities)) completion {
 
    
#warning CHANGE TO LAT LONG!
    NSString *urlString = [NSString stringWithFormat: @"%@v2/venues/explore?client_id=%@&client_secret=%@&v=20140806&m=foursquare&ll=%@&section=%@&venuePhotos=1", FSQ_BASE_URL, FOURSQUARE_CLIENT_ID, FOURSQUARE_CLIENT_SECRET,location,section];
    
    //time
    //price
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * data, NSURLResponse * response, NSError *  error) {
        
        if(error) {
            NSLog(@"Error: %@", error.description);

            return;
        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

        if(httpResponse.statusCode != 200) {

            NSLog(@"Something went wrong :( Status code %lu", httpResponse.statusCode);
        }
        
        NSDictionary *activityDictionary = [NSJSONSerialization JSONObjectWithData:data  options:0 error:nil];
        
    
        
        completion(activityDictionary[@"response"][@"groups"][0][@"items"]);
        
    }];
    
 
    [task resume];
    
}
//    NSString *forusquareURL = [NSString stringWithFormat:@"%@latlong=%@,%@&radius=15&startDateTime=%@&apikey=%@",TM_BASE_URL ,lat,lng,dateString,consumerKey];
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    [manager GET:ticketMasterURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
//        
//        NSLog(@"%@", ticketMasterURL);
//        
//        NSArray *events = responseObject[@"_embedded"][@"events"];
//        
//        completionBlock(events);
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//        NSLog(@"Error: %@", error);
//        
//    }];
    
    



@end
