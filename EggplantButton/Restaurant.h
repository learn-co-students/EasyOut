//
//  Restaurant.h
//  EggplantButton
//
//  Created by Stephanie on 3/30/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zipCode;
@property (strong, nonatomic) NSString *phonenumber;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *reserveURL;

+(Restaurant *)restaurantFromDictionary:(NSDictionary *)restaurantDictionary;

@end
