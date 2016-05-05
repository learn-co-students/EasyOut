//
//  ItineraryViewController.h
//  EasyOut
//
//  Created by Adrian Brown  on 4/19/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"
#import "CardViewController.h"
@interface ItineraryViewController : UIViewController

@property (strong, nonatomic) Itinerary *itinerary;

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@end
