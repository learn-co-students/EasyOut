//
//  Activity.h
//  EggplantButton
//
//  Created by Stephanie on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSURL *moreDetailsURL;


-(instancetype)initWithDictionary:(NSDictionary *)activityDictionary;

+(Activity *)activityFromDictionary:(NSDictionary *)activityDictionary;


@end
