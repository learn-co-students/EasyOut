//
//  ActivityCardView.h
//  EasyOut
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "Event.h"
#import "Activity.h"


@interface ActivityCardView : UIView


@property (strong, nonatomic) UIView * contentSuperview;

@property (strong, nonatomic) Activity *activity;

@end
 