//
//  Restaurant.m
//  EggplantButton
//
//  Created by Stephanie on 3/30/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "Restaurant.h"


@implementation Restaurant

-(instancetype)initWithDictionary:(NSDictionary *)restaurantDictionary {
    
    self = [super initWithName:restaurantDictionary[@"name"]
                       address:restaurantDictionary[@"address"]
                          city:restaurantDictionary[@"city"] postalCode:restaurantDictionary[@"postal_code"]
                      imageURL:[NSURL URLWithString: restaurantDictionary[@"image_url"]]
                  activityType:RestaurantType];
    
    if(self) {
        _price = [restaurantDictionary[@"price"] stringValue];
        _reserveURL = restaurantDictionary[@"reserve_url"];
        _phonenumber =  restaurantDictionary[@"phone"];
        _lat = [restaurantDictionary[@"latitude"] integerValue];
        _lng = [restaurantDictionary[@"longitude"] integerValue];
    }

    return self;
}


+(Restaurant *)restaurantFromDictionary:(NSDictionary *)restaurantDictionary {
    
    Restaurant *newRestaurant = [[Restaurant alloc]initWithDictionary:restaurantDictionary];
    
    NSLog(@"new restaurant: %@", newRestaurant.name);
    
    return newRestaurant;
    
}
@end

//    for (NSString *key in restaurantDictionary) {
//        id value = restaurantDictionary[key];
//        NSLog(@"%@ is a number? : %@", key, [value isKindOfClass:[NSNumber class]] ? @"YES" : @"NO");
//    }
