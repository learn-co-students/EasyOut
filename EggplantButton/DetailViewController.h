//
//  DetailViewController.h
//  EggplantButton
//
//  Created by Stephanie on 4/11/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Activity.h"
#import "Restaurant.h"
#import "Event.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Activity *activity;

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

@end
