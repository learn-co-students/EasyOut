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
    
    NSLog(@"Getting activities from Foursquare");
 
    NSString *urlString = [NSString stringWithFormat: @"%@v2/venues/explore?client_id=%@&client_secret=%@&v=20140806&m=foursquare&ll=%@&limit=50&openNow=1&section=%@&venuePhotos=1", FSQ_BASE_URL, FOURSQUARE_CLIENT_ID, FOURSQUARE_CLIENT_SECRET,location,section];
    
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
            
            NSLog(@"Something went wrong calling Foursquare! Status code %lu", httpResponse.statusCode);
        }
        
        NSDictionary *activityDictionary = [NSJSONSerialization JSONObjectWithData:data  options:0 error:nil];
        
        completion(activityDictionary[@"response"][@"groups"][0][@"items"]);
        
    }];
    
 
    [task resume];
}

@end
