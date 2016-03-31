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
    
    Restaurant *newRestaurant = [[Restaurant alloc]init];
    newRestaurant.name = restaurantDictionary[@"name"];
    newRestaurant.address = restaurantDictionary[@"address"];
    newRestaurant.city = restaurantDictionary[@"city"];;
    newRestaurant.state = restaurantDictionary[@"state"];
    newRestaurant.zipCode = restaurantDictionary[@"postal_code"];
    newRestaurant.phonenumber = restaurantDictionary[@"phone"];
    newRestaurant.price = restaurantDictionary[@"price"];
    newRestaurant.imageURL = [NSURL URLWithString: restaurantDictionary[@"image_url"]];
    newRestaurant.latitude = restaurantDictionary[@"latitude"];
    newRestaurant.longitude = restaurantDictionary[@"longitude"];
    newRestaurant.reserveURL = restaurantDictionary[@"reserve_url"];
    
    return newRestaurant;
    
}
@end
