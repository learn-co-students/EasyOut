//
//  UserProfileItineraryTableViewCell.h
//  EasyOut
//
//  Created by Ian Alexander Rahman on 5/3/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"

@interface UserProfileItineraryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *itineraryLabel;
@property (strong, nonatomic) Itinerary *itinerary;

@end
