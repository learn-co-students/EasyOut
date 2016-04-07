//
//  Activity.m
//  EggplantButton
//
//  Created by Stephanie on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "Activity.h"

@implementation Activity

-(instancetype)initWithName:(NSString *)name
                    address:(NSString *)address
                       city:(NSString *)city
                 postalCode:(NSString *)postalCode
                   imageURL:(NSURL *)imageURL {
    
    self = [super init];
    if(self) {
        _name = name;
        _address = address;
        _city = city;
        _postalCode = postalCode;
        _imageURL = imageURL;
        _imageData = [NSData dataWithContentsOfURL:imageURL];
        
    }
    
    return self;
}


@end
