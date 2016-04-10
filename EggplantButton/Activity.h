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
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSData *imageData;

-(instancetype)initWithName:(NSString *)name
                    address:(NSString *)address
                       city:(NSString *)city
                 postalCode:(NSString *)postalCode
                   imageURL:(NSURL *)imageURL;


@end
