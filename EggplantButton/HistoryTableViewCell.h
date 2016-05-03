//
//  HistoryTableViewCell.h
//  EasyOut
//
//  Created by Stephanie on 4/28/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"

@interface HistoryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *itineraryLabel;
@property (strong, nonatomic) Itinerary *itinerary;

@end
