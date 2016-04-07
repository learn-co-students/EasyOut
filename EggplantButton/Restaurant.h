//
//  Restaurant.h
//  EggplantButton
//
//  Created by Stephanie on 3/30/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>
#import "Activity.h"

@interface Restaurant : Activity

@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *phonenumber;
@property (strong, nonatomic) NSURL *reserveURL;

-(instancetype)initWithDictionary:(NSDictionary *)restaurantDictionary;

+(Restaurant *)restaurantFromDictionary:(NSDictionary *)restaurantDictionary;

@end
