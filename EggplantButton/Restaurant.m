//
//  Restaurant.m
//  EggplantButton
//
//  Created by Stephanie on 3/30/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant


+(Restaurant *)restaurantFromDictionary:(NSDictionary *)restaurantDictionary {
    
//    for (NSString *key in restaurantDictionary) {
//        id value = restaurantDictionary[key];
//        NSLog(@"%@ is a number? : %@", key, [value isKindOfClass:[NSNumber class]] ? @"YES" : @"NO");
//    }
    
    Restaurant *newRestaurant = [[Restaurant alloc]init];
    newRestaurant.name = restaurantDictionary[@"name"];
    newRestaurant.address = restaurantDictionary[@"address"];
    newRestaurant.city = restaurantDictionary[@"city"];;
    newRestaurant.state = restaurantDictionary[@"state"];
    newRestaurant.zipCode = restaurantDictionary[@"postal_code"];
    newRestaurant.phonenumber = restaurantDictionary[@"phone"];
    newRestaurant.price = [restaurantDictionary[@"price"] stringValue];
    newRestaurant.imageURL = [NSURL URLWithString: restaurantDictionary[@"image_url"]];
    newRestaurant.latitude = [restaurantDictionary[@"latitude"] stringValue];
    newRestaurant.longitude = [restaurantDictionary[@"longitude"] stringValue];
    newRestaurant.reserveURL = restaurantDictionary[@"reserve_url"];
    
    return newRestaurant;
    
}
@end
