//
//  Activity.h
//  EasyOut
//
//  Created by Stephanie on 4/7/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *address;
@property (strong, nonatomic) NSArray *fullAddress;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *openStatus;
@property (strong, nonatomic) NSURL *icon;
@property (strong, nonatomic) NSString *moreDetailsURL;
@property (strong, nonatomic) NSString *distance;

-(instancetype)initWithDictionary:(NSDictionary *)activityDictionary;
-(instancetype)initWithFirebaseDictionary:(NSDictionary *)dictionary;

+(Activity *)activityFromDictionary:(NSDictionary *)activityDictionary;

@end
