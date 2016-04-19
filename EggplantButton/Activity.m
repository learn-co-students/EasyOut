//
//  Activity.m
//  EggplantButton
//
//  Created by Stephanie on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//


#import "Activity.h"

@implementation Activity

-(instancetype)initWithDictionary:(NSDictionary *)activityDictionary{
    
    self = [super init];
    
    if(self) {
        
        _name = activityDictionary[@"venue"][@"name"];
        
        NSMutableArray *mAddress = [[NSMutableArray alloc]initWithArray: activityDictionary[@"venue"][@"location"][@"formattedAddress"]];
        _address = mAddress;
        _type = activityDictionary[@"venue"][@"shortName"];
    
        if ([activityDictionary[@"venue"][@"photos"][@"groups"] count] > 0 ) {
            _imageURL = [NSURL URLWithString: [NSString stringWithFormat: @"%@%@%@", activityDictionary[@"venue"][@"photos"][@"groups"][0][@"items"][0][@"prefix"], @"115x115", activityDictionary[@"venue"][@"photos"][@"groups"][0][@"items"][0][@"suffix"]]];
        }
        else {
            _imageURL = [NSURL URLWithString:@"https://cdn1.iconfinder.com/data/icons/social-17/48/photos2-512.png"];
        }
        _price = activityDictionary[@"price"][@"currency"];
        _moreDetailsURL = activityDictionary[@"venue"][@"tips"];
        
    }
    
    return self;
}

+(Activity *)activityFromDictionary:(NSDictionary *)activityDictionary {
    
    Activity *activity = [[Activity alloc]initWithDictionary:activityDictionary];
    
    return activity;
}

@end
