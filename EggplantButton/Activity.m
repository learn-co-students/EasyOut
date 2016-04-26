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
        
        NSMutableArray *mAddress = [[NSMutableArray alloc]init];
        
        NSMutableString *address = [(NSString *)activityDictionary[@"venue"][@"location"][@"formattedAddress"][0] mutableCopy];
        
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:@"\\(.+?\\)"
                                      options:NSRegularExpressionCaseInsensitive
                                      error:NULL];
        
        [regex replaceMatchesInString:address
                              options:0
                                range:NSMakeRange(0, [address length])
                         withTemplate:@""];
        
        [mAddress addObject: address];
        [mAddress addObject: activityDictionary[@"venue"][@"location"][@"formattedAddress"][1]];
         _address = mAddress ;
        
        NSMutableArray *fAddress = [[NSMutableArray alloc]init];
        [fAddress addObject:(NSString *)activityDictionary[@"venue"][@"location"][@"formattedAddress"][0]];
        [fAddress addObject:(NSString *)activityDictionary[@"venue"][@"location"][@"formattedAddress"][1]];
        
        _fullAddress = fAddress;
        
        _type = activityDictionary[@"venue"][@"categories"][0][@"shortName"];
    
        if ([activityDictionary[@"venue"][@"photos"][@"groups"] count] > 0 ) {
            _imageURL = [NSURL URLWithString: [NSString stringWithFormat: @"%@%@%@", activityDictionary[@"venue"][@"photos"][@"groups"][0][@"items"][0][@"prefix"], @"150x150", activityDictionary[@"venue"][@"photos"][@"groups"][0][@"items"][0][@"suffix"]]];
        }
        else {
            _imageURL = [NSURL URLWithString:@"https://cdn1.iconfinder.com/data/icons/social-17/48/photos2-512.png"];
        }
        
        if(activityDictionary[@"venue"][@"price"][@"currency"]) {
            
            _price = activityDictionary[@"venue"][@"price"][@"currency"];
        }
        else {
            _price = @"$";

        }
        _moreDetailsURL = activityDictionary[@"tips"][0][@"canonicalUrl"];
     
        _openStatus = activityDictionary[@"venue"][@"hours"][@"status"];
        
        _icon = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@%@", activityDictionary[@"venue"][@"categories"][0][@"icon"][@"prefix"], @"88", activityDictionary[@"venue"][@"categories"][0][@"icon"][@"suffix"]]];
        
        
        
        _distance = [[activityDictionary[@"venue"][@"location"][@"distance"] floatValue] * [0.000621371 floatValue];
        
    }
    
    return self;
}

+(Activity *)activityFromDictionary:(NSDictionary *)activityDictionary {
    
    Activity *activity = [[Activity alloc]initWithDictionary:activityDictionary];
    
    return activity;
}

@end
