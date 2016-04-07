//
//  Photo.h
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Itinerary.h"

@import UIKit;

@interface Photo : NSObject

@property (strong, nonatomic) NSString *photoID;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSDate *dateAdded;
@property (strong, nonatomic) NSString *imageID;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) Itinerary *itinerary;
//@property (strong, nonatomic) Activity *activity;

@end
