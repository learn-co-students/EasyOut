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

-(instancetype)initWithFirebaseDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    
    NSMutableDictionary *newDictionary = [dictionary mutableCopy];
    
    NSArray *keys = [dictionary allKeys];
    
    // PRICE
    if (![keys containsObject:@"price"]) {
        [newDictionary setObject:[[NSString alloc] init] forKey:@"price"];
    } else {
        NSLog(@"Price exists for current activity, but we aren't getting them from Firebase");
    }
    
    // MORE DETAILS URL
    if (![keys containsObject:@"moreDetailsURL"]) {
        [newDictionary setObject:[[NSURL alloc] initWithString:@"https://google.com"] forKey:@"moreDetailsURL"];
    } else {
        NSLog(@"moreDetailsURL exist for current activity, but we aren't getting them from Firebase");
    }
    
    if (self) {
        
        _name = newDictionary[@"name"];
        _address = @[newDictionary[@"address0"], newDictionary[@"address1"]];
        _type = newDictionary[@"type"];
        _imageURL = [NSURL URLWithString:newDictionary[@"imageURL"]];
        _price = newDictionary[@"price"];
        _moreDetailsURL = newDictionary[@"moreDetailsURL"];
        
    }
    
    return self;
}

+(Activity *)activityFromDictionary:(NSDictionary *)activityDictionary {
    
    Activity *activity = [[Activity alloc]initWithDictionary:activityDictionary];
    
    return activity;
}

@end
