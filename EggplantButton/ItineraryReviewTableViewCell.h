//
//  ItineraryReviewTableViewCell.h
//  EggplantButton
//
//  Created by Stephanie on 4/24/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItineraryReviewTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@end
